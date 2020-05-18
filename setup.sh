#!/bin/sh
#
# bootstrap installs the following:
#  - copies over the basic .zshrc (although there's a lot in there, most of it is from the basic vanilla one, so I wanted to leave it as is)
#  - symlinks files to the home directory
#
# This script is written with the idea that it can be run repeatably to maintain
# a consistent state. ie running the script again should not break anything

echo "\033[32mMain dotfiles install script started..."
echo "\033[0m"

DOTFILES_ROOT="`pwd`"

# ===================
# Helper functions
# ===================

function generic_install {
  (which brew && brew install $1) || sudo apt install $1
}

# ===================
# Basic shell things
# ===================

if [ "$1" != "--no-install" ]; then
  echo "Installing required tools..."
  generic_install zsh
  generic_install safe-rm
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Done\n"
fi

echo "Basic shell things..."

# copy .zshrc itself
cp $DOTFILES_ROOT/.zshrc $HOME/.zshrc
printf "$DOTFILES_ROOT/.zshrc copied to $HOME/.zshrc\n"

mkdir -p $HOME/.zshrc-includes

# symlink zshrc include files to their directory
for source in `find $DOTFILES_ROOT/zshrc -name \*.symlink`
do
  dest="$HOME/.zshrc-includes/`basename \"${source%.*}\"`"

  rm -rf $dest
  ln -s $source $dest
  printf "symlinked $source to $dest\n"
done

printf '\n'

# ============================
# Other home dir config files
# ============================

echo "Other home dir config files..."

cd more-home-dir-config

# copy over the right OS-specific git config
if [[ "$OSTYPE" == "darwin"* ]]; then
  cp os-gitconfig/.gitconfig_mac ./.gitconfig_os
else
  cp os-gitconfig/.gitconfig_linux ./.gitconfig_os
fi

# first delete the existing versions of these files in home
find . -maxdepth 1 -type f -exec rm -f $HOME/{} \;

# now symlink the new ones
find . -maxdepth 1 -type f -exec ln -s $DOTFILES_ROOT/more-home-dir-config/{} $HOME/{} \;

cd $DOTFILES_ROOT

echo "Other home dir config files symlinked\n"

# ================================
# Run installers for other things
# ================================

$DOTFILES_ROOT/scripts-in-path/setup.sh

# ================================
# Other setup
# ================================

echo "Other setup..."

# Enable "new document" in Nautilus context menu
touch ~/Templates/Empty\ Document

echo "Done"