<?php

use Ampersand\Log\Logger;
use Ampersand\Log\NotificationHandler;
use Ampersand\Log\RequestIDProcessor;
use Ampersand\Misc\Config;
// use Ampersand\Rule\ExecEngine;
use Ampersand\Plugs\MysqlDB\MysqlDB;

define('LOCALSETTINGS_VERSION', 1.6);

date_default_timezone_set('Europe/Amsterdam'); // See http://php.net/manual/en/timezones.php for a list of supported timezones

/**************************************************************************************************
 * LOGGING functionality
 *************************************************************************************************/
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", false);

/**************************************************************************************************
 * Execution time limit is set to a default of 30 seconds. Use 0 to have no time limit. (not advised)
 *************************************************************************************************/
set_time_limit(30);

Config::set('debugMode', 'global', true); // default mode = false

// Log file handler
$fileHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/error.log', 0, \Monolog\Logger::DEBUG);
// $fileHandler->pushProcessor(new RequestIDProcessor())->pushProcessor(new WebProcessor(null, [ 'ip' => 'REMOTE_ADDR', 'method' => 'REQUEST_METHOD', 'url' => 'REQUEST_URI'])); // Adds IP adres and url info to log records
$wrapper = new \Monolog\Handler\FingersCrossedHandler($fileHandler, \Monolog\Logger::ERROR, 0, true, true, \Monolog\Logger::WARNING);
Logger::registerGenericHandler($wrapper);

if (Config::get('debugMode')) {
    $fileHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/debug.log', 0, \Monolog\Logger::DEBUG);
    Logger::registerGenericHandler($fileHandler);
    
    // Browsers debuggers
    //$browserHandler = new \Monolog\Handler\ChromePHPHandler(\Monolog\Logger::DEBUG); // Log handler for Google Chrome
    //$browserHandler = new \Monolog\Handler\FirePHPHandler(\Monolog\Logger::DEBUG); // Log handler for Firebug in Mozilla Firefox
    //Logger::registerGenericHandler($browserHandler);
}

$execEngineHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/execengine.log', 0, \Monolog\Logger::DEBUG);
Logger::registerHandlerForChannel('EXECENGINE', $execEngineHandler);

// User log handler
Logger::registerHandlerForChannel('USERLOG', new NotificationHandler(\Monolog\Logger::INFO));

/**************************************************************************************************
 * SERVER settings
 *************************************************************************************************/
// Config::set('serverURL', 'global', 'http://www.yourdomain.nl'); // defaults to http://localhost/<ampersand context name>
// Config::set('apiPath', 'global', '/api/v1'); // relative path to api


/**************************************************************************************************
 * DATABASE settings
 *************************************************************************************************/
$container['mysql_database'] = function ($c) {
    $dbHost = Config::get('dbHost', 'db');
    $dbUser = Config::get('dbUser', 'ampersand');
    $dbPass = Config::get('dbPassword', 'ampersand');
    $dbName = Config::get('dbName', 'mysqlDatabase');
    return new MysqlDB($dbHost, $dbUser, $dbPass, $dbName, Logger::getLogger('DATABASE'));
};
$container['default_plug'] = function ($c) {
    return $c['mysql_database'];
};

/**************************************************************************************************
 * LOGIN FUNCTIONALITY
 *
 * The login functionality requires the ampersand SIAM module
 * The module can be downloaded at: https://github.com/AmpersandTarski/ampersand-models/tree/master/SIAM
 * Copy and rename the SIAM_Module-example.adl into SIAM_Module.adl
 * Include this file into your project
 * Uncomment the config setting below
 *************************************************************************************************/
Config::set('loginEnabled', 'global', true);
// Config::set('loginPage', 'login', 'ext/Login');
// Config::set('allowedRolesForImporter', 'global', []); // list of roles that have access to the importer

/**************************************************************************************************
 * UI Additions
 *************************************************************************************************/
AngularApp::addJS('extensions/AceEditor/ace/src-min-noconflict/ace.js'); // Ace editor library
AngularApp::addJS('extensions/AceEditor/ui-ace.js'); // Angular UI wrapper for Ace editor
AngularApp::addJS('extensions/AceEditor/rap3-ace.js'); // Adds Ace editor to RAP3 application


/**************************************************************************************************
 * ExecEngine
 *************************************************************************************************/
Config::set('execEngineRoleNames', 'execEngine', ['ExecEngine']);
Config::set('autoRerun', 'execEngine', true);
Config::set('maxRunCount', 'execEngine', 10);
chdir(__DIR__);
foreach(glob('execfunctions/*.php') as $filepath) require_once(__DIR__ . DIRECTORY_SEPARATOR . $filepath);


/**************************************************************************************************
 * EXTENSIONS
 *************************************************************************************************/
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
