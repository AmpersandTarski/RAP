<?php

namespace RAP4;

use Ampersand\Rule\ExecEngine;

use Ampersand\AmpersandApp;
use Exception;
use Ampersand\Extension\RAP4\Command;

// ---------Mo----------------------------
/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('GenerateJsonATLAS', function ($scriptId, $scriptVersionId, $srcRelPath, $userName) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $scriptAtom = $model->getConceptByLabel('Script')->makeAtom($scriptId);
    $scriptVersionAtom = $model->getConceptByLabel('ScriptVersion')->makeAtom($scriptVersionId);


    // The relative path of the source file must be something like:
    // ./scripts/<userId>/<scriptId>/<versionId>/script.adl
    $basePath = "scripts/{$userName}/{$scriptId}/{$scriptVersionId}";
    $srcRelPath = "{$basePath}/ATLAS_file.json";
    $srcAbsPath = $ee->getApp()->getSettings()->get('global.absolutePath') . '/data/' . $srcRelPath;

    // Controleer of de directory bestaat, zo niet, maak deze
    if (!file_exists(dirname($srcAbsPath))) {
        mkdir(dirname($srcAbsPath), 0777, true);
    }

    // // -------------------- Probeersel intern de ResourceController aan te spreken (werkt niet)
    // $resourceController = new ResourceController($ee->getLogger());
    // // Stel de nodige parameters in
    // $resourceType = 'ScriptVersion';
    // $resourceId = $scriptAtomId; // Aannemende dat dit de ID is van de ScriptVersion
    // $resourcePath = 'Atlas_32_population';
    // $options = ['metaData' => 0, 'navIfc' => 0]; // Opties als query parameters
    // // Roep getResourceData of een vergelijkbare methode aan om de data op te halen
    // $data = $resourceController->getResourceData($resourceType, $resourceId, $resourcePath, $options);
    // //$data = $this->getResourceData('ScriptVersion', $scriptAtomId, 'Atlas_32_population', ['metaData' => 0, 'navIfc' => 0]);
    // --------------------


    // Definieer de API-call "/api/v1/resource/ScriptVersion/{$scriptAtomId}/Atlas_32_population?metaData=0&navIfc=0";
    // Dynamisch opbouwen van de host URL
    $scheme = isset($_SERVER['HTTPS']) ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST']; // Pas op in CLI-modus kan dit anders zijn
    $apiPath = "/api/v1/resource/ScriptVersion/{$scriptVersionId}/Atlas_32_population?metaData=0&navIfc=0"; //pad naar de interface
    $apiUrl = "{$scheme}://{$host}{$apiPath}";

    // Initialiseer cURL sessie
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $apiUrl);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPGET, true);

    // Voer de API-call uit
    $response = curl_exec($ch);
    if (curl_errno($ch)) {
        throw new Exception(curl_error($ch));
    }

    // Sluit cURL sessie
    curl_close($ch);

    // Decodeer de JSON respons (optioneel, afhankelijk van of je de ruwe JSON of een PHP array wilt opslaan)
    $data = json_decode($response, true);

    file_put_contents($srcAbsPath, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));

    return $srcAbsPath; // Retourneer het pad van het gegenereerde bestand    

    /**
     * Eerst moet de datababase gecontrolleerd worden op file_put_contents
     * Dan moet de database omgezet worden naar een .json file
     *api/v1/resource/ScriptVersion/[SCRIPTVERSION]/Atlas_32_population?metaData=0&navIfc=0
     */
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('ConvertToADL', function ($scriptId, $scriptVersionId, $srcRelPath, $userName) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $scriptAtom = $model->getConceptByLabel('Script')->makeAtom($scriptId);
    $scriptVersionAtom = $model->getConceptByLabel('ScriptVersion')->makeAtom($scriptVersionId);

    // The relative path of the new file must be something like:
    // ./scripts/<userId>/<scriptId>/<versionId>/out.adl
    $basePath = "scripts/{$userName}/{$scriptId}/{$scriptVersionId}";
    $relPath = $ee->getApp()->getSettings()->get('global.absolutePath') . '/data/' . $basePath;
    $srsRelPath = "{$relPath}/ATLAS_file.json";
    $tgtRelPath = "{$relPath}/out.adl";
    $testPath = "{$relPath}/test/out.adl";


    // Controleer of de directory bestaat, zo niet, maak deze
    if (!file_exists(dirname($srsRelPath))) {
        mkdir(dirname($srsRelPath), 0777, true);
    }

    //generate the file from the ATLAS population, and get the path
    $path = ExecEngine::getFunction('GenerateJsonATLAS')->call($this, $scriptId, $scriptVersionId, $srcRelPath, $userName);

    $command = new Command(
        'ampersand atlas-import ATLAS_file.json out.adl',
        [
            // 'ATLAS_file.json',
            // 'out.adl'
            //// basename($srsRelPath),            // omit the document, so generate graphics only.
            //// , basename($tgtRelPath)    // needed, or else Ampersand will not run.   // this is 'script.adl'
        ],
        $ee->getLogger()
    );
    $command->execute(dirname($srsRelPath));

    /**
     * de 'GenerateJsonATLAS' - functie moet worden aangeroepen, en de file moet worden opgehaald
     * deze file moet doorgestuurd worden naar omgekeerde grinder, zodat hij in A_structuur staat
     * dan kan van de A_structuur een .adl gegenereerd worden
     */
});
