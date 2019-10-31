#!/bin/bash

function askBeforeReplace() {
  echo -e "$3"
  read continue

  if [ $continue == Y ]; then
    STATUS="36m[replaced]"
    rm -R $1
    ln -s $2 $1
  else
    STATUS="31m[ignored]"
  fi
}

# This function will create symlink from $sourcePath to $targetPath
# It will ask before replacing existing file or directory
#
# $1: source of symlink. Can be file or directory
# $2: system configuration file or directory. This target will be replaced by symlink
#
# [r] - replaced
# [n] - new link
# [i] - ignored

function replaceBySymLink {
  local sourcePath=$1
  local targetPath=$2

  # Source file exits
  if [ -e $sourcePath ]; then
    # Target is directory and not symlink
    if [ -d $targetPath ] && [ ! -L $targetPath ]; then
      askBeforeReplace $targetPath $sourcePath "\033[01;36m$targetPath is a directory, delete it and replace by symlink? [Y/n]\033[00m"
    # Target is file and not symlink
    elif [ -f $targetPath ] && [ ! -L $targetPath ]; then
      askBeforeReplace $targetPath $sourcePath "\033[01;36m$targetPath is a file, delete it and replace by symlink? [Y/n]\033[00m"
    # Target does not exits or is symlink
    else
      STATUS="32m[new]"
      local targetParentDir=${targetPath%/*}
     
      # Target parent directory does not exists 
      if [ ! -d "$targetParentDir" ]; then
        mkdir -p $targetParentDir
      fi 

      if [ -L $targetPath ]; then
        STATUS="32m[symlink replaced]"
	rm $targetPath
      fi
      ln -s $sourcePath $targetPath
    fi

    echo -e "\033[01;$STATUS\033[00m: $targetPath --> $sourcePath"
  else
    echo -e "\033[01;36m$sourcePath Symlink target does not exist, skipping.\033[00m"
  fi
}


# replaceBySymLink ~/Projects/debian/config/htoprc ~/.config/htop/htoprc
# replaceBySymLink ~/Projects/debian/config/tigrc ~/.tigrc
