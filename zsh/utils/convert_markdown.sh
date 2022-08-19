#!/bin/bash


# Put the installation instructions within an eof and also put the help within an eof
# Find the solution for the out of bound box with linebreak
# Move it to the tools directory and make it work
# Move templates to the tools directory and make it work
# clean up code

highlight=`realpath ~/dotfiles/zsh/utils/custom_highlight.theme`
template=`realpath ~/dotfiles/zsh/utils/eisvogel.latex`
print_install() {
echo "General installation instructions:
    1. Install pandoc from the pandoc website
    2. Install texlive-latex-extra
    3. sudo apt install texlive-latex-extra texlive-lang-european texlive-xetex
    4. Add several necessary packages
    5. updmap -user
    6. tlmgr init-usertree
    7. tlmgr install adjustbox babel-german background bidi collectbox csquotes everypage filehook footmisc footnotebackref framed fvextra letltxmacro ly1 mdframed mweights needspace pagecolor sourcecodepro sourcesanspro titling ucharcat ulem unicode-math upquote xecjk xurl zref"
    exit 1
}
print_help() {
    echo "Script for creating .pdf from .md files"
    echo ""
    echo "Usage : $0 <input.md> [--spider] [--depth=<number>] [--help] [--titlepage] [--title='title for document' [--output='filename for the output'] "
    echo ""
    echo "<input.md>    :   Markdown file that is used as input for the conversion into a .pdf. Either this argument or the '--spider' argument shall be present"
    echo "--spider      :   If this argument is used the current directory and subdirectory's is are spidered for .md files and a .pdf document is created from this."
    echo "--depth       :   Depth of the subdirectory's that will be traversed when spidering."
    echo "--titlepage   :   Includes the titlepage in the output"
    echo "--title       :   Changes the meta information in the output to include the provided title"
    echo "--output      :   Provide a custom filename (without the .pdf) for the output file"
    echo "--install     :   Print installation instructions"
    echo "--help        :   Print this help"
    exit 1
}

join () {
    local IFS=", "
    KEYWORDS=`echo "$*"`
}

create_meta () {
    # First check if there is a meta.md in the source directory. If so, we have to include that file
    echo "[i] Processing directory : $full_path"
    if [ -f "$full_path/meta.md" ] 
    then
        cat $full_path/meta.md > $tmp_file
        echo '[i] Found meta.md, using for page layout'
    else
        echo '---' > $tmp_file
        echo 'date: \today' >> $tmp_file
        echo 'lang: "nl"' >> $tmp_file
        if [[ $TITLEPAGE == YES ]]
        then
            echo "title: $TITLE" >> $tmp_file
            echo 'titlepage: true' >> $tmp_file
            echo 'titlepage-color: "2f92f5"' >> $tmp_file
            echo 'titlepage-text-color: "FFFFFF"' >> $tmp_file
            echo 'titlepage-rule-color: "FFFFFF"' >> $tmp_file
            echo 'titlepage-rule-height: 2' >> $tmp_file
        fi
        echo 'book: true' >> $tmp_file
        echo 'classoption: oneside' >> $tmp_file
        echo 'keywords: ' >> $tmp_file 
        echo 'output:' >> $tmp_file
        echo '	pdf_document:' >> $tmp_file
        echo '		md_extensions: +task_lists' >> $tmp_file
        echo 'code-block-font-size: \scriptsize' >> $tmp_file
        echo '---' >> $tmp_file
    fi
    if [[ ! -z $TITLE ]]
    then
        sed -i "s/^title[ ]*:.*$/title: \"$TITLE\"/" $tmp_file
        echo "[i] \"$TITLE\" is used as title"
    fi
}

