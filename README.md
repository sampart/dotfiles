# Sam's dotfiles

Based on the idea behind https://github.com/olorton/dotfiles, this is effectively a backup of config, with a mechanism to automatically apply the config to a new machine.

To install the configuration files, simply run `setup.sh`.  This does the following:

1. Copies over the `.zshrc` file from this repo to the home directory
2. As this `.zshrc` refers to several other files, rather than just being one monolithic file itself, those referenced files (see the `zshrc` folder in this repo) are also copied, in this case into the `~\zshrc-includes` folder.
3. Various other config files are symlinked from the home directory to the ones in `more-home-dir-config`
4. The scripts-in-path setup script is run.  This puts symlinks to useful scripts into `~/scripts-in-path`.  This folder is added to the path by one of the included zshrc files above.  You can see the linked scripts in the `scripts-in-path` folder in this repo.
