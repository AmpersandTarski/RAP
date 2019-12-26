<?php

namespace RAP3;

use Exception;
use Ampersand\Misc\Config;
use Ampersand\Core\Relation;
use Ampersand\Core\Atom;
use Ampersand\Core\Concept;
use Ampersand\Transaction;
use Ampersand\Rule\ExecEngine;
use Ampersand\Core\Link;

/* Ampersand commando's mogen niet in dit bestand worden aangepast.
De manier om je eigen commando's te regelen is door onderstaande regels naar jouw localSettings.php te copieren en te veranderen
Nu kan dat nog niet, omdat zulke strings niet de paden e.d. kunnen doorgeven.
   Config::set('FuncSpecCmd', 'RAP3', 'value');
   Config::set('DiagCmd', 'RAP3', 'value');
   Config::set('ProtoCmd', 'RAP3', 'value');
   Config::set('LoadInRap3Cmd', 'RAP3', 'value');
Verder moet in localSettings.php ook worden verteld waar ampersand zelf staat.
E.e.a. staat onder het kopje

// Required Ampersand script
/*
RELATION loadedInRAP3[Script*Script] [PROP]
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
        
        $GLOBALS['rapAtoms'] = [];
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
    
    $this->info("CompileToNewVersion({$scriptAtomId},$studentNumber)");
    
    $scriptAtom = Atom::makeAtom($scriptAtomId, 'Script');

    // The relative path of the source file must be something like:
    //   scripts/<studentNumber>/sources/<scriptId>/Version<timestamp>.adl
    //   This is decomposed elsewhere in cli.php, based on this assumption.
    // Now we will construct the relative path
    $versionId = date('Y-m-d\THis');
    $fileName = "Version{$versionId}.adl";
    $relPathSources = "scripts/{$studentNumber}/sources/{$scriptAtom->id}/{$fileName}";
    $absPath = realpath(Config::get('absolutePath')) . "/" . $relPathSources;
    
    //construct the path for the relation basePath[ScriptVersion*FilePath]
    $relPathGenerated = "scripts/{$studentNumber}/generated/{$scriptAtom->id}/Version{$versionId}/fSpec/";
    
    // Script content ophalen en schrijven naar bestandje
    $links = $scriptAtom->getLinks('content[Script*ScriptContent]');
    if (empty($links)) {
        throw new Exception("No script content provided", 500);
    }
    if (!file_exists(dirname($absPath))) {
        mkdir(dirname($absPath), 0777, true);
    }
    file_put_contents($absPath, current($links)->tgt()->id);

    // Compile the file, only to check for errors.
    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    Execute($exefile . " " . basename($absPath), $response, $exitcode, dirname($absPath));
    $scriptAtom->link($response, 'compileresponse[Script*CompileResponse]')->add();
    
    if ($exitcode == 0) { // script ok
        // Create new script version atom and add to rel version[Script*ScriptVersion]
        $version = Atom::makeNewAtom('ScriptVersion');
        $scriptAtom->link($version, 'version[Script*ScriptVersion]')->add();
        $version->link($version, 'scriptOk[ScriptVersion*ScriptVersion]')->add();
        
        $sourceFO = createFileObject($relPathSources, $fileName);
        $version->link($sourceFO, 'source[ScriptVersion*FileObject]')->add();
        
        // create basePath, indicating the relative path to the context stuff of this scriptversion. (Needed for graphics)
        $version->link($relPathGenerated, 'basePath[ScriptVersion*FilePath]')->add();
        
        return ['id' => $version->id, 'relpath' => $relPathSources];
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

    $scriptAtom = Atom::makeAtom($scriptId, 'Script');
    $scriptVersionAtom = Atom::makeAtom($scriptVersionId, 'ScriptVersion');

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
    $absDir        = realpath(Config::get('absolutePath')) . "/" . $relDir;
    
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

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} -fpdf --language=NL --outputDir=\"{$absOutputDir}\" ";
    $cmd = is_null(Config::get('FuncSpecCmd', 'RAP3')) ? $default : Config::get('FuncSpecCmd', 'RAP3');

    // Execute cmd, and populate 'funcSpecOk' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('funcSpecOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $exitcode == 0);
    $scriptVersionAtom->link($response, 'compileresponse[ScriptVersion*CompileResponse]')->add();

    // Create fSpec and link to scriptVersionAtom
    $foObject = createFileObject("{$outputDir}/{$filename}.pdf", 'Functional specification');
    $scriptVersionAtom->link($foObject, 'funcSpec[ScriptVersion*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('Diagnosis', function (string $path, Atom $scriptVersionAtom, string $outputDir) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} -fpdf --diagnosis --language=NL --outputDir=\"{$absOutputDir}\" ";
    $cmd = is_null(Config::get('DiagCmd', 'RAP3')) ? $default : Config::get('DiagCmd', 'RAP3');

    // Execute cmd, and populate 'diagOk' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('diagOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $exitcode == 0);
    $scriptVersionAtom->link($response, 'compileresponse[ScriptVersion*CompileResponse]')->add();
    
    // Create diagnose and link to scriptVersionAtom
    $foObject = createFileObject("{$outputDir}/{$filename}.pdf", 'Diagnosis');
    $scriptVersionAtom->link($foObject, 'diag[ScriptVersion*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('Prototype', function (string $path, Atom $scriptAtom, Atom $scriptVersionAtom, string $outputDir) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;
    $sqlHost = is_null(Config::get('dbHost', 'mysqlDatabase')) ? "localhost" : Config::get('dbHost', 'mysqlDatabase');

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} --proto=\"{$absOutputDir}\" --dbName=\"ampersand_{$scriptAtom->id}\" --sqlHost={$sqlHost} --language=NL ";
    $cmd = is_null(Config::get('ProtoCmd', 'RAP3')) ? $default : Config::get('ProtoCmd', 'RAP3');

    // Execute cmd, and populate 'protoOk' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('protoOk[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $exitcode == 0);
    $scriptVersionAtom->link($response, 'compileresponse[ScriptVersion*CompileResponse]')->add();
    
    // Create proto and link to scriptAtom
    $foObject = createFileObject("{$outputDir}", 'Launch prototype');
    $scriptAtom->link($foObject, 'proto[Script*FileObject]')->add();
});

/**
 * @phan-closure-scope \Ampersand\Rule\ExecEngine
 * Phan analyzes the inner body of this closure as if it were a closure declared in ExecEngine.
 */
