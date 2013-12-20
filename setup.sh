#!/bin/sh
#
# bootstrap installs the following:
#  - copies over the basic .bashrc (although there's a lot in there, most of it is from the basic Ubuntu one, so I wanted to leave it as is)
#  - symlinks files to the home directory
#
# This script is written with the idea that it can be run repeatably to maintain
# a consistent state. ie running the script again should not break anything

DOTFILES_ROOT="`pwd`"

# ===================
# Basic shell things
# ===================

cp ./shell/.bashrc $HOME/.bashrc
printf "$DOTFILES_ROOT/shell/.bashrc copied to ~/.bashrc\n"

# symlink files to the home directory
for source in `find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink`
do
  dest="$HOME/.dotfiles/`basename \"${source%.*}\"`"

  rm -rf $dest
  ln -s $source $dest
  printf "symlinked $source to $dest\n"
done

printf '\n'

# ================================
# Run installers for other things
# ================================

$DOTFILES_ROOT/scripts-in-path/setup.sh