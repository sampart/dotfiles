#!/bin/sh
#
# You should normally run this script via setup.sh in the project root.  You can run it directly, however.

echo "\033[32mSet up scripts-in-path"
echo "\033[0m"

# Create the directory if it doesn't exist
mkdir -p $HOME/scripts-in-path

# The full path to the directory containing this script
# https://unix.stackexchange.com/a/76518
fullPath=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

# symlink files to the new directory
thisdir=$(dirname $0)
for source in `find $thisdir -maxdepth 2 -name \*.symlink`
do
  dest="$HOME/scripts-in-path/`basename \"${source%.*}\"`"
  
  rm -rf $dest
  ln -s $fullPath/$source $dest
  printf "symlinked $fullPath/$source to $dest\n"
done

printf '\n'