#!/bin/bash

# This updater script can be used for migrations from one version to the next.
# Migrations are scripts in the migrations directory that can be used to add functionality from a "newer" version of the repo
# The local repo is updated and all scripts in the migration directory are executed that have a timestamp greater than the timestamp of the current
# version. These migration scripts are used to execute actions that are normally part of the install scripts in order to get these upto date without
# re-running these scripts.
# Timestamp for the migration files can be created used the following command: date +%s

cd ~/.local/share/dotfiles/

if [[ $1 == "all" ]]; then
  # Run all migrations
  last_updated_at=1
else
  # Remember the version we're at before upgrading
  last_updated_at=$(git log -1 --format=%cd --date=unix)
fi

# Get the latest
git pull

# Run any pending migrations
for file in migrations/*.sh; do
  filename=$(basename "$file")
  migrate_at="${filename%.sh}"

  if [ $migrate_at -gt $last_updated_at ]; then
    echo "Running migration ($migrate_at)"
    source $file
  fi
done

# Back to where we came from
cd - >/dev/null
