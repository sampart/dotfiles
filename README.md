# Sam's dotfiles

Based on the idea behind https://github.com/olorton/dotfiles, this is effectively a backup of config, with a mechanism to automatically apply the config to a new machine.

To install the configuration files, simply run `setup.sh`.  This does the following:

1. Copies over the `.bashrc` file from this repo to the home directory
2. As this `.bashrc` refers to several other files, rather than just being one monolithic file itself, those referenced files (see the `bashrc` folder in this repo) are also copied, in this case into the `~\bashrc-includes` folder.
3. Various other config files are symlinked from the home directory to the ones in `more-home-dir-config`
4. The scripts-in-path setup script is run.  This puts symlinks to useful scripts into `~/scripts-in-path`.  This folder is added to the path by one of the included bashrc files above.  You can see the linked scripts in the `scripts-in-path` folder in this repo.

## Other config

Some config doesn't really lend itself to automated installation; that is simply documented here instead.

### Rockmongo

[RockMongo](http://rockmongo.com) can be configured to connect to external servers as well as ones running on localhost.  That is done with port-forwarding.  For example, you might have a section like the following in `config.php`:

    $MONGO["servers"][$i]["mongo_name"] = "My remote server";
    $MONGO["servers"][$i]["mongo_host"] = "localhost";
    $MONGO["servers"][$i]["mongo_port"] = "27777";
    $MONGO["servers"][$i]["control_users"]["admin"] = "admin";
    $MONGO["servers"][$i]["mongo_auth"] = false;
    $i ++;

Notice the funny port?  This remote server will be available to RockMongo if you first open an SSH tunnel with a command like this:

    ssh user@my.remote.server -L 27777:localhost:27017

This makes the remote server's `localhost:27017` (i.e. its Mongo instance) available locally on port 27777.
