( function _Setup_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );
}

const _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  context.provider = _.fileProvider;
  let path = context.provider.path;
  context.suiteTempPath = context.provider.path.tempOpen( path.join( __dirname, '../..'  ), 'Setup' );
  // context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
}

//

function onSuiteEnd( test )
{
  let context = this;
  let path = context.provider.path;
  _.assert( _.strHas( context.suiteTempPath, 'Setup' ), context.suiteTempPath );
  path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function backupGitConfig( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* to prevent global config corruption */
  if( !_.process.insideTestContainer() )
  return test.true( true );

  /* save original global config */
  let globalConfigPath = a.path.nativize( a.abs( process.env.HOME, '.gitconfig' ) );
  let globalConfigBackupPath = a.path.nativize( a.abs( process.env.HOME, '.gitconfig.backup' ) );
  let originalGlobalConfig = a.fileProvider.fileRead( globalConfigPath );

  const ext = process.platform === 'win32' ? 'bat' : 'sh';
  const scriptPath = a.path.join( __dirname, `../../../../step/setup/internal/Backup.${ ext }` );

  /* - */

  begin( true );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'not empty config, run once, no backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 1 );
    return null;
  });

  begin( true );
  a.shell( `${ scriptPath }` );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'not empty config, run twice, backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 1 );
    return null;
  });

  /* */

  begin( false );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'empty config, run once, no backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 1 );
    return null;
  });

  begin( false );
  a.shell( `${ scriptPath }` );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'not empty config, run twice, backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 0 );
    test.identical( _.strCount( op.output, 'Nothing to backup.' ), 1 );
    return null;
  });

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( globalConfigPath, originalGlobalConfig );

    if( err )
    {
      _.errAttend( err );
      throw _.err( err );
    }
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( extend )
  {
    a.ready.then( () => { a.fileProvider.fileWrite( globalConfigPath, '' ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( globalConfigBackupPath); return null });
    if( extend )
    a.shell( `${ a.abs( a.path.dir( scriptPath ), '../Git.' + ext ) } user user@domain.com` );
    return a.ready;
  }
}

//

function cleanGitConfig( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* to prevent global config corruption */
  if( !_.process.insideTestContainer() )
  return test.true( true );

  /* save original global config */
  let globalConfigPath = a.path.nativize( a.abs( process.env.HOME, '.gitconfig' ) );
  let globalConfigBackupPath = a.path.nativize( a.abs( process.env.HOME, '.gitconfig.backup' ) );
  let originalGlobalConfig = a.fileProvider.fileRead( globalConfigPath );

  const ext = process.platform === 'win32' ? 'bat' : 'sh';
  const scriptPath = a.path.join( __dirname, `../../../../step/setup/Clean.${ ext }` );

  /* - */

  begin( true );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'not empty config, run once, no backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 1 );
    test.identical( _.strCount( op.output, /All settings from file .*\.gitconfig are cleaned./ ), 1 );
    return null;
  });

  begin( true );
  a.shell( `${ scriptPath }` );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'not empty config, run twice, backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 0 );
    test.identical( _.strCount( op.output, 'Nothing to backup.' ), 1 );
    test.identical( _.strCount( op.output, /All settings from file .*\.gitconfig are cleaned./ ), 1 );
    return null;
  });

  /* */

  begin( false );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'empty config, run once, no backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 1 );
    test.identical( _.strCount( op.output, 'Nothing to backup.' ), 0 );
    test.identical( _.strCount( op.output, /All settings from file .*\.gitconfig are cleaned./ ), 1 );
    return null;
  });

  begin( false );
  a.shell( `${ scriptPath }` );
  a.shell( `${ scriptPath }` );
  a.ready.then( ( op ) =>
  {
    test.case = 'not empty config, run twice, no backup file';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /File .*\.gitconfig backuped. Backup file : .*\.gitconfig\.backup/ ), 0 );
    test.identical( _.strCount( op.output, 'Nothing to backup.' ), 1 );
    test.identical( _.strCount( op.output, /All settings from file .*\.gitconfig are cleaned./ ), 1 );
    return null;
  });

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( globalConfigPath, originalGlobalConfig );

    if( err )
    {
      _.errAttend( err );
      throw _.err( err );
    }
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( extend )
  {
    a.ready.then( () => { a.fileProvider.fileWrite( globalConfigPath, '' ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( globalConfigBackupPath); return null });
    if( extend )
    a.shell( `${ a.abs( a.path.dir( scriptPath ), 'Git.' + ext ) } user user@domain.com` );
    return a.ready;
  }
}

