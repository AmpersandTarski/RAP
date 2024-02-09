<?php

namespace RAP4;

use RAP4\DeploymentInterface;
use Ampersand\Extension\RAP4\Command;
use Exception;

class KubernetesDeployment implements DeploymentInterface{
    private $userName;
    private $ee;

    public function __construct($userName, $ee) {
        $this->userName = $userName;
        $this->ee = $ee;
    }

    public function deploy() {
        // Your Kubernetes deployment code here
        /** Deployed on Kubernetes Cluster
         * Save student-manifest-template.yaml at a logical location
         * - Copy student-manifest-template.yaml as student-manifest-{{student}}.yaml to /data/
         * - replace {{student}} and {{namespace}}
         * - replace {{adl-base64}} with base64 compiled adl file
         * - save
         * - run kubectl apply -f "student-manifest-{{student}}.yaml"
        */
        $namespace=getenv('RAP_KUBERNETES_NAMESPACE');
        $suffix=substr($namespace, 3);

        $getImageCommand = new Command(
            "kubectl get deployment/student-prototype{$suffix} -n {$namespace}",
            [ "-o=jsonpath='{\$.spec.template.spec.containers[0].image}'"
            ],
            $ee->getLogger()
        );
        $getImageCommand->execute();
        $containerImage=$getImageCommand->getResponse();

        $dbName="rap-db{$suffix}";
        $dbSecret="db-secrets{$suffix}";
        $tlsSecret="{$this->$userName}-tls{$suffix}";
        // Location to save files
        $manifestFile = $ee->getApp()->getSettings()->get('global.absolutePath') . '/bootstrap/files/student-manifest-template.yaml';
        // Open student-manifest-template.yaml
        $manifest=file_get_contents($manifestFile);
        if ($manifest === false) {
            throw new Exception("Student manifest template not found for '{$this->$scriptVersionAtom}', workDir: {$this->$workDir}, manifestFile: {$manifestFile}", 500);
        }
        // replace {{student}}, {{namespace}} and {{scriptContent}}
        $manifest=str_replace("{{student}}", $this->$userName, $manifest);
        $manifest=str_replace("{{namespace}}", $namespace, $manifest);
        $manifest=str_replace("{{containerImage}}", $containerImage, $manifest);
        $manifest=str_replace("{{dbName}}", $dbName, $manifest);
        $manifest=str_replace("{{dbSecrets}}", $dbSecret, $manifest);
        $manifest=str_replace("{{hostName}}", $this->$hostName, $manifest);
        $manifest=str_replace("{{tlsSecret}}", $tlsSecret, $manifest);
        $manifest=str_replace("{{zipContent}}", $this->$zipContentForCommandline, $manifest);
        $manifest=str_replace("{{mainAdl}}", $this->$mainAldForCommandLine, $manifest);
        // Save manifest file
        $studentManifestFile="{$this->$workDir}/student-manifest-{$this->$userName}.yaml";
        file_put_contents($studentManifestFile, $manifest);
        // Call Kubernetes API to add script
        $this->$command = new Command(
            "kubectl apply",
            [ "-f",
            "\"{$studentManifestFile}\""
            ],
            $ee->getLogger()
        );
        $this->$command->execute();
    }
}