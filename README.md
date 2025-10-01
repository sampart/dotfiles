# Sam's dotfiles

Based on the idea behind https://github.com/olorton/dotfiles, this is effectively a backup of config, with a mechanism to automatically apply the config to a new machine.

If you do make use of these dotfiles yourself, make sure you update the user name and email in `.gitconfig` to be you, not me!

To install the configuration files, simply run `setup.sh`.  This does the following:

1. Copies over the `.zshrc` file from this repo to the home directory
2. As this `.zshrc` refers to several other files, rather than just being one monolithic file itself, those referenced files (see the `zshrc` folder in this repo) are also copied, in this case into the `~\zshrc-includes` folder.
3. Various other config files are symlinked from the home directory to the ones in `more-home-dir-config`
4. The scripts-in-path setup script is run.  This puts symlinks to useful scripts into `~/scripts-in-path`.  This folder is added to the path by one of the included zshrc files above.  You can see the linked scripts in the `scripts-in-path` folder in this repo.

## Other config notes

I don't manage my SSH config here, but here's a reminder of the config to ensure keys get auto-forwarded to Codespaces:

```text
Match host localhost user [codespaces-local-user-here]
  AddKeysToAgent yes
  ForwardAgent yes
```

## Other

- https://til.simonwillison.net/macos/close-terminal-on-ctrl-d
- Calendar in menu bar via Raycast: https://www.raycast.com/core-features/calendar
- MacOS > System Settings > Notifications > Allow notifications when mirroring or sharing the display
