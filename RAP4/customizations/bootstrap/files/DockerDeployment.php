<?php

namespace RAP4;

use RAP4\DeploymentInterface;
use Ampersand\Extension\RAP4\Command;

class DockerDeployment implements DeploymentInterface{
    private $userName;
    private $ee;

    public function __construct($userName, $ee) {
        $this->userName = $userName;
        $this->ee = $ee;
    }

    public function deploy() {
        // Your Docker deployment code here
        /** Deployed with Docker Compose */

            // Stop any existing prototype container for this user
            $remove = new Command(
                "docker rm",
                [ "-f",
                "\"{$this->$userName}\""
                ],
                $ee->getLogger()
            );
            $remove->execute();

            // Run student prototype with Docker
            $this->$command = new Command(
                "echo \"{$this->$zipContentForCommandline} {$this->$mainAldForCommandLine}\" | docker run",
                [ "--name \"{$this->$userName}\"",
                "--rm",   # deletes the container when it is stopped. Useful to prevent container disk space usage to explode.
                "-i",
                "-p 8000:80",
                "-a stdin",  // stdin ensures that the content of the script is available in the container.
                "--network proxy", // the reverse proxy Traefik is in the proxy network
                "--label traefik.enable=true", // label for Traefik to route trafic
                "--label traefik.docker.network=proxy",  // solving RAP issue #92
                "--label traefik.http.routers.{$this->$userName}-insecure.rule=\"Host(\\`{$this->$hostName}\\`)\"", // e.g. student123.rap.cs.ou.nl
                "--label student-prototype", // label used by cleanup process to remove all (expired) student prototypes
                "-e AMPERSAND_DBHOST=" . getenv('AMPERSAND_DBHOST'), // use same database host as the RAP4 application itself
                "-e AMPERSAND_DBNAME=\"student_{$this->$userName}\"",
                "-e AMPERSAND_DBUSER=" . getenv('AMPERSAND_DBUSER'), // TODO change db user to a student prototype specific user with less privileges and limited to databases with prefix 'student_'
                "-e AMPERSAND_DBPASS=" . getenv('AMPERSAND_DBPASS'),
                "-e AMPERSAND_PRODUCTION_MODE=\"false\"", // student must be able to reset his/her application
                "-e AMPERSAND_DEBUG_MODE=\"true\"", // show student detailed log information, is needed otherwise user is e.g. not redirected to reinstall page
                "-e AMPERSAND_SERVER_URL=\"https://{$this->$hostName}\"",
                "-e AMPERSAND_LOG_CONFIG={$this->$studentProtoLogConfig}", // use high level logging
                $this->$studentProtoImage // image name to run
                ],
                $ee->getLogger()
            );
            $this->$command->execute();

            // Add docker container also to rap_db network
            $command2 = new Command(
                "docker network connect rap_db {$this->$userName}",
                [],
                $ee->getLogger()
            );
            $command2->execute();
    }
}