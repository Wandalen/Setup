#!/bin/bash

SOURCE="$HOME"/.gitconfig

"$(dirname "$0")"/Backup.sh

echo All settings from file $SOURCE are cleaned.
echo "" > $SOURCE