spider_dir () {

    if [[ -z $DEPTH ]]
    then
        DEPTH=1
    fi
    echo "[i] Spidering to create the output file with a spider depth of : $DEPTH"
    files=`find $POSITIONAL -maxdepth $DEPTH -iname '*.md'`

    # This needs a part where the keywords are expanded to include the raw filenames of the files included
    #  if [ ! -f $full_path/meta.md ] 
    #then
    #    join $files
    #   echo $KEYWORDS
    #   sed -i "s/^keyword.*$/keyword:'\"$KEYWORDS\"'/" $tmp_file
    #fi
    for md_file in $files; do
        if [[ ! $md_file == *"meta.md" ]]
        then
            dir_part=`dirname $md_file`
            echo "[i] adding file and converting paths for loot and screenshots : $md_file"
            cat $md_file | sed "s#(loot#($dir_part/loot#g" | sed "s#(screen#($dir_part/screen#g" >> $tmp_file
        fi
    done
}

parse_arguments () {

    for i in "$@"
    do
        case $i in
            --title=*)
                TITLE="${i#*=}"
                shift
                ;;
            --titlepage)
                TITLEPAGE=YES
                shift
                ;;
            --output=*)
                OUTPUT="${i#*=}"
                shift
                ;;
            --depth=*)
                DEPTH="${i#*=}"
                shift
                ;;
            --spider)
                SPIDER=YES
                shift
                ;;
            --install)
                INSTALL=YES
                shift
                ;;
            --help)
                HELP=YES
                shift
                ;;
            *)
                POSITIONAL+=("$1")
                # This supports multiple files, maybe extend the code to also support that behaviour
                shift
                ;;
        esac
    done
}

error () {
    echo "$@" >&2
    print_help
    exit 1
}

parse_arguments "$@"

if [[ $HELP == YES ]]
then
    print_help
fi

if [[ $INSTALL == YES ]]
then
    print_install
fi

if [[ -z "$POSITIONAL" ]]
then
    error "ERROR: No input file or directory provided"
fi


#if [[ $POSITIONAL == *.md && $SPIDER == YES ]]
#then
#    error "ERROR: Both --spider and an input file are provided. These options can't be provided simultaniously"
#fi

if [[ ! -f "$POSITIONAL" && -z $SPIDER ]]
then
    error "ERROR: The provided filename '$POSITIONAL' is not correct"
fi

full_name=`realpath $POSITIONAL`
if [[ -d $full_name ]]
then
    full_path=$full_name
    short_name=`echo $full_name | sed -n "s/^.*\/\([^\/].*\)$/\1/p"`.pdf
else
    full_path=`echo $full_name | sed -n "s/^\(.*\/\)\([^\/].*\)\.md.*$/\1/p"`
    if [[ -z $OUTPUT ]]
    then
        short_name=`echo $full_name | sed -n "s/^\(.*\/\)\([^\/].*\)\.md.*$/\2/p"`.pdf
    else
        short_name=$OUTPUT.pdf
    fi
    echo $short_name
fi

tmp_file=$(mktemp /tmp/XXXXXX.md)
create_meta 
if [[ -f $full_name ]]
then
    cat $full_name >> $tmp_file
    echo "" >> $tmp_file
fi

if [[ $SPIDER == YES ]]
then
    spider_dir
fi

if [[ ! -f $highlight ]]
then
    echo "WARNING: Highlighting file '$highlight' is not found. Default highlighting is used"
else
    HIGHLIGHT="--highlight-style=$highlight"
fi
if [[ ! -f $template ]]
then
    echo "WARNING: Template file '$template.latex' is not found. No templating is used"
else
    TEMPLATE="--template $template"
fi

echo "[i] Filename of temporary file : $tmp_file"
echo "[*] Filename of output .pdf file : $short_name"
cd /tmp
pandoc $tmp_file -o "$full_path/$short_name" --resource-path="$full_path" --from markdown+yaml_metadata_block+raw_html --pdf-engine=xelatex --pdf-engine-opt=-output-directory=/tmp $TEMPLATE $HIGHLIGHT --table-of-contents --toc-depth 4 --number-sections --top-level-division=chapter && rm $tmp_file
