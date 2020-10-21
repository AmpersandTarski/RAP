# Configuration of the prototpye

## Logging configuration
* The logging configuration is loaded from a `logging.yaml` file in the config folder
* For the specification of the logging file, see: https://github.com/theorchard/monolog-cascade
* The file should be located at: `config/logging.yaml` (default/production)
* A debug logging configuration is available at: `config/logging.debug.yaml`
* You can specify the log configuration via ENV variable `AMPERSAND_LOG_CONFIG`. Set it to 'logging.yaml' (default) or 'logging.debug.yaml'

## Project configuration
The prototype framework automatically loads the following configuration files, in the following order:
This order allows to have different environments with the same base project configuration
Configuration values overwrite each other, when specified in multiple files

1. `src/Ampersand/Misc/defaultSettings.yaml` -> framework default settings
2. `generics/settings.json` -> project specific settings from Ampersand compiler
3. `config/project.yaml` -> project specific framework settings

The configuration file has the following components:
* settings: a key/value pair list of config settings
* config: list of other config files that must be imported
* extensions: named list of extensions to be included, its bootstrapping and config files

## Environment variables
Finally certain settings can be set using environment variables.
These are loaded last and overwrite previous set settings.
* AMPERSAND_DEBUG_MODE -> global.debugMode
* AMPERSAND_PRODUCTION_MODE -> global.productionEnv
* AMPERSAND_DBHOST -> mysql.dbHost
* AMPERSAND_SERVER_URL -> global.serverURL
* AMPERSAND_DBNAME -> mysql.dbName
