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
./proto/GitConfigGlobalSetup.sh userName user@domain.com
```
