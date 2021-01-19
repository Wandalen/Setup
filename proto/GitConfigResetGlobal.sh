#!/bin/bash

NAME="$1"
EMAIL="$2"

git config --global core.autocrlf false
git config --global core.ignorecase false
git config --global core.fileMode false
git config --global credential.helper store

if [[ $NAME != "" ]] ; then
  git config --global user.name "$NAME"
  git config --global url."https://$NAME@github.com".insteadOf "https://github.com"
  git config --global url."https://$NAME@bitbucket.org".insteadOf "https://bitbucket.org"
fi

if [[ $EMAIL != "" ]] ; then
  git config --global user.email "$EMAIL"
fi

exit 0

