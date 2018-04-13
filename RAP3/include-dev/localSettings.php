<?php
// This localsettings is intended specifically for RAP3 in production
use Ampersand\Log\Logger;
use Ampersand\Log\NotificationHandler;
use Ampersand\Config;
use Ampersand\AngularApp;

define ('LOCALSETTINGS_VERSION', 1.5); // production
set_time_limit ( 60 );
date_default_timezone_set('Europe/Amsterdam');

/**************************************************************************************************
 * LOGGING functionality
 *************************************************************************************************/
error_reporting(E_ALL & ~E_NOTICE);
// After deployment test: change 'true' in the following line into 'false'
ini_set("display_errors", true);   // meant for diagnosis (We would call this "fatals", but then for PHP.)

// After deployment test: change 'true' in the following line into 'false'
Config::set('debugMode', 'global', true);

// Log file handler
$fileHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/error.log', 0, \Monolog\Logger::WARNING);
//$fileHandler->pushProcessor(new \Monolog\Processor\WebProcessor()); // Adds IP adres and url info to log records
Logger::registerGenericHandler($fileHandler);

// Browsers debuggers
//$browserHandler = new \Monolog\Handler\ChromePHPHandler(\Monolog\Logger::DEBUG); // Log handler for Google Chrome
//$browserHandler = new \Monolog\Handler\FirePHPHandler(\Monolog\Logger::DEBUG); // Log handler for Firebug in Mozilla Firefox
//Logger::registerGenericHandler($browserHandler);

if(Config::get('debugMode')){
    $fileHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/debug.log', 0, \Monolog\Logger::DEBUG);
    Logger::registerGenericHandler($fileHandler);
    $execEngineHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/execengine.log', 0, \Monolog\Logger::INFO);
    Logger::registerHandlerForChannel('EXECENGINE', $execEngineHandler);
}

// User log handler
Logger::registerHandlerForChannel('USERLOG', new NotificationHandler(\Monolog\Logger::INFO));

/**************************************************************************************************
 * RAP3 settings
 *************************************************************************************************/
//Config::set('ampersand', 'RAP3', 'C:\\Users\\sjo\\AppData\\Roaming\\local\\bin\\ampersand.exe');
//Config::set('FuncSpecCmd', 'RAP3', 'value'); 
//Config::set('DiagCmd', 'RAP3', 'value');
//Config::set('ProtoCmd', 'RAP3', 'value');
//Config::set('LoadInRap3Cmd', 'RAP3', 'value');

/**************************************************************************************************
 * SERVER settings
 *************************************************************************************************/
// The serverURL is used in OAuth, for the purpose of (for example) logging in with your facebook account.
// Config::set('serverURL', 'global', 'http://rap.cs.ou.nl/RAP3'); // this is {APPURL} as defined in the SPREG deployment text


// After deployment test: change 'false' to 'true'
Config::set('productionEnv', 'global', false); // Set to 'true' to disable the database-reinstall.

/**************************************************************************************************
 * DATABASE settings
 *************************************************************************************************/
// Before deployment test: uncomment the lines below, AND replace the variables {SQLUSER}, {SQLPW}, {SQLDB}, {SQLHOST} with appropriate values
Config::set('dbUser', 'mysqlDatabase', 'ampersand');     // typically: 'ampersand'
Config::set('dbPassword', 'mysqlDatabase', 'ampersand');   // typically: 'ampersand'
// Config::set('dbName', 'mysqlDatabase', '{SQLDB}');       // typically: '' or 'ampersand_rap3'
Config::set('dbHost', 'mysqlDatabase', 'localhost');     // typically: 'localhost' on personal computers or 'db' on docker-containers
//Config::set('dbHost', 'mysqlDatabase', getenv('AMPERSAND_DB_HOST'));     // this should probably be done with an environment variable... 