//

function setupGitConfig( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* to prevent global config corruption */
  if( !_.process.insideTestContainer() )
  return test.true( true );

  /* save original global config */
  let globalConfigPath = a.path.nativize( a.path.join( process.env.HOME, '.gitconfig' ) );
  let originalGlobalConfig = a.fileProvider.fileRead( globalConfigPath );

  const ext = process.platform === 'win32' ? 'bat' : 'sh';
  const scriptPath = a.path.join( __dirname, `../../../../step/setup/Git.${ ext }` );

  /* */

  begin();
  a.shell( `${ scriptPath } user user@domain.com` )
  .then( ( op ) =>
  {
    test.case = 'almost empty global config - user name and email';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.shell( `${ scriptPath } user user@domain.com` )
  .then( ( op ) =>
  {
    test.case = 'global config with field - user name and email';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shellNonThrowing( `${ scriptPath } user` )
  .then( ( op ) =>
  {
    test.case = 'almost empty global config - only user name';
    test.identical( op.exitCode, 1 );
    test.identical( _.strCount( op.output, 'User email is not defined. Please, define user email.' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( `git config --global user.email user@domain.com` );
  a.shell( `${ scriptPath } user` )
  .then( ( op ) =>
  {
    test.case = 'almost empty global config - only user name';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( `git config --global user.email user@domain.com` );
  a.shell( 'git config --global user.name "user2"' );
  a.shell( `${ scriptPath } user` )
  .then( ( op ) =>
  {
    test.case = 'global config with field - only user name';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shellNonThrowing( `${ scriptPath }` )
  .then( ( op ) =>
  {
    test.case = 'almost empty global config - without user name and email';
    test.identical( op.exitCode, 1 );
    test.identical( _.strCount( op.output, 'User name is not defined. Please, define user name.' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( `git config --global user.email user@domain.com` );
  a.shell( `git config --global user.name user` );
  a.shell( `${ scriptPath }` )
  .then( ( op ) =>
  {
    test.case = 'almost empty global config - without user name and email';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 0 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 0 );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.shellNonThrowing( `${ scriptPath }` )
  .then( ( op ) =>
  {
    test.case = 'global config with field - only user name';
    test.identical( op.exitCode, 1 );
    test.identical( _.strCount( op.output, 'User email is not defined. Please, define user email.' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( `${ scriptPath } user user@domain.com` );
  a.shell( `${ scriptPath } user2 user2@domain.com` )
  .then( ( op ) =>
  {
    test.case = 'call script twice, should overwrite existing config only';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user2' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=use2r@domain.com' ), 0 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 0 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 0 );
    test.identical( _.strCount( op.output, 'url.https://user2@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user2@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( globalConfigPath, originalGlobalConfig );

    if( err )
    {
      _.errAttend( err );
      throw _.err( err );
    }
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      a.fileProvider.fileWrite( globalConfigPath, '' );
      return null;
    });
  }
}

setupGitConfig.timeOut = 10000;

//

function installNvmPosix( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* install nvm and njs only in test container */
  if( process.platform === 'win32' || !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  let homePath = process.env.HOME;
  let originalNvm = false;
  a.ready.then( () =>
  {
    if( a.fileProvider.fileExists( a.abs( process.env.HOME, '.nvm' ) ) )
    {
      originalNvm = true;
      a.fileProvider.fileCopy({ srcPath : a.abs( homePath, '.bashrc' ), dstPath : a.abs( homePath, 'bashrc' ) });
      a.fileProvider.fileRename({ srcPath : a.abs( homePath, '.nvm' ), dstPath : a.abs( homePath, 'nvm' ) });
    }
    return null;
  });

  const scriptPath = a.path.join( __dirname, `../../../../step/install/Nvm.sh` );

  /* */

  a.shell({ execPath : `${ scriptPath }`, timeOut : 120000 })
  .then( ( op ) =>
  {
    test.case = 'install nvm and lates lts nodejs';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '=> Downloading nvm from git to' ), 1 );
    test.identical( _.strCount( op.output, '=> Compressing and cleaning up git repository' ), 1 );
    test.identical( _.strCount( op.output, 'Installing latest LTS version' ), 1 );
    return null;
  });

  a.shell( 'node --version' )
  .then( ( op ) =>
  {
    test.case = 'check node program';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /v\d\d\.\d{1,2}\.\d/ ), 1 );
    return null;
  });

  a.shell( 'npm --version' )
  .then( ( op ) =>
  {
    test.case = 'check npm package';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\d\.\d{1,2}\.\d/ ), 1 );
    return null;
  });

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    if( originalNvm )
    {
      a.fileProvider.filesDelete( a.abs( homePath, '.nvm' ) );
      a.fileProvider.fileRename({ srcPath : a.abs( homePath, 'nvm' ), dstPath : a.abs( homePath, '.nvm' ) });
      a.fileProvider.fileDelete( a.abs( homePath, '.bashrc' ) );
      a.fileProvider.fileRename({ srcPath : a.abs( homePath, 'bashrc' ), dstPath : a.abs( homePath, '.bashrc' ) });
    }

    if( err )
    throw _.err( err );
    return null;
  });

  return a.ready;
}

installNvmPosix.timeOut = 180000;

//

function installNvmWindows( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* install nvm and njs only in test container */
  if( process.platform !== 'win32' || !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  const scriptPath = a.path.join( __dirname, `../../../../step/install/Nvm.bat` );

  /* */

  let chocoExists = true;
  a.shellNonThrowing( 'choco --version' );
  a.ready.then( ( op ) =>
  {
    if( op.exitCode !== 0 )
    chocoExists = false;
    return chocoExists;
  });

  let nvmExists = true;
  a.shellNonThrowing( 'nvm --version' );
  a.ready.then( ( op ) =>
  {
    if( op.exitCode !== 0 )
    nvmExists = false;
    return nvmExists;
  });

  /* */

  a.shellNonThrowing({ execPath : `${ scriptPath }`, timeOut : 200000 })
  .then( ( op ) =>
  {
    if( chocoExists === false )
    {
      test.identical( op.exitCode, 0 );
      test.case = 'choco does not exists';
      var exp = 'Please, install the utility Chocolatey and then run the script';
      test.identical( _.strCount( op.output, exp ), 1 );
      var exp = 'Run next command in administrative shell to install utility :';
      test.identical( _.strCount( op.output, exp ), 1 );
    }

    if( nvmExists === false )
    {
      test.case = 'nvm does not exist';
      test.identical( _.strCount( op.output, 'nvm package files install completed' ), 1 );
      test.identical( _.strCount( op.output, 'The install of nvm was successful' ), 1 );
    }
    return null;
  });

  a.shellNonThrowing( 'node --version' );
  a.ready.then( ( op ) =>
  {
    if( chocoExists === false || op.exitCode !== 0 )
    return null;
    test.case = 'check node program';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /v\d\d\.\d{1,2}\.\d/ ), 1 );
    return null;
  });

  a.shellNonThrowing( 'npm --version' )
  .then( ( op ) =>
  {
    if( chocoExists === false || op.exitCode !== 0 )
    return null;
    test.case = 'check npm package';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\d\.\d{1,2}\.\d/ ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

installNvmWindows.timeOut = 300000;

// --
// declaration
// --

const Proto =
{

  name : 'Setup.test.s',
  silencing : 1,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    provider : null,
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null
  },

  tests :
  {

    backupGitConfig,
    cleanGitConfig,
    setupGitConfig,
    installNvmPosix,
    installNvmWindows,

  }

}

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
