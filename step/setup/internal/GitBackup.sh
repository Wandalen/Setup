#!/bin/bash

SOURCE="$HOME"/.gitconfig
BACKUP="$HOME"/.gitconfig.backup

if [[ "$(cat $SOURCE)" != "" || ! -e $BACKUP ]] ; then
  echo File $SOURCE backuped. Backup file : $BACKUP
  cp $SOURCE $BACKUP
  "$(dirname "$0")"/GitClean.sh
else
  echo Nothing to backup.
fi