ExecEngine::registerFunction('loadPopInRAP3', function (string $path, Atom $scriptVersionAtom, string $outputDir) {
    /** @var \Ampersand\Rule\ExecEngine $ee */
    $ee = $this; // because autocomplete does not work on $this

    $filename  = pathinfo($path, PATHINFO_FILENAME);
    $basename  = pathinfo($path, PATHINFO_BASENAME);
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME);
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} --proto=\"{$absOutputDir}\" --language=NL --gen-as-rap-model";
    $cmd = is_null(Config::get('LoadInRap3Cmd', 'RAP3')) ? $default : Config::get('LoadInRap3Cmd', 'RAP3');

    // Execute cmd, and populate 'loadedInRAP3Ok' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('loadedInRAP3Ok[ScriptVersion*ScriptVersion]', $scriptVersionAtom, $exitcode == 0);
    $scriptVersionAtom->link($response, 'compileresponse[ScriptVersion*CompileResponse]')->add();
    
    if ($exitcode == 0) {
        // Open and decode generated metaPopulation.json file
        $pop = file_get_contents("{$absOutputDir}/generics/metaPopulation.json");
        $pop = json_decode($pop, true);
    
        // Add atoms to database
        foreach ($pop['atoms'] as $atomPop) {
            $concept = Concept::getConcept($atomPop['concept']);
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
            $relation = Relation::getRelation($linkPop['relation']);
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

    $atom = Atom::makeAtom($atomId, $cptId);
    deleteAtomAndLinks($atom);
});

