( function _Setup_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( 'wTools' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );
}

let _ = _global_.wTools;

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

function gitConfigResetGlobal( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* to prevent global config corruption */
  if( !_.process.insideTestContainer() )
  {
    test.true( true );
    return;
  }

  /* save original global config */
  let globalConfigPath, originalGlobalConfig;
  a.ready.then( ( op ) =>
  {
    globalConfigPath = a.path.nativize( a.path.join( process.env.HOME, '.gitconfig' ) );
    originalGlobalConfig = a.fileProvider.fileRead( globalConfigPath );
    return null;
  });

  const ext = process.platform === 'win32' ? 'bat' : 'sh';
  const scriptPath = a.path.join( __dirname, `../../../GitConfigGlobalSetup.${ ext }` );

  /* */

  begin();
  a.shell( `${ scriptPath } user user@domain.com` );
  a.shell( 'git config --global --list' )
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
  a.shell( `${ scriptPath } user user@domain.com` );
  a.shell( 'git config --global --list' )
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
  a.shell( `${ scriptPath } user` );
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.case = 'almost empty global config - only user name';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 0 );
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
  a.shell( `${ scriptPath } user` );
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.case = 'global config with field - only user name';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 0 );
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
  a.shell( `${ scriptPath }` );
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.case = 'almost empty global config - without user name and email';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 0 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 0 );
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
  a.shell( `${ scriptPath }` );
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.case = 'global config with field - only user name';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user2' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 0 );
    test.identical( _.strCount( op.output, 'core.autocrlf=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.ignorecase=false' ), 1 );
    test.identical( _.strCount( op.output, 'core.filemode=false' ), 1 );
    test.identical( _.strCount( op.output, 'credential.helper=store' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://user@github.com.insteadof=https://github.com' ), 0 );
    test.identical( _.strCount( op.output, 'url.https://user@bitbucket.org.insteadof=https://bitbucket.org' ), 0 );
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

//

function nvmNjsInstallPosix( test )
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

  const scriptPath = a.path.join( __dirname, `../../../NvmNjsInstall.sh` );

  /* */

  a.shell({ execPath : `${ scriptPath }`, timeOut : 30000 })
  .then( ( op ) =>
  {
    test.case = 'install nvm and lates lts nodejs';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '=> Downloading nvm from git to' ), 1 );
    test.identical( _.strCount( op.output, '=> Initialized empty Git repository in' ), 1 );
    test.identical( _.strCount( op.output, '=> Compressing and cleaning up git repository' ), 1 );
    test.identical( _.strCount( op.output, '=> Appending nvm source string to' ), 1 );
    test.identical( _.strCount( op.output, '=> Appending bash_completion source string to' ), 1 );
    test.identical( _.strCount( op.output, 'Installing latest LTS version' ), 1 );
    test.identical( _.strCount( op.output, 'Attempting to upgrade to the latest working version of npm' ), 1 );
    var exp = '* Installing latest `npm`; if this does not work on your node version, please report a bug!';
    test.identical( _.strCount( op.output, exp ), 1 );
    return null;
  });

  a.shell( 'nvm list' )
  .then( ( op ) =>
  {
    test.case = 'check nvm command';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'lts/argon -> v4.9.1' ), 1 );
    test.identical( _.strCount( op.output, 'lts/boron -> v6.17.1' ), 1 );
    test.identical( _.strCount( op.output, 'lts/carbon -> v8.17.0' ), 1 );
    test.identical( _.strCount( op.output, 'lts/dubnium -> v10.23.1' ), 1 );
    test.identical( _.strCount( op.output, 'lts/erbium -> v12.20.1' ), 1 );
    test.identical( _.strCount( op.output, 'lts/fermium -> v14.15.4' ), 1 );
    return null;
  });

  a.shell( 'node --version' )
  .then( ( op ) =>
  {
    test.case = 'check node program';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /v\d\d\.\d\d\.\d/ ), 1 );
    return null;
  });

  a.shell( 'npm --version' )
  .then( ( op ) =>
  {
    test.case = 'check npm package';
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\d\.\d\d\.\d\d/ ), 1 );
    return null;
  });

  return a.ready;
}

nvmNjsInstallPosix.timeOut = 60000;

// --
// declaration
// --

let Self =
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

    gitConfigResetGlobal,
    nvmNjsInstallPosix,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
