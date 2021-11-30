#!/bin/bash

OS=$(uname)
case $OS in
  'Linux')
    PKG_MGR_CMD='sudo apt install'
    if [[ $(which apt) == "" ]] ; then
      if [[ $(which pacman) != "" ]] ; then
        PKG_MGR_CMD='sudo pacman -S'
      else
        if [[ $(which dnf) != "" ]] ; then
          PKG_MGR_CMD='sudo dnf install'
        else
          echo "Unknown package manager"
          exit 1
        fi
      fi
    fi

    if [[ $(which gcc) == "" ]] ; then
      $PKG_MGR_CMD gcc
    fi

    if [[ $(which cmake) == "" ]] ; then
      $PKG_MGR_CMD cmake
    fi
  ;;
  'Darwin')
    PKG_MGR_CMD='brew install'
    if [[ $(xcode-select -p) == "" ]] ; then
      xcode-select --install
    fi
    ;;
  *)
    echo "Unknown OS"
    exit 1
  ;;
esac

if [[ $(which git) == "" ]] ; then
  $PKG_MGR_CMD git
fi

if [[ $(which node) == "" ]] ; then
  ../install/Nvm.sh
else
  VERSION=$(node -v)
  if [[ ${VERSION:1:2} < 14 ]] ; then
    echo "Please, use install NodeJs v14 or higher."
    exit 1
  fi
fi

if [[ $(which python3) == "" ]] ; then
  $PKG_MGR_CMD python3
fi

git clone https://github.com/Wandalen/wNodejsDevEnv.git && cd wNodejsDevEnv && npm test
cd .. && rm -rf wNodejsDevEnv
