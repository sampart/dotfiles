DOTFILES_ROOT="`pwd`"

rm -f ~/.gitconfig
ln -s $DOTFILES_ROOT/more-home-dir-config/.gitconfig ~/.gitconfig
rm -f ~/.gitignore
ln -s $DOTFILES_ROOT/more-home-dir-config/.gitignore ~/.gitignore
./scripts-in-path/setup.sh
