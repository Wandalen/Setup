# Utility::Setup [![status](https://github.com/Wandalen/Setup/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/Setup/actions/workflows/StandardPublish.yml) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Utility to setup development environment.

## Try out

```
git clone https://github.com/Wandalen/Setup
cd Setup
./step/[ general step name ]/[ name of script ] [ parameters ]
```

### Setup Git global config

To setup global settings use scripts `Git.sh` ( posix like OS ) or `Git.bat` ( Windows ).
The scripts setup core settings, user name, user email and inserts user name in git hosts URI ( github.com and bitbucket.org ).

The scripts accept two parameters - name and email.

Example :

```
./step/setup/Git.sh userName user@domain.com
```

### Install NodeJS version manager ( nvm ), NodeJS and NPM

To install utilities use scripts `Nvm.sh` ( posix like OS ) or `Nvm.bat` ( Windows ).
It is needs the package manager `Chocolatey` and administrative shell to install utilities on Windows OS.

Example :

```
./step/install/Nvm.sh
```

