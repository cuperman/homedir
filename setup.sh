#!/bin/bash
#### Script to set up symlinks from ~/ to ~/homedir,
#### elegantly dealing with ones that may already be there, and backing up the existing.

# Abort on error
set -e

# Fix osx history across sessions http://superuser.com/questions/950403/bash-history-not-preserved-between-terminal-sessions-on-mac
touch ~/.bash_sessions_disable

cd ~
for file in .vimrc .vim .selected_editor .profile .hushlogin .eslintrc.js .gitignore .inputrc .bash_aliases .gemrc; do
  if [ -h $file ] ; then
    # File is already a symbolic link
    echo "Symlink for $file is already there"
    continue
  fi
  if [ -d $file -o -f $file ] ; then
    echo "Backing up existing $file to $file.b4homedir"
    rm -rf $file.b4homedir
    mv $file $file.b4homedir
  fi
  echo "Creating symlink for $file"
  ln -s homedir/$file
done

set +e

echo "Installing TextMate Bundles"
my_bundle_dir=`pwd`/homedir/TextMate/Bundles
textmate_bundle_dir=~/Library/Application\ Support/TextMate/Bundles
mkdir -p "$textmate_bundle_dir"
for bundle in `ls "$my_bundle_dir" | grep \.tmbundle$`; do
  if [ -d "$textmate_bundle_dir/$bundle" ]; then
    echo "Bundle $bundle is already installed"
  else
    echo "Installing $bundle"
    ln -s "$my_bundle_dir/$bundle" "$textmate_bundle_dir/$bundle"
  fi
done
echo Done

function checkExe(){
    loc=`which $1`
    if [ "$?" != "0" ] ; then
        echo
        echo "$1 NOT found, install with '$2'"
    else
        echo -n "."
    fi
}
echo "Checking for programs required for syntax checking (handy for vim syntastic)"
checkExe eslint "npm install eslint -g"
checkExe pyflakes "sudo apt-get install pyflakes"
checkExe xmllint "sudo apt-get install libxml2-utils"
checkExe tidy "sudo apt-get install tidy"
checkExe csslint "npm install csslint -g"
checkExe js-yaml "npm install js-yaml -g"

echo Done
