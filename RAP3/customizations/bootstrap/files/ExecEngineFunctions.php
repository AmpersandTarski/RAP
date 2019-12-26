<?php

namespace RAP3;

use Exception;
use Ampersand\Core\Atom;
use Ampersand\Core\Concept;
use Ampersand\Rule\ExecEngine;
use Ampersand\Core\Link;
use Ampersand\Extension\RAP3\Command;

/* Ampersand commando's mogen niet in dit bestand worden aangepast
 *
 * Gebruik een configuratie yaml bestand om de volgnde settings te specificeren:
 * rap3.ampersand       : [ampersand compiler executable locatie]
 *
 */

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('PerformanceTest', function ($scriptAtomId, $studentNumber) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    
    $total = 5;
    
    for ($i = 0; $i < $total; $i++) {
        $this->debug("Compiling {$i}/{$total}: start");
        
        set_time_limit(600);

        $scriptVersionInfo = ExecEngine::getFunction('CompileToNewVersion')->call($this, $scriptAtomId, $studentNumber);
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
ExecEngine::registerFunction('CompileToNewVersion', function ($scriptAtomId, $studentNumber) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();
    
    $this->info("CompileToNewVersion({$scriptAtomId},$studentNumber)");
    
    $scriptAtom = $model->getConceptByLabel('Script')->makeAtom($scriptAtomId);

    // The relative path of the source file must be something like:
    //   scripts/<studentNumber>/sources/<scriptId>/Version<timestamp>.adl
    //   This is decomposed elsewhere in cli.php, based on this assumption.
    // Now we will construct the relative path
    $versionId = date('Y-m-d\THis');
    $fileName = "Version{$versionId}.adl";
    $scriptDir = realpath($ee->getApp()->getSettings()->get('global.absolutePath'));
    $relPathSources = "scripts/{$studentNumber}/sources/{$scriptAtom->getId()}/{$fileName}";
    $absPath = "{$scriptDir}/{$relPathSources}";
    
    //construct the path for the relation basePath[ScriptVersion*FilePath]
    $relPathGenerated = "scripts/{$studentNumber}/generated/{$scriptAtom->getId()}/Version{$versionId}/fSpec/";
    
    // Script content ophalen en schrijven naar bestandje
    $links = $scriptAtom->getLinks('content[Script*ScriptContent]');
    if (empty($links)) {
        throw new Exception("No script content provided", 500);
    }
    if (!file_exists(dirname($absPath))) {
        mkdir(dirname($absPath), 0777, true);
    }
    file_put_contents($absPath, current($links)->tgt()->getId());

    // Compile the file, only to check for errors.
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand'),
        [basename($absPath)],
        $ee->getLogger()
    );
    $command->execute(dirname($absPath));
    
    $scriptAtom->link($command->getResponse(), 'compileresponse[Script*CompileResponse]')->add();
    
    if ($command->getExitcode() == 0) { // script ok
        // Create new script version atom and add to rel version[Script*ScriptVersion]
        $version = $model->getConceptByLabel('ScriptVersion')->createNewAtom();
        $version->link($version, 'scriptOk[ScriptVersion*ScriptVersion]')->add();
        $scriptAtom->link($version, 'version[Script*ScriptVersion]')->add();
        
        // Create representation of file object and link to script version
        $sourceFO = createFileObject($model->getConceptByLabel('FileObject'), $relPathSources, $fileName);
        $version->link($sourceFO, 'source[ScriptVersion*FileObject]')->add();
        
        // create basePath, indicating the relative path to the context stuff of this scriptversion. (Needed for graphics)
        $version->link($relPathGenerated, 'basePath[ScriptVersion*FilePath]')->add();
        
        return ['id' => $version->getId(), 'relpath' => $relPathSources];
    } else { // script not ok
        return false;
    }
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('CompileWithAmpersand', function ($action, $scriptId, $scriptVersionId, $relSourcePath) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $scriptAtom = $model->getConceptByLabel('Script')->makeAtom($scriptId);
    $scriptVersionAtom = $model->getConceptByLabel('ScriptVersion')->makeAtom($scriptVersionId);

    // The relative path of the source file will be something like:
    //   scripts/<studentNumber>/sources/<scriptId>/Version<timestamp>.adl
    //   This is constructed elsewhere in cli.php
    // Now we will decompose this path to construct the output directory
    // The output directory will be as follows:
    //   scripts/<studentNumber>/generated/<scriptId>/Version<timestamp>/<actionbased>/
    $studentNumber = basename(dirname(dirname(dirname($relSourcePath))));
    $scriptId      = basename(dirname($relSourcePath));
    $version       = pathinfo($relSourcePath, PATHINFO_FILENAME);
    $relDir        = "scripts/{$studentNumber}/generated/{$scriptId}/{$version}";
    $absDir        = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . $relDir;
    
    // Script bestand voeren aan Ampersand compiler
    switch ($action) {
        case 'diagnosis':
            ExecEngine::getFunction('Diagnosis')->call($this, $relSourcePath, $scriptVersionAtom, $relDir . '/diagnosis');
            break;
        case 'loadPopInRAP3':
            ExecEngine::getFunction('loadPopInRAP3')->call($this, $relSourcePath, $scriptVersionAtom, $relDir . '/atlas');
            break;
        case 'fspec':
            ExecEngine::getFunction('FuncSpec')->call($this, $relSourcePath, $scriptVersionAtom, $relDir . '/fSpec');
            break;
        case 'prototype':
            ExecEngine::getFunction('Prototype')->call($this, $relSourcePath, $scriptAtom, $scriptVersionAtom, $relDir . '/../prototype');
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
ExecEngine::registerFunction('FuncSpec', function (string $path, Atom $scriptVersionAtom, string $outputDir) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . $outputDir;

    // Compile the file, only to check for errors.
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand'),
        [$basename, "-fpdf", "--language=NL", "--outputDir=\"{$absOutputDir}\"" ],
        $ee->getLogger()
    );
    $command->execute($workDir);

    // Populate 'funcSpecOk' upon success
    setProp('funcSpecOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);
    $scriptVersionAtom->link($command->getResponse(), 'compileresponse[ScriptVersion*CompileResponse]')->add();

    // Create fSpec and link to scriptVersionAtom
    $foObject = createFileObject(
        $model->getConceptByLabel('FileObject'),
        "{$outputDir}/{$filename}.pdf",
        "Functional specification"
    );
    $scriptVersionAtom->link($foObject, 'funcSpec[ScriptVersion*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('Diagnosis', function (string $path, Atom $scriptVersionAtom, string $outputDir) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . $outputDir;

    // Create fspec with diagnosis chapter
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand'),
        [$basename, "-fpdf", "--language=NL", "--diagnosis", "--outputDir=\"{$absOutputDir}\"" ],
        $ee->getLogger()
    );
    $command->execute($workDir);

    // Populate 'diagOk' upon success
    setProp('diagOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);
    $scriptVersionAtom->link($command->getResponse(), 'compileresponse[ScriptVersion*CompileResponse]')->add();
    
    // Create diagnose and link to scriptVersionAtom
    $foObject = createFileObject(
        $model->getConceptByLabel('FileObject'),
        "{$outputDir}/{$filename}.pdf",
        "Diagnosis"
    );
    $scriptVersionAtom->link($foObject, 'diag[ScriptVersion*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('Prototype', function (string $path, Atom $scriptAtom, Atom $scriptVersionAtom, string $outputDir) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . $outputDir;
    $sqlHost = $ee->getApp()->getSettings()->get('mysql.dbHost', 'localhost');

    // Create prototype application
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand'),
        [ $basename,
          "--proto=\"{$absOutputDir}\"",
          "--dbName=\"ampersand_{$scriptAtom->getId()}\"",
          "--sqlHost={$sqlHost}",
          "--language=NL"
        ],
        $ee->getLogger()
    );
    $command->execute($workDir);

    // Populate 'protoOk' upon success
    setProp('protoOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);
    $scriptVersionAtom->link($command->getResponse(), 'compileresponse[ScriptVersion*CompileResponse]')->add();
    
    // Create proto and link to scriptAtom
    $foObject = createFileObject(
        $model->getConceptByLabel('FileObject'),
        "{$outputDir}",
        "Launch prototype"
    );
    $scriptAtom->link($foObject, 'proto[Script*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('loadPopInRAP3', function (string $path, Atom $scriptVersionAtom, string $outputDir) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this
    $model = $ee->getApp()->getModel();

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath($ee->getApp()->getSettings()->get('global.absolutePath')) . "/" . $outputDir;

    // Create RAP3 population
    $command = new Command(
        $ee->getApp()->getSettings()->get('rap3.ampersand', 'ampersand'),
        [ $basename,
          "--proto=\"{$absOutputDir}\"",
          "--language=NL",
          "--gen-as-rap-model"
        ],
        $ee->getLogger()
    );
    $command->execute($workDir);

    // Populate 'loadedInRAP3Ok' upon success
    setProp('loadedInRAP3Ok[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $command->getExitcode() == 0);
    $scriptVersionAtom->link($command->getResponse(), 'compileresponse[ScriptVersion*CompileResponse]')->add();
    
    if ($command->getExitcode() == 0) {
        // Open and decode generated metaPopulation.json file
        $pop = file_get_contents("{$absOutputDir}/generics/metaPopulation.json");
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
                $link = new Link(
                    $relation,
                    getRAPAtom($pair['src'], $relation->srcConcept),
                    getRAPAtom($pair['tgt'], $relation->tgtConcept)
                );
                $link->add();
            }
        }
    }
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
 * @param \Ampersand\Core\Concept $cpt
 * @param string $relPath
 * @param string $displayName
 * @return \Ampersand\Core\Atom
 */
function createFileObject(Concept $cpt, string $relPath, string $displayName): Atom
{
    $foAtom = $cpt->createNewAtom();
    $foAtom->link($relPath, 'filePath[FileObject*FilePath]')->add();
    $foAtom->link($displayName, 'originalFileName[FileObject*FileName]')->add();
    
    return $foAtom;
}
