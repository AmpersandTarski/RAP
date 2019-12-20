# Configuration of the prototpye

## Specifying the application environment
Specify the name of the environment using the environment variable `AMP_PROTO_ENV_NAME`
When this env variable is not set, the default value is `default`

## Logging configuration
* The logging configuration is loaded from a `logging.yaml` file for the specified application environment
* For the specification of the logging file, see: https://github.com/theorchard/monolog-cascade
* The file should be located at: `config/env/[env-name]/logging.yaml`
* A default logging configuration is available for the `default` and `dev` environment

## Project configuration
The prototype framework automatically loads the following configuration files, in the following order:
This order allows to have different environments with the same base project configuration
Configuration values overwrite each other, when specified in multiple files

1. `src/Ampersand/Misc/defaultSettings.yaml` -> framework default settings
2. `generics/settings.json` -> project specific settings from Ampersand compiler
3. `config/project.yaml` -> project specific framework settings
4. `config/env/[env-name]/project.yaml` -> environment specific framework settings

The configuration file has the following components:
* settings: a key/value pair list of config settings
* config: list of other config files that must be imported
* extensions: named list of extensions to be included, its bootstrapping and config files