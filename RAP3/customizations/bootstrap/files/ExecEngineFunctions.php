<?php

namespace RAP3;

use Ampersand\AmpersandApp;
use Exception;
use Ampersand\Core\Atom;
use Ampersand\Core\Concept;
use Ampersand\Rule\ExecEngine;
use Ampersand\Core\Link;
use Ampersand\Extension\RAP3\Command;

/* Ampersand commands must not be changed in this file, but in a configuration yaml file.
 *
 * Use the configuration yaml file to specify the following settings:
 *  rap3.ampersand       : [ampersand compiler executable location]
 *
 * User scripts and generated content are stored in
 * /var/www/data/scripts/<userId>/<scriptId>/<versionId>/script.adl
 * /var/www/data/scripts/<userId>/<scriptId>/<versionId>/diagnosis
 * /var/www/data/scripts/<userId>/<scriptId>/<versionId>/atlas
 * /var/www/data/scripts/<userId>/<scriptId>/<versionId>/fSpec
 * /var/www/data/scripts/<userId>/<scriptId>/prototype # only the last generated proto is kept
 */

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('PerformanceTest', function ($scriptAtomId, $userId) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    
    $total = 5;
    
    for ($i = 0; $i < $total; $i++) {
        $this->debug("Compiling {$i}/{$total}: start");
        
        set_time_limit(600);

        $scriptVersionInfo = ExecEngine::getFunction('CompileToNewVersion')->call($this, $scriptAtomId, $userId);
        if ($scriptVersionInfo === false) {
            throw new Exception("Error while compiling new script version", 500);
        }
        
        ExecEngine::getFunction('CompileWithAmpersand')->call($this, 'loadPopInRAP3', $scriptVersionInfo['id'], $scriptVersionInfo['relpath']);
        
        $this->debug("Compiling {$i}/{$total}: end");
    }
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('CompileToNewVersion', function ($scriptAtomId, $userId) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();
    
    $this->info("CompileToNewVersion({$scriptAtomId},$userId)");
    
    $scriptAtom = $model->getConceptByLabel('Script')->makeAtom($scriptAtomId);
    $version = $model->getConceptByLabel('ScriptVersion')->createNewAtom();

    // The relative path of the source file must be something like:
    // ./scripts/<userId>/<scriptId>/<versionId>/script.adl
    $basePath = "scripts/{$userId}/{$scriptAtom->getId()}/{$version->getId()}";
    $srcRelPath = "{$basePath}/script.adl";
    $srcAbsPath = $ee->getApp()->getSettings()->get('global.absolutePath') . '/data/' . $srcRelPath;
    
    // Script content ophalen en schrijven naar bestandje
    $links = $scriptAtom->getLinks('content[Script*ScriptContent]');
    if (empty($links)) {
        throw new Exception("No script content provided", 500);
    }
    // Make sure that script(version) folder exists
    if (!file_exists(dirname($srcAbsPath))) {
        mkdir(dirname($srcAbsPath), 0777, true);
    }
    // Write script content to script.adl and ScriptVersion
    file_put_contents($srcAbsPath, $scriptContent = current($links)->tgt()->getId());
    $version->link($scriptContent, 'content[ScriptVersion*ScriptContent]')->add();

    // Compile the file, only to check for errors.
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand check'),
        [basename($srcAbsPath)],
        $ee->getLogger()
    );
    $command->execute(dirname($srcAbsPath));
    
    // Save compile output
    $scriptAtom->link($command->getResponse(), 'compileresponse[Script*CompileResponse]')->add();
    
    // Script ok (exitcode 0)
    if ($command->getExitcode() == 0) {
        // Create new script version atom and add to rel version[Script*ScriptVersion]
        $version->link($version, 'scriptOk[ScriptVersion*ScriptVersion]')->add();
        $scriptAtom->link($version, 'version[Script*ScriptVersion]')->add();
        
        // Create representation of file object and link to script version
        $sourceFO = createFileObject($ee->getApp(), $srcRelPath, basename($srcRelPath));
        $version->link($sourceFO, 'source[ScriptVersion*FileObject]')->add();
        
        // create basePath, indicating the relative path to the context stuff of this scriptversion. (Needed by the atlas for its graphics)
        $version->link($basePath . '/fspec/images', 'basePath[ScriptVersion*FilePath]')->add();
        
        return ['id' => $version->getId(), 'relpath' => $srcRelPath];
    // Script not ok (exitcode != 0)
    } else {
        return false;
    }
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('CompileWithAmpersand', function ($action, $scriptId, $scriptVersionId, $srcRelPath) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $scriptAtom = $model->getConceptByLabel('Script')->makeAtom($scriptId);
    $scriptVersionAtom = $model->getConceptByLabel('ScriptVersion')->makeAtom($scriptVersionId);

    // The relative path of the source file must be something like:
    // ./scripts/<userId>/<scriptId>/<versionId>/script.adl
    $relDir = dirname($srcRelPath);
    
    // Script bestand voeren aan Ampersand compiler
    switch ($action) {
        case 'diagnosis':
            ExecEngine::getFunction('Diagnosis')->call($this, $srcRelPath, $scriptVersionAtom);
            break;
        case 'loadPopInRAP3':
            ExecEngine::getFunction('loadPopInRAP3')->call($this, $srcRelPath, $scriptVersionAtom);
            break;
        case 'fspec':
            ExecEngine::getFunction('FuncSpec')->call($this, $srcRelPath, $scriptVersionAtom);
            break;
        case 'prototype':
            ExecEngine::getFunction('Prototype')->call($this, $srcRelPath, $scriptAtom, $scriptVersionAtom);
            break;
        default:
            $this->error("Unknown action '{$action}' specified");
            break;
    }
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('FuncSpec', function (string $path, Atom $scriptVersionAtom) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $relDir    = pathinfo($path, PATHINFO_DIRNAME);
    $workDir   = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/data/" . $relDir;

    // Compile the file, only to check for errors.
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand documentation'),
        ['script.adl', '--format docx', '--language=NL', '--output-dir="."', "--verbosity debug" ],
        $ee->getLogger()
    );
    $command->execute($workDir);

    // Populate 'funcSpecOk' upon success
    setProp('funcSpecOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);
    $scriptVersionAtom->link($command->getResponse(), 'compileresponse[ScriptVersion*CompileResponse]')->add();

    // Create fSpec and link to scriptVersionAtom
    $foObject = createFileObject(
        $ee->getApp(),
        "{$relDir}/{$filename}.docx",
        "Functional specification"
    );
    $scriptVersionAtom->link($foObject, 'funcSpec[ScriptVersion*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('Diagnosis', function (string $path, Atom $scriptVersionAtom) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $relDir    = pathinfo($path, PATHINFO_DIRNAME);
    $workDir   = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/data/" . $relDir;

    // Create fspec with diagnosis chapter
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand documentation'),
        ['script.adl', '--format docx', '--language NL', '--Diagnosis', '--output-dir ./diagnosis', "--verbosity warn" ],
        $ee->getLogger()
    );
    mkdir("diagnosis", 0755, true);
    $command->execute($workDir);

    // Populate 'diagOk' upon success
    setProp('diagOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);
    $scriptVersionAtom->link($command->getResponse(), 'compileresponse[ScriptVersion*CompileResponse]')->add();
    
    // Create diagnose and link to scriptVersionAtom
    $foObject = createFileObject(
        $ee->getApp(),
        "{$relDir}/diagnosis/{$filename}.docx",
        "Diagnosis"
    );
    $scriptVersionAtom->link($foObject, 'diag[ScriptVersion*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('Prototype', function (string $path, Atom $scriptAtom, Atom $scriptVersionAtom) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this

    $scriptContentPairs = $scriptVersionAtom->getLinks('content[ScriptVersion*ScriptContent]');

    $serverName = $ee->getApp()->getSettings()->get('global.serverURL');

    if (count($scriptContentPairs) != 1) {
        throw new Exception("No (or multiple) script content found for '{$scriptVersionAtom}'", 500);
    }

    $scriptContent = $scriptContentPairs[0]->tgt()->getId();
    $scriptContentForCommandline = addslashes($scriptContent);
    $userName = "stefj";  // TODO get the proper user name that is associated with the current session.

    // Stop any existing prototype container for this user
    $remove = new Command(
        "docker rm",
        [ "-f",
          "\"{$userName}\""
        ],
        $ee->getLogger()
    );
    $remove->execute();
    
    // Run student prototype with Docker
    $command = new Command(
        "echo \"{$scriptContentForCommandline}\" | docker run",
        [ "--name \"{$userName}\"",
          "--rm",   # deletes the container when it is stopped. Useful to prevent container disk space usage to explode.
          "-i",
          "-a stdin",  // stdin ensures that the content of the script is available in the container.
          "--network proxy", // the reverse proxy Traefik is in the proxy network
          "--label traefik.enable=true", // label for Traefik to route trafic
          "--label traefik.http.routers.{$userName}-insecure.rule=\"Host(\\`{$userName}.{$serverName}\\`)\"", // e.g. student123.rap.cs.ou.nl
          "-e AMPERSAND_DBHOST=db",
          "-e AMPERSAND_DBNAME=\"{$userName}\"",
          "rap3-student-proto" // image name to run
        ],
        $ee->getLogger()
    );
    $command->execute();
    
    // Add docker container also to rap_db network
    $command2 = new Command("docker network connect rap_db {$userName}", null, $ee->getLogger());
    $command2->execute();

    // Populate 'protoOk' upon success
    setProp('protoOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);

    $message = $command->getExitcode() === 0 ? "<a href=\"http://{$userName}.{$serverName}\" target=\"_blank\">Open prototype</a>" : $command->getResponse();
    $scriptVersionAtom->link($message, 'compileresponse[ScriptVersion*CompileResponse]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('loadPopInRAP3', function (string $path, Atom $scriptVersionAtom) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/data/" . pathinfo($path, PATHINFO_DIRNAME);

    // Create RAP3 population
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand population'),
        [ $basename
        , '--output-dir="./"'
        , "--build-recipe AtlasPopulation"
        , "--output-format json"
        , "--verbosity warn"
        ],
        $ee->getLogger()
    );
    $command->execute($workDir);
    // upon success, the generated file is: ./atlas/{$basename}_generated_pop.json
    
    if ($command->getExitcode() == 0) {
        // Open and decode generated metaPopulation.json file
        $pop = file_get_contents("{$workDir}/{$basename}_generated_pop.json");
        $pop = json_decode($pop, true);
    
        // Add atoms to database
        foreach ($pop['atoms'] as $atomPop) {
            $concept = $model->getConcept($atomPop['concept']);
            foreach ($atomPop['atoms'] as $atomId) {
                $atom = getRAPAtom($atomId, $concept);
                $atom->add(); // Add to database

                // Link Context atom to the ScriptVersion
                if ($concept->getId() == 'Context') {
                    $scriptVersionAtom->link($atom, 'context[ScriptVersion*Context]')->add();
                }
            }
        }
    
        // Add links to database
        foreach ($pop['links'] as $linkPop) {
            $relation = $model->getRelation($linkPop['relation']);
            foreach ($linkPop['links'] as $pair) {
                $pair = new Link(
                    $relation,
                    getRAPAtom($pair['src'], $relation->srcConcept),
                    getRAPAtom($pair['tgt'], $relation->tgtConcept)
                );
                $pair->add();
            }
        }
    }

    // Populate 'loadedInRAP3Ok' to signal success to the ExecEngine
    setProp('loadedInRAP3Ok[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);
    $scriptVersionAtom->link($command->getResponse(), 'compileresponse[ScriptVersion*CompileResponse]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('Cleanup', function ($atomId, $cptId) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this

    $atom = $ee->getApp()->getModel()->getConcept($cptId)->makeAtom($atomId);
    deleteAtomAndLinks($atom, $ee);
});

function deleteAtomAndLinks(Atom $atom, ExecEngine $ee)
{
    static $skipRelations = ['context[ScriptVersion*Context]'];

    $model = $ee->getApp()->getModel();

    $ee->debug("Cleanup called for '{$atom}'");
    
    // Don't cleanup atoms with REPRESENT type
    if (!$atom->concept->isObject()) {
        $ee->debug("Skip cleanup: concept '{$atom->concept}' is not an object");
        return;
    };
    
    // Skip cleanup if atom does not exists (anymore)
    if (!$atom->exists()) {
        $ee->debug("Skip cleanup: atom '{$atom}' does not exist (anymore)");
        return;
    };

    // List for additional atoms that must be removed
    $cleanup = [];
    
    // Walk all relations
    foreach ($model->getRelations() as $rel) {
        if (in_array($rel->signature, $skipRelations)) {
            continue; // Skip relations that are explicitly excluded
        }
        
        // If cleanup-concept is in same typology as relation src concept
        if ($atom->concept->inSameClassificationTree($rel->srcConcept)) {
            foreach ($atom->getLinks($rel) as $link) {
                // Tgt atom in cleanup set
                $ee->debug("Also cleanup atom: {$link->tgt()}");
                $cleanup[] = $link->tgt();
            }
            $rel->deleteAllLinks($atom, 'src');
        }
        
        // If cleanup-concept is in same typology as relation tgt concept
        if ($atom->concept->inSameClassificationTree($rel->tgtConcept)) {
            foreach ($atom->getLinks($rel, true) as $link) {
                // Tgt atom in cleanup set
                $ee->debug("Also cleanup atom: {$link->src()}");
                $cleanup[] = $link->src();
            }
            $rel->deleteAllLinks($atom, 'tgt');
        }
    }
    
    // Delete atom
    $atom->delete();
    
    // Remove duplicates
    $cleanup = array_map('array_unique', $cleanup);
    
    // Delete atom and links recursive
    foreach ($cleanup as $item) {
        call_user_func('deleteAtomAndLinks', $item, $ee);
    }
}

/**
 * Undocumented function
 *
 * @param string $atomId
 * @param \Ampersand\Core\Concept $concept
 * @return \Ampersand\Core\Atom
 */
function getRAPAtom(string $atomId, Concept $concept): Atom
{
    static $rapAtoms = []; // instantiate only the first time the function is called

    // Non-scalar atoms get a new unique identifier
    if ($concept->isObject()) {
        // Caching of atom identifier is done by its largest concept
        $largestC = $concept->getLargestConcept()->getId();
        
        // If atom is already changed earlier, use new id from cache
        if (isset($rapAtoms[$largestC]) && array_key_exists($atomId, $rapAtoms[$largestC])) {
            return $concept->makeAtom($rapAtoms[$largestC][$atomId]); // Atom itself is instantiated with $concept (!not $largestC)
        
        // Else create new id and store in cache
        } else {
            $atom = $concept->createNewAtom(); // Create new atom (with generated id)
            $rapAtoms[$largestC][$atomId] = $atom->getId(); // Cache pair of old and new atom identifier
            return $atom;
        }
    } else {
        return $concept->makeAtom($atomId);
    }
}

/**
 * Undocumented function
 *
 * @param string $propertyRelationSignature name of ampersand property relation that must be (de)populated
 * @param \Ampersand\Core\Atom $atom
 * @param bool $bool specifies if property must be populated (true) or depopulated (false)
 * @return void
 */
function setProp(string $propertyRelationSignature, Atom $atom, bool $bool)
{
    // Before deleteLink always addLink (otherwise Exception will be thrown when link does not exist)
    $atom->link($atom, $propertyRelationSignature)->add();
    if (!$bool) {
        $atom->link($atom, $propertyRelationSignature)->delete();
    }
}

/**
 * Undocumented function
 *
 * @param \Ampersand\AmpersandApp $app
 * @param string $relPath
 * @param string $displayName
 * @return \Ampersand\Core\Atom
 */
function createFileObject(AmpersandApp $app, string $relPath, string $displayName): Atom
{
    $foAtom = $app->getModel()->getConceptByLabel('FileObject')->createNewAtom();
    $foAtom->link($relPath, 'filePath[FileObject*FilePath]')->add();
    $foAtom->link($displayName, 'originalFileName[FileObject*FileName]')->add();
    
    return $foAtom;
}