function deleteAtomAndLinks(Atom $atom)
{
    static $skipRelations = ['context[ScriptVersion*Context]'];
    $logger; // TODO: use logger of exec-engine

    $logger->debug("Cleanup called for '{$atom}'");
    
    // Don't cleanup atoms with REPRESENT type
    if (!$atom->concept->isObject()) {
        $logger->debug("Skip cleanup: concept '{$atom->concept}' is not an object");
        return;
    };
    
    // Skip cleanup if atom does not exists (anymore)
    if (!$atom->exists()) {
        $logger->debug("Skip cleanup: atom '{$atom}' does not exist (anymore)");
        return;
    };

    // List for additional atoms that must be removed
    $cleanup = [];
    
    // Walk all relations
    foreach (Relation::getAllRelations() as $rel) {
        if (in_array($rel->signature, $skipRelations)) {
            continue; // Skip relations that are explicitly excluded
        }
        
        // If cleanup-concept is in same typology as relation src concept
        if ($atom->concept->inSameClassificationTree($rel->srcConcept)) {
            foreach ($atom->getLinks($rel) as $link) {
                // Tgt atom in cleanup set
                $logger->debug("Also cleanup atom: {$link->tgt()}");
                $cleanup[] = $link->tgt();
            }
            $rel->deleteAllLinks($atom, 'src');
        }
        
        // If cleanup-concept is in same typology as relation tgt concept
        if ($atom->concept->inSameClassificationTree($rel->tgtConcept)) {
            foreach ($atom->getLinks($rel, true) as $link) {
                // Tgt atom in cleanup set
                $logger->debug("Also cleanup atom: {$link->src()}");
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
    array_map('deleteAtomAndLinks', $cleanup);
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
    // Instantiate an array only the first time the function is
    if (!isset($GLOBALS['rapAtoms'])) {
        $GLOBALS['rapAtoms'] = [];
    }

    // Non-scalar atoms get a new unique identifier
    if ($concept->isObject()) {
        // Caching of atom identifier is done by its largest concept
        $largestC = $concept->getLargestConcept()->getId();
        
        // If atom is already changed earlier, use new id from cache
        if (isset($GLOBALS['rapAtoms'][$largestC]) && array_key_exists($atomId, $GLOBALS['rapAtoms'][$largestC])) {
            return Atom::makeAtom($GLOBALS['rapAtoms'][$largestC][$atomId], $concept->getId()); // Atom itself is instantiated with $concept (!not $largestC)
        
        // Else create new id and store in cache
        } else {
            $atom = $concept->createNewAtom(); // Create new atom (with generated id)
            $GLOBALS['rapAtoms'][$largestC][$atomId] = $atom->id; // Cache pair of old and new atom identifier
            return $atom;
        }
    } else {
        return new Atom($atomId, $concept);
    }
}

/**
 * Undocumented function
 *
 * @param string $cmd command that needs to be executed
 * @param string &$response reference to textual output of executed command
 * @param int &$exitcode reference to exitcode of executed command
 * @param string|null $workingDir
 * @return void
 */
function Execute($cmd, &$response, &$exitcode, $workingDir = null)
{
    $logger; // TODO: use logger of exec-engine
    $logger->debug("cmd:'{$cmd}' (workingDir:'{$workingDir}')");
    
    $output = [];
    if (isset($workingDir)) {
        chdir($workingDir);
    }

    $cmd .= ' 2>&1'; // appends STDERR to STDOUT, which is then available in $output below.
    exec($cmd, $output, $exitcode);
  
    // format execution output
    $response = implode("\n", $output);
    $logger->debug("exitcode:'{$exitcode}' response:'{$response}'");
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
 * @param string $relPath
 * @param string $displayName
 * @return \Ampersand\Core\Atom
 */
function createFileObject(string $relPath, string $displayName): Atom
{
    $foAtom = Atom::makeNewAtom('FileObject');
    $foAtom->link($relPath, 'filePath[FileObject*FilePath]')->add();
    $foAtom->link($displayName, 'originalFileName[FileObject*FileName]')->add();
    
    return $foAtom;
}
