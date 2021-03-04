# Setup

Utilities to setup development environment.

## Try out

```
git clone https://github.com/Wandalen/Setup
cd Setup
./proto/[ name of script ] [ parameters ]
```

### Setup Git global config

To setup global settings use scripts `GitConfigGlobalSetup.sh` ( posix like OS ) or `GitConfigGlobalSetup.bat` ( Windows ).
The scripts setup core settings, user name, user email and inserts user name in git hosts URI ( github.com and bitbucket.org ).

The scripts accept two parameters - name and email.

Example :

```
./step/setup/Git.sh userName user@domain.com
```

### Install NodeJS version manager ( nvm ), NodeJS and NPM

To install utilities use scripts `NvmNjsInstall.sh` ( posix like OS ) or `NvmNjsInstall.bat` ( Windows ).
It is needs the package manager `Chocolatey` and administrative shell to install utilities on Windows OS.

Example :

```
./step/install/Nvm.sh
```

The scripts can accept single argument - version of NodeJS to install.

```
./step/install/Nvm.sh 14.15.4
```

