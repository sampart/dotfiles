#!/usr/bin/env zsh
#
# This is the zsh part of the install, called from setup.sh
DOTFILES_ROOT=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

source "$HOME/.zshrc"

printf '\n'

# ============================
# Other home dir config files
# ============================

echo "Other home dir config files..."

OTHER_CONFIG="$DOTFILES_ROOT/more-home-dir-config"

# On Linux, make the diff-highlight executable if it doesn't already exist
if [[ "$OSTYPE" != "darwin"* && ! -f /usr/share/doc/git/contrib/diff-highlight/diff-highlight ]]; then
  sudo make -B -C /usr/share/doc/git/contrib/diff-highlight diff-highlight
fi

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

## Finally, remove git config lines that we don't want on codespaces
if [[ "$CODESPACES" == "true" ]]; then
  # NB --follow-symlinks doesn't work on macs, but we don't need this there anyway
  sed -i --follow-symlinks '/# notcodespaces/d' "$HOME/.gitconfig"
fi


printf "Other home dir config files symlinked\n"

# ================================
# Run installers for other things
# ================================

$DOTFILES_ROOT/scripts-in-path/setup.sh

# ================================
# Other setup
# ================================

if [[ ! -f ~/.local/bin/shellmarks.sh ]]; then
  git clone https://github.com/Bilalh/shellmarks.git
  if [[ -d shellmarks ]]; then
    (
    cd shellmarks
    make install
    )
    rm -rf ./shellmarks
  else
    echo "shellmarks install failed"
  fi
fi

if [[ -d ~/Templates ]]; then
  echo "Other setup..."
  # Enable "new document" in Nautilus context menu
  touch ~/Templates/Empty\ Document 
  echo "Done"
fi

