#!/usr/bin/env bash
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
  (which brew > /dev/null && brew install "$1") || sudo apt install -o DPkg::Options::="--force-confnew" -y "$1"
}

# ===================
# Basic shell things
# ===================

if [ "$1" != "--no-install" ]; then
  echo "Installing required tools..."
  if [[ "$OSTYPE" = "darwin"* ]]; then
    which brew > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  which zsh || generic_install zsh
  which safe-rm || generic_install safe-rm

  if [[ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]]; then
    if [[ -d ~/.oh-my-zsh ]]; then
      rm -rf ~/.oh-my-zsh
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  fi

  if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi

  if [[ "$OSTYPE" != "darwin"* ]]; then
    which xclip || generic_install xclip
  fi

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

sudo chsh -s "$(which zsh)" "$(whoami)"
echo "If the default shell changed, you may need to log out and in again for this to take effect."
./zsh-setup.sh
