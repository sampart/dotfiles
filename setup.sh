#!/bin/sh
#
# bootstrap installs the following:
#  - copies over the basic .bashrc (although there's a lot in there, most of it is from the basic Ubuntu one, so I wanted to leave it as is)
#  - symlinks files to the home directory
#
# This script is written with the idea that it can be run repeatably to maintain
# a consistent state. ie running the script again should not break anything

echo "\033[32mMain dotfiles install script started..."
echo "\033[0m"

DOTFILES_ROOT="`pwd`"

# ===================
# Basic shell things
# ===================

echo "Basic shell things\n"

# copy .bashrc itself
cp $DOTFILES_ROOT/bashrc/.bashrc $HOME/.bashrc
printf "$DOTFILES_ROOT/bashrc/.bashrc copied to $HOME/.bashrc\n"

mkdir -p $HOME/.bashrc-includes

# symlink bashrc include files to their directory
for source in `find $DOTFILES_ROOT/bashrc -name \*.symlink`
do
  dest="$HOME/.bashrc-includes/`basename \"${source%.*}\"`"

  rm -rf $dest
  ln -s $source $dest
  printf "symlinked $source to $dest\n"
done

printf '\n'

# ============================
# Other home dir config files
# ============================

cd more-home-dir-config

# first delete the existing files in home
find -type f -exec rm $HOME/{} \;

# now symlink the new ones
find -type f -exec ln -s $DOTFILES_ROOT/more-home-dir-config/{} $HOME/{} \;

cd $DOTFILES_ROOT

echo "Other home dir config files symlinked\n"
printf '\n'

# ================================
# Run installers for other things
# ================================

$DOTFILES_ROOT/scripts-in-path/setup.sh