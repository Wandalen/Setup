#!/bin/bash

NAME="$1"
EMAIL="$2"

FORMAT='Command format: "script_path [user.name] [user.email]"'

OLDNAME=$(git config --get user.name)
if [[ $OLDNAME == "" && $NAME == "" ]] ; then
  echo User name is not defined. Please, define user name. "$FORMAT"
  exit 1
fi

OLDEMAIL=$(git config --get user.email)
if [[ $OLDEMAIL == "" && $EMAIL == "" ]] ; then
  echo User email is not defined. Please, define user email. "$FORMAT"
  exit 1
fi

"$(dirname "$0")"/Backup.sh

git config --global core.autocrlf false
git config --global core.ignorecase false
git config --global core.fileMode false
git config --global credential.helper store

if [[ $NAME != "" ]] ; then
  git config --global user.name "$NAME"
  if [[ $OLDNAME != "" ]] ; then
    git config --global --unset url.https://"$OLDNAME"@github.com.insteadof
    git config --global --unset url.https://"$OLDNAME"@bitbucket.org.insteadof
  fi
  git config --global url."https://$NAME@github.com".insteadOf "https://github.com"
  git config --global url."https://$NAME@bitbucket.org".insteadOf "https://bitbucket.org"
fi

if [[ $EMAIL != "" ]] ; then
  git config --global user.email "$EMAIL"
fi

git config --list --global --show-origin

exit 0

/* qqq : does not print information! */