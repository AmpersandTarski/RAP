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
ini_set("display_errors", false);   // meant for diagnosis (We would call this "fatals", but then for PHP.)

// After deployment test: change 'true' in the following line into 'false'
Config::set('debugMode', 'global', false);

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
<<<<<<< HEAD:RAP3/include/localSettings.php
Config::set('serverURL', 'global', 'http://rap.cs.ou.nl/'); // this is {APPURL} as defined in the SPREG deployment text
=======
//Config::set('serverURL', 'global', 'http://rap.cs.ou.nl/RAP3/'); // this is {APPURL} as defined in the SPREG deployment text
Config::set('serverURL', 'global', 'http://localhost/RAP3/'); // this is {APPURL} as defined in the SPREG deployment text
>>>>>>> RAP3_Development:RAP3/include/localSettingsDevStef.php


// After deployment test: change 'false' to 'true'
Config::set('productionEnv', 'global', false); // Set to 'true' to disable the database-reinstall.

/**************************************************************************************************
 * DATABASE settings
 *************************************************************************************************/
// Before deployment test: uncomment the lines below, AND replace the variables {SQLUSER}, {SQLPW}, {SQLDB}, {SQLHOST} with appropriate values
Config::set('dbUser', 'mysqlDatabase', 'ampersand');     // typically: 'ampersand'
Config::set('dbPassword', 'mysqlDatabase', 'ampersand');   // typically: 'ampersand'
// Config::set('dbName', 'mysqlDatabase', '{SQLDB}');       // typically: '' or 'ampersand_rap3'
<<<<<<< HEAD:RAP3/include/localSettings.php
Config::set('dbHost', 'mysqlDatabase', 'db');     // typically: 'localhost' on personal computers or 'db' on docker-containers
=======
Config::set('dbHost', 'mysqlDatabase', 'localhost');     // typically: 'localhost' on personal computers or 'db' on docker-containers
>>>>>>> RAP3_Development:RAP3/include/localSettingsDevStef.php

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

?>