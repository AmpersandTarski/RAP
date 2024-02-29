<?php

namespace RAP4;

use Exception;
use RAP4\KubernetesDeployment;
use RAP4\DockerDeployment;

class Prototype {
    const PATTERN = '/[\W+]/';
    const REPLACEMENT = '-';

    const KUBERNETES_DEPLOYMENT = 'Kubernetes';

    private $scriptAtom;
    private $scriptVersionAtom;
    private $userName;
    private $ee;

    //Environment variables
    private $hostName;
    private $studentProtoImage;
    private $studentProtoLogConfig;
    private $deployment;

    private $scriptContent;

    private $workDir;

    private $zipContentForCommandline;
    private $mainAldForCommandLine;

    private $command;

    private $deploymentHandler;

    public function __construct(string $path, Atom $scriptAtom, Atom $scriptVersionAtom, string $userName, $ee) {
        $this->scriptAtom = $scriptAtom;
        $this->scriptVersionAtom = $scriptVersionAtom;
        $this->ee = $ee;

        $this->getEnvironmentVariables();

        $relDir = pathinfo($path, PATHINFO_DIRNAME);
        $this->$workDir = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/data/" . $relDir;

        $user = strtolower($userName);
        $this->$userName = preg_replace(Prototype::PATTERN, Prototype::REPLACEMENT, $user);

        if ($deployment == Prototype::KUBERNETES_DEPLOYMENT) {
            $this->deploymentHandler = new KubernetesDeployment($userName, $ee);
        } else {
            $this->deploymentHandler = new DockerDeployment($userName, $ee);
        }
    }

    public function execute() {
        $this->prepareScriptContent();
        $this->createZipFile();
        $this->handleDeployment();

        sleep(5); //  helps to reduce "bad gateway" and "404 page not found" errors.

        $this->populateProtoOk();
    }

    private function getEnvironmentVariables(){
        $serverName=getenv('RAP_HOST_NAME');
        $this->$hostName="{$this->$userName}.{$serverName}";
        $this->$studentProtoImage = getenv('RAP_STUDENT_PROTO_IMAGE');
        $this->$studentProtoLogConfig = getenv('RAP_STUDENT_PROTO_LOG_CONFIG');
        if ($this->$studentProtoLogConfig === false) {
            $this->$studentProtoLogConfig = 'logging.yaml';
        }
        $this->$deployment = getenv('RAP_DEPLOYMENT');
    }

    private function prepareScriptContent() : void {
        // Code for preparing script content
        $scriptContentPairs = $this->$scriptVersionAtom->getLinks('content[ScriptVersion*ScriptContent]');
        if (count($scriptContentPairs) != 1) {
            throw new Exception("No (or multiple) script content found for '{$this->$scriptVersionAtom}'", 500);
        }
        $this->$scriptContent = $scriptContentPairs[0]->tgt()->getId();
    }

    private function createZipFile() {
        // Code for creating zip file
        $projectFolder = "{$this->$workDir}/project";
        $mainAdl = "{$projectFolder}/main.adl";
        
        mkdir($projectFolder);
        file_put_contents($mainAdl, $this->$scriptContent);

        $zipFile = "{$this->$workDir}/project.zip";
        $zip = new \ZipArchive;
        $zip->open($zipFile, \ZipArchive::CREATE);
        $files = new \RecursiveIteratorIterator(
            new \RecursiveDirectoryIterator($projectFolder),
            \RecursiveIteratorIterator::LEAVES_ONLY
        );

        foreach ($files as $name => $file) {
           if (!$file->isDir()) {
               $filePath = $file->getRealPath();
               $relativePath = substr($filePath, strlen($projectFolder) + 1);

               $zip->addFile($filePath, $relativePath);
           }
        }

        $zip->close();

        $zipContent = file_get_contents($zipFile);
        $this->$zipContentForCommandline = base64_encode($zipContent);
        $this->$mainAldForCommandLine = base64_encode("main.adl");
    }

    private function handleDeployment() {
        // Code for handling deployment
        $this->$deploymentHandler->deploy();
    }

    private function populateProtoOk() {
        // Code for populating 'protoOk'
        setProp('protoOk[ScriptVersion*ScriptVersion]', $this->$scriptVersionAtom, $this->$command->getExitcode() == 0);

        $message = $this->$command->getExitcode() === 0 ? "<a href=\"http://{$this->$userName}.{$this->$serverName}\" target=\"_blank\">Open prototype</a>" : $this->$command->getResponse();
        $this->$scriptVersionAtom->link($message, 'compileresponse[ScriptVersion*CompileResponse]')->add();
    }
}
