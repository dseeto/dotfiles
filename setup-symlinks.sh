#!/usr/bin/env bash
set -e
echo "##### $(basename $BASH_SOURCE) #####"

DOTFILES_ROOT="`pwd`"
DONT_SYMLINK=("." ".." ".git" ".gitmodules", ".DS_Store")

for f in `ls -a | grep "^\." | grep -v "\.swp$"`; do
  if [[ " ${DONT_SYMLINK[*]} " == *" $f "* ]]; then
    echo "skipping symlink $f"
  else
    SYM_FILE="$HOME/$f"
    TARG_FILE="$DOTFILES_ROOT/$f"
    if test -h "$SYM_FILE" || ! test -e "$SYM_FILE"; then
      # no file or another symlink exists. OK TO OVERWRITE
      echo "ln -fs $TARG_FILE $HOME/$f"
      ln -fs "$TARG_FILE" "$HOME/$f"
    else
      echo -e "\nABORT: $SYM_FILE exists and is not a link."
      exit 1
    fi
  fi
done
