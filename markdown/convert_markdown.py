import argparse
import os
import logging
import random
import string
import subprocess

install_instructions = """
General installation instructions:
    1. Install pandoc from the pandoc website
    2. Install texlive-latex-extra
    3. sudo apt install texlive-latex-extra texlive-lang-european texlive-xetex
    4. Add several necessary packages
    5. updmap -user
    6. tlmgr init-usertree
    7. tlmgr install adjustbox babel-german background bidi collectbox csquotes everypage filehook footmisc footnotebackref framed fvextra letltxmacro ly1 mdframed mweights needspace pagecolor sourcecodepro sourcesanspro titling ucharcat ulem unicode-math upquote xecjk xurl zref
"""

default_template = os.curdir+'/eisvogel.latex'
default_highlight = os.curdir+'/custom_highlight.theme'

default_title = """titlepage: true
titlepage: true
titlepage-color: "2f92f5"
titlepage-text-color: "FFFFFF"
titlepage-rule-color: "FFFFFF"
titlepage-rule-height: 2"""

default_meta = """---
date: \\today
lang: "nl"
{titlepage}
book: true
classoption: oneside
keywords: 
output:
	pdf_document:
		md_extensions: +task_lists
code-block-font-size: \scriptsize
---
"""

def create_meta(tmp_file):
    with open(tmp_file, 'a') as f:
        f.write(default_meta.format(titlepage = default_title))


def init_logger(has_verbose):
    global logger
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG) # This is the maximum logging depth. Actual logging depth is controlled in the handler
    handler = logging.StreamHandler()
    if has_verbose:
        handler.setLevel(logging.DEBUG)
    else:
        handler.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)-23s - %(levelname)-8s - %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger

def output_install():
    logger.debug("Printing install instructions")
    print(install_instructions)
    
def spider(path, depth, max_depth,sort):
    markdown_files = []
    items = os.listdir(path)
    # Depending on the sort argument the files files are sorted by name or time
    if sort == 'date':
        items.sort(key=lambda s: os.path.getmtime(os.path.join(path, s)))
    else:
        items.sort()
    
    for item in items:
        if os.path.isfile(path + '/' + item) and item.endswith('.md'):
            markdown_files.append(path + '/' + item)
        if os.path.isdir(path + '/' + item):
            if depth < max_depth:
                markdown_files += spider(path + '/' + item,depth+1, max_depth, sort)
    return markdown_files

def process_arguments():
    parser = argparse.ArgumentParser(prog = 'Convert Markdown to pdf',
                                            description = 'This program converts a single markdown file or a directory tree with multiple markdown files into a single .pdf')
    parser.add_argument('filename', nargs='?', help = 'Path (spider mode) or filename (single mode) to convert')
    parser.add_argument('-v', '--verbose', action = 'store_true', help = 'Generate more verbose output')
    parser.add_argument('-s', '--spider', action = 'store_true', help = 'Spider the directory tree for markdown files upto --depth')
    parser.add_argument('-d', '--depth', type = int, default = 1, help = 'Maximum depth for spidering (default: %(default)s)' )
    parser.add_argument('--toc', type = int, default = 4, help = 'Levels for the table of contents (default: %(default)s)')
    parser.add_argument('-i', '--install', help = 'Print instructions for setting-up the Pandoc/Latex environment', action = 'store_true')
    parser.add_argument('-o', '--output', help = 'Custom filename for the output file (.pdf will be appended automatically)')
    parser.add_argument('--sort', default = 'name', choices =['name', 'date'], help = 'Sort the files either by name or by date (default: %(default)s)')
    parser.add_argument('--engine', default = 'xelatex', choices = ['xelatex','pdflatex'], help = 'Engine to use for the conversion to PDF (default: %(default)s)')
    parser.add_argument('--template', default = default_template, help = 'Full path to optional template (default: %(default)s)')
    parser.add_argument('--highlight', default = default_highlight, help = 'Full path to optional highlight (default: %(default)s)')
    return parser.parse_args()

def parse_line(line, md_file):
    # This function can be used to do any parsing on an individual line in the markdownfile
    file_path = '/'.join(md_file.split('/')[:-1])
    line = line.replace('(screenshots/', '(' + file_path + '/screenshots/')
    line = line.replace('(loot/', '(' + file_path + '/loot/')
    return line

def parse_markdown_files(tmp_file, md_files):
    with open(tmp_file, 'a') as tmp_file:
        for md_file in md_files:
            with open(md_file, 'r') as f:
                for line in f.readlines():
                    tmp_file.write(parse_line(line, md_file))
                #tmp_file.write('\n') # This ensures that there is always an empty line between two markdown files ensuring proper chapters.

def execute_command(args):
    tmp_files = os.listdir('/tmp')
    for tmp_file in tmp_files:
        if tmp_file.startswith('input.'):
            if os.path.isfile('/tmp/'+tmp_file):
                os.remove('/tmp/' + tmp_file)
                logger.info('Cleaning input file: /tmp/%s', tmp_file)
    if args.output:
        output_file = args.output + '.pdf'
    else:
        output_file = args.full_path.split('/')[-1]+'.pdf'
    logger.info('Creating output file with filename : %s', output_file)
    cmdline= ['pandoc',
        args.tmp_filename,
        '-o', args.full_path + '/' + output_file,
        '--resource-path='+args.full_path,
        '--from', 'markdown+yaml_metadata_block+raw_html',
        '--pdf-engine='+args.engine,
        '--pdf-engine-opt=' + '-output-directory=/tmp',
        '--template', args.template,
        '--highlight-style='+args.highlight,
        '--table-of-contents',
        '--toc-depth','%d' % args.toc,
        '--number-sections',
        '--top-level-division=' + 'chapter'
        ]
    completed = subprocess.run(cmdline)
    if completed.returncode == 0:
        logger.info("Succesfully created pdf with filename : %s", output_file)
        logger.info("Removing temporary file: %s", args.tmp_filename)
        os.remove(args.tmp_filename)
        exit(completed.returncode)
    else:
        logger.info("There was an error. Leaving temporary file: %s", args.tmp_filename)
        exit(completed.returncode)

def main():
    args = process_arguments()
    logger = init_logger(args.verbose)
    logger.debug("Arguments from cli are loaded")
    if args.spider:
        logger.debug("Spider switch is detected")
        logger.debug("Spidering will be done to a depth of %d", args.depth)
    if args.install:
        output_install()
        exit()
    
    if args.filename:
        args.full_path = os.path.abspath(args.filename)
        logger.info(args.full_path)
        if args.spider:
            markdown_files = spider(args.full_path,0,args.depth,args.sort)
            logger.debug("Spidering resulted in the following files : %s", markdown_files)
        args.tmp_filename = '/tmp/' + ''.join(random.choices(string.ascii_letters + string.digits, k = 7)) + '.md'
        logger.info("Using temporary file: %s", args.tmp_filename)

        if os.path.exists(args.full_path + '/meta.md'):
            logger.info('Meta.md file is found at the root of the tree. This is used.')
            parse_markdown_files(args.tmp_filename, [args.full_path+'/meta.md'])
        else:
            logger.debug('No meta.md file found. Therefore including the default')
            create_meta(args.tmp_filename)
        parse_markdown_files(args.tmp_filename, markdown_files)
        execute_command(args)

    else:
        logger.critical("No filename was provided. No other actions detected. Exiting")
        exit(1)

if __name__ == '__main__':
    main()