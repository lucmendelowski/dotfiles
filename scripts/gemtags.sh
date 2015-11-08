#!/usr/bin/env bash

ruby=$1
start=$(pwd)

# Remove existing file
if [ -e gem.tags ]; then
  echo "Gem tags file already exists, removing it"
  rm gem.tags
fi;

# Find absolute paths and remove current directory
gems=$(bundle show --paths | grep "$start" | sed "s|$start/||g" | sed '/bundler/d')

# Generate ctags for every gem
for gem in $gems; do
  # ctags -n -a -f gem.tags ./$gem
  RBENV_VERSION=$ruby rbenv exec ripper-tags -R --extra=q -f gem.tags ./$gem
done