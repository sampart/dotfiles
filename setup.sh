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

# The full path to the directory containing this script
# https://unix.stackexchange.com/a/76518
DOTFILES_ROOT=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

# ===================
# Helper functions
# ===================

generic_install() {
  (which brew > /dev/null && brew install "$1") || sudo apt install "$1"
}

# ===================
# Basic shell things
# ===================

if [ "$1" != "--no-install" ]; then
  echo "Installing required tools..."
  if [[ "$OSTYPE" = "darwin"* ]]; then
    which brew > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  generic_install zsh
  generic_install safe-rm
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  echo "Done\n"
fi

echo "Basic shell things..."

# copy .zshrc itself
cp $DOTFILES_ROOT/.zshrc $HOME/.zshrc
printf "$DOTFILES_ROOT/.zshrc copied to $HOME/.zshrc\n"

mkdir -p $HOME/.zshrc-includes
touch "$HOME/.zshrc-includes/machine-specific-config"

# symlink zshrc include files to their directory
for source in $(find $DOTFILES_ROOT/zshrc -name \*.symlink)
do
  dest="$HOME/.zshrc-includes/$(basename "${source%.*}")"

  rm -f "$dest"
  ln -s "$source" "$dest"
  printf "symlinked $source to $dest\n"
done

printf '\n'

# ============================
# Other home dir config files
# ============================

echo "Other home dir config files..."

OTHER_CONFIG=$DOTFILES_ROOT/more-home-dir-config

# copy over the right OS-specific git config
if [[ "$OSTYPE" == "darwin"* ]]; then
  cp "$OTHER_CONFIG"/os-gitconfig/.gitconfig_mac "$OTHER_CONFIG"/.gitconfig_os
else
  cp "$OTHER_CONFIG"/os-gitconfig/.gitconfig_linux "$OTHER_CONFIG"/.gitconfig_os
fi

# first delete the existing versions of these files in home
find "$OTHER_CONFIG" -maxdepth 1 -type f -execdir rm -f $HOME/{} \;

# now symlink the new ones
find "$OTHER_CONFIG" -maxdepth 1 -type f -execdir ln -s "$OTHER_CONFIG"/{} $HOME/{} \;

printf "Other home dir config files symlinked\n"

# ================================
# Run installers for other things
# ================================

$DOTFILES_ROOT/scripts-in-path/setup.sh

# ================================
# Other setup
# ================================

if [[ -d "~/Templates" ]]; then
  echo "Other setup..."
  # Enable "new document" in Nautilus context menu
  touch ~/Templates/Empty\ Document 
  echo "Done"
fi