/**************************************************************************************************
 * LOGIN FUNCTIONALITY
 * 
 * The login functionality requires the ampersand SIAM module
 * The module can be downloaded at: https://github.com/AmpersandTarski/ampersand-models/tree/master/SIAM
 * Copy and rename the SIAM_Module-example.adl into SIAM_Module.adl
 * Include this file into your project, to ensure that sessions are automatically linked to accounts.
 * Uncomment the config setting below
 *************************************************************************************************/
Config::set('loginEnabled', 'global', true);

/**************************************************************************************************
 * UI Additions
 *************************************************************************************************/
AngularApp::addJS('extensions/AceEditor/ace/src-min-noconflict/ace.js'); // Ace editor library
AngularApp::addJS('extensions/AceEditor/ui-ace.js'); // Angular UI wrapper for Ace editor
AngularApp::addJS('extensions/AceEditor/rap3-ace.js'); // Adds Ace editor to RAP3 application

/**************************************************************************************************
 * EXTENSIONS
 *************************************************************************************************/
require_once(__DIR__ . '/extensions/ExecEngine/ExecEngine.php'); // Enable ExecEngine
// Config::set('allowedRolesForRunFunction','execEngine', []); // Role(s) for accounts that are allowed to run the ExecEngine from the menu
Config::set('autoRerun', 'execEngine', true);
Config::set('maxRunCount', 'execEngine', 10);

require_once(__DIR__ . '/extensions/ExcelImport/ExcelImport.php'); // Enable ExcelImport
// After deployment test: uncomment the following line
Config::set('allowedRolesForExcelImport','excelImport', ['ExcelImporter']); // Role(s) for accounts that are allowed to import excel files.

require_once(__DIR__ . '/extensions/OAuthLogin/OAuthLogin.php');
	Config::set('redirectAfterLogin', 'OAuthLogin', 'http://example.com/AmpersandPrototypes/RAP3/#/My_32_Account');
	Config::set('identityProviders', 'OAuthLogin',
	                   ['linkedin' => 
							    ['name' => 'LinkedIn'
                                ,'logoUrl' => 'extensions/OAuthLogin/ui/images/logo-linkedin.png'
                                ,'authBase' => 'https://www.linkedin.com/uas/oauth2/authorization'
								,'redirectUrl' => 'http://example.com/AmpersandPrototypes/RAP3/api/v1/oauthlogin/callback/linkedin'
								,'clientId' => '86s07m9hyin5fg'
								,'clientSecret' => 'wJHIRIQms5d2Sx1C'
								,'tokenUrl' => 'https://www.linkedin.com/uas/oauth2/accessToken'
								,'apiUrl' => 'https://api.linkedin.com/v1/people/~:(emailAddress)?format=json'
								,'scope' => 'r_emailaddress'
								,'state' => '4b253460f09386c8a5f42dfec2522ecf2d0083e25b2284806af0f1c444b62c37' // A unique string value of your choice that is hard to guess. Used to prevent CSRF
								,'emailField' => 'emailAddress'
                                ]
			   ,'github' =>
                                ['name' => 'GitHub'
                                ,'logoUrl' => 'extensions/OAuthLogin/ui/images/logo-github.png'
                                ,'authBase' => 'https://github.com/login/oauth/authorize'
                                ,'redirectUrl' => 'http://example.com/AmpersandPrototypes/RAP3/api/v1/oauthlogin/callback/github'
                                ,'clientId' => 'c5a0bae9b2a78e478346'
                                ,'clientSecret' => '6ab971bc6b1e34cc9b1b8662005586c635c7a067'
                                ,'tokenUrl' => 'https://github.com/login/oauth/access_token'
                                ,'apiUrl' => 'https://api.github.com/user/emails'
                                ,'scope' => 'user:email'
                                ,'state' => '4b253460f09386c8a5f42dfec2522ecf2d0083e25b2284806af0f1c444b62c37' // A unique string value of your choice that is hard to guess. Used to prevent CSRF
                                ]
                           ]
				);
				
?>