#!/bin/bash

NVM_DIR="$HOME/.nvm"

cd "$HOME"
if [ ! -d ".nvm" ] ; then
  mkdir ".nvm"
fi

if command -v wget &> /dev/null
then
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh > "$NVM_DIR/install.sh"
elif command -v curl &> /dev/null
then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh > "$NVM_DIR/install.sh"
elif command -v apt &> /dev/null
then
  sudo apt install nodejs
  exit 0
fi

wait $!
bash "$NVM_DIR/install.sh"
PID=$(pgrep "install.sh")
wait $PID

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts --latest-npm

exit 0

