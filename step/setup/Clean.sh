#!/bin/bash

SOURCE="$HOME"/.gitconfig

"$(dirname "$0")"/internal/Backup.sh

echo "" > $SOURCE
echo All settings from file $SOURCE are cleaned.
