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
  const scriptPath = a.path.join( __dirname, `../../../GitConfigReset.${ ext }` );

  /* */

  begin();
  a.shell( 'git config --global user.name "user2"' );
  a.shell( `${ scriptPath } user user@domain.com` );
  a.ready.then( ( op ) =>
  {
    debugger;
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    debugger;
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user.name=user' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
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
    a.ready.then( () => a.fileProvider.filesDelete( a.abs( '.' ) ));
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git init` );
    return a.ready;
  }
}

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

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
