<?php

use Ampersand\Log\Logger;
use Ampersand\Log\NotificationHandler;
use Ampersand\Config;

define ('LOCALSETTINGS_VERSION', 1.5);

date_default_timezone_set('Europe/Amsterdam');

/**************************************************************************************************
 * Execution time limit is set to a default of 30 seconds. Use 0 to have no time limit. (not advised)
 *************************************************************************************************/
set_time_limit (30);

/**************************************************************************************************
 * specifies whether changes in interface are directly communicated (saved) to server (default = true)
 * the user can change this setting from the menu bar 
 *************************************************************************************************/
Config::set('interfaceAutoSaveChanges', 'transactions', true); 

/**************************************************************************************************
 * LOGGING functionality
 *************************************************************************************************/
error_reporting(E_ALL & ~E_NOTICE);
// After deployment test: change 'true' in the following line into 'false'
ini_set("display_errors", true);

// After deployment test: change 'true' in the following line into 'false'
Config::set('debugMode', 'global', true);

// Log file handler
$fileHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/error.log', 0, \Monolog\Logger::WARNING);
//$fileHandler->pushProcessor(new \Monolog\Processor\WebProcessor()); // Adds IP adres and url info to log records
Logger::registerGenericHandler($fileHandler);

if(Config::get('debugMode')){
    $fileHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/debug.log', 0, \Monolog\Logger::DEBUG);
    Logger::registerGenericHandler($fileHandler);
}

// After deployment test: turn the below two lines into comments
$execEngineHandler = new \Monolog\Handler\RotatingFileHandler(__DIR__ . '/log/execengine.log', 0, \Monolog\Logger::INFO);
Logger::registerHandlerForChannel('EXECENGINE', $execEngineHandler);

// User log handler
Logger::registerHandlerForChannel('USERLOG', new NotificationHandler(\Monolog\Logger::INFO));

/**************************************************************************************************
 * SERVER settings
 *************************************************************************************************/
// Before deployment test: uncomment the following line and replace {APPURL} with the value you chose (e.g. http://www.yourdomain.nl) 
// Config::set('serverURL', 'global', '{APPURL}'); // this is {APPURL} as defined in the SPREG deployment text

// Before deployment test: remove the following line (and this comment line)
Config::set('serverURL', 'global', 'http://localhost/MPTrx'); // this is {APPURL} we have used for our internal testing purposes and is obsolete when deployed.

// After deployment test: change 'false' to 'true' in the following line
Config::set('productionEnv', 'global', false); // Set to 'true' to disable the database-reinstall.

/**************************************************************************************************
 * DATABASE settings
 *************************************************************************************************/
// Before deployment test: uncomment the lines below, AND replace the variables {SQLUSER}, {SQLPW}, {SQLDB} with appropriate values
// Config::set('dbUser', 'mysqlDatabase', '{SQLUSER}');
// Config::set('dbPassword', 'mysqlDatabase', '{SQLPW}');
// Config::set('dbName', 'mysqlDatabase', '{SQLDB}');

/**************************************************************************************************
 * LOGIN FUNCTIONALITY
 *************************************************************************************************/
Config::set('loginEnabled', 'global', false);

/**************************************************************************************************
 * EXTENSIONS
 *************************************************************************************************/
require_once(__DIR__ . '/extensions/ExecEngine/ExecEngine.php'); // Enable ExecEngine
// After deployment test: uncomment the following line
// Config::set('allowedRolesForRunFunction','execEngine', []); // Role(s) for accounts that are allowed to run the ExecEngine from the menu

require_once(__DIR__ . '/extensions/ExcelImport/ExcelImport.php'); // Enable ExcelImport
// After deployment test: uncomment the following line
// Config::set('allowedRolesForExcelImport','excelImport', ['ExcelImporter']); // Role(s) for accounts that are allowed to import excel files.

?>