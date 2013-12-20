# Create the directory if it doesn't exist
mkdir -p $HOME/scripts-in-path

# symlink files to the new directory
thisdir=`pwd`;
for source in `find ./ -maxdepth 2 -name \*.symlink`
do
  dest="$HOME/scripts-in-path/`basename \"${source%.*}\"`"
  
  fullsource=$thisdir/$source
  
  rm -rf $dest
  ln -s $fullsource $dest
  printf "symlinked $fullsource to $dest\n"
done

printf '\n'