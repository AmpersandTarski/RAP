<?php

use Ampersand\Log\Logger;
use Ampersand\Config;
use Ampersand\Core\Relation;
use Ampersand\Core\Atom;
use Ampersand\Core\Concept;
use Ampersand\Session;
use Ampersand\Database\Database;

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

function PerformanceTest($scriptAtomId,$studentNumber){
    $db = Database::singleton();
    $logger = Logger::getLogger('CLI');
    $total = 5;
    
    for($i = 0; $i < $total;$i++){
        $logger->debug("Compiling {$i}/{$total}: start");
        
        $GLOBALS['RapAtoms']=[];
        set_time_limit (600);

        $scriptVersionInfo = CompileToNewVersion($scriptAtomId,$studentNumber);
        if($scriptVersionInfo === false){
            $logger->error("Error while compiling new script version");
            die;
        }
        
        CompileWithAmpersand('loadPopInRAP3', $scriptVersionInfo['id'], $scriptVersionInfo['relpath']);
        
        $logger->debug("Compiling {$i}/{$total}: end");
        
        $db->closeTransaction("PerformanceRun {$i} ok", true); // also kicks EXECENGINE
    }
}

function CompileToNewVersion($scriptAtomId,$studentNumber){
    Logger::getLogger('EXECENGINE')->info("CompileToNewVersion({$scriptAtomId},$studentNumber)");
    
    $scriptConcept = Concept::getConceptByLabel("Script");
    $scriptVersion = Concept::getConceptByLabel("ScriptVersion");
    $scriptAtom = new Atom($scriptAtomId,$scriptConcept);

    // The relative path of the source file must be something like:
    //   scripts/<studentNumber>/sources/<scriptId>/Version<timestamp>.adl
    //   This is decomposed elsewhere in cli.php, based on this assumption.
    // Now we will construct the relative path
    $versionId = date('Y-m-d\THis');
    $fileName = "Version{$versionId}.adl";
    $relPathSources = "scripts/{$studentNumber}/sources/{$scriptAtom->id}/{$fileName}";
    
    //construct the path for the relation basePath[ScriptVersion*FilePath]
    $relPathGenerated = "scripts/{$studentNumber}/generated/{$scriptAtom->id}/Version{$versionId}/fSpec/";

    $absPath = realpath(Config::get('absolutePath')) . "/" . $relPathSources;
    
    // Script content ophalen en schrijven naar bestandje
    $tgts = $scriptAtom->ifc('ScriptContent')->getTgtAtoms();
    if(empty($tgts)) throw new Exception ("No script content provided",500);
    $scriptContent = current($tgts)->id;
    if(!file_exists (dirname ($absPath))) mkdir(dirname ($absPath), 0777, true);
    file_put_contents ($absPath, $scriptContent);

    // Compile the file, only to check for errors.
    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $cmd = $exefile . " " . basename($absPath);
    Execute($cmd, $response, $exitcode, dirname ($absPath));
    saveCompileResponse($scriptAtom, $response);
    
    if($exitcode == 0){ // script ok
        // Create new script version atom and add to rel version[Script*ScriptVersion]
        $version = $scriptVersion->createNewAtom();
        Relation::getRelation('version[Script*ScriptVersion]')->addLink($scriptAtom, $version, false, 'COMPILEENGINE');
        setProp('scriptOk', $version, true);
        
        $sourceFO = createFileObject($relPathSources, $fileName);
        Relation::getRelation('source[ScriptVersion*FileObject]')->addLink($version, $sourceFO, false, 'COMPILEENGINE');
        
        // create basePath, indicating the relative path to the context stuff of this scriptversion. (Needed for graphics)
        Relation::getRelation('basePath[ScriptVersion*FilePath]')->addLink($version, new Atom($relPathGenerated, Concept::getConceptByLabel('FilePath')));
        
        return ['id' => $version->id, 'relpath' => $relPathSources];
        
    }else{ // script not ok
        return false;
    }
}

function CompileWithAmpersand($action, $script, $scriptVersion, $relSourcePath){

    $scriptConcept = Concept::getConceptByLabel("Script");
    $scriptAtom = new Atom($script, $scriptConcept);

    $scriptVersionConcept = Concept::getConceptByLabel("ScriptVersion");
    $scriptVersionAtom = new Atom($scriptVersion, $scriptVersionConcept);

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
    $absDir = realpath(Config::get('absolutePath')) . "/" . $relDir;
    
    
    
    // Script bestand voeren aan Ampersand compiler
    switch($action){
        case 'diagnosis':
            Diagnosis($relSourcePath, $scriptVersionAtom, $relDir.'/diagnosis');
            break;
        case 'loadPopInRAP3' : 
            loadPopInRAP3($relSourcePath, $scriptVersionAtom, $relDir.'/atlas'); 
            break;
        case 'fspec' : 
            FuncSpec($relSourcePath, $scriptVersionAtom, $relDir.'/fSpec');
            break;
        case 'prototype' : 
            Prototype($relSourcePath, $scriptAtom, $scriptVersionAtom, $relDir.'/../prototype'); 
            break;
        default :
            Logger::getLogger('EXECENGINE')->error("Unknown action ({$action}) specified");
            break;
    }
}

function FuncSpec($path, $scriptVersionAtom, $outputDir){
    
    $filename  = pathinfo($path, PATHINFO_FILENAME );
    $basename  = pathinfo($path, PATHINFO_BASENAME );
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME  );
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} -fl --language=NL --outputDir=\"{$absOutputDir}\" ";
    $cmd = is_null(Config::get('FuncSpecCmd', 'RAP3')) ? $default : Config::get('FuncSpecCmd', 'RAP3');

    // Execute cmd, and populate 'funcSpecOk' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('funcSpecOk', $scriptVersionAtom, $exitCode == 0);
    saveCompileResponse($scriptVersionAtom, $response);

    // Create fSpec and link to scriptVersionAtom
    $foObject = createFileObject("{$outputDir}/{$filename}.pdf", 'Functional specification');
    Relation::getRelation('funcSpec[ScriptVersion*FileObject]')->addLink($scriptVersionAtom, $foObject, false, 'COMPILEENGINE');
    
}

function Diagnosis($path, $scriptVersionAtom, $outputDir){

    $filename  = pathinfo($path, PATHINFO_FILENAME );
    $basename  = pathinfo($path, PATHINFO_BASENAME );
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME  );
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} -fl --diagnosis --language=NL --outputDir=\"{$absOutputDir}\" ";
    $cmd = is_null(Config::get('DiagCmd', 'RAP3')) ? $default : Config::get('DiagCmd', 'RAP3');

    // Execute cmd, and populate 'diagOk' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('diagOk', $scriptVersionAtom, $exitCode == 0);
    saveCompileResponse($scriptVersionAtom, $response);
    
    // Create diagnose and link to scriptVersionAtom
    $foObject = createFileObject("{$outputDir}/{$filename}.pdf", 'Diagnosis');
    Relation::getRelation('diag[ScriptVersion*FileObject]')->addLink($scriptVersionAtom, $foObject, false, 'COMPILEENGINE');
    
}

function Prototype($path, $scriptAtom, $scriptVersionAtom, $outputDir){

    $filename  = pathinfo($path, PATHINFO_FILENAME );
    $basename  = pathinfo($path, PATHINFO_BASENAME );
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME  );
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;
    $sqlHost = is_null(Config::get('dbHost', 'mysqlDatabase')) ? "localhost" : Config::get('dbHost', 'mysqlDatabase');

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} --proto=\"{$absOutputDir}\" --dbName=\"ampersand_{$scriptAtom->id}\" --sqlHost={$sqlHost} --language=NL ";
    $cmd = is_null(Config::get('ProtoCmd', 'RAP3')) ? $default : Config::get('ProtoCmd', 'RAP3');

    // Execute cmd, and populate 'protoOk' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('protoOk', $scriptVersionAtom, $exitCode == 0);
    saveCompileResponse($scriptVersionAtom, $response);
    
    // Create proto and link to scriptAtom
    $foObject = createFileObject("{$outputDir}", 'Launch prototype');
    Relation::getRelation('proto[Script*FileObject]')->addLink($scriptAtom, $foObject, false, 'COMPILEENGINE');
}

function loadPopInRAP3($path, $scriptVersionAtom, $outputDir){
    $session = Session::singleton();

    $filename  = pathinfo($path, PATHINFO_FILENAME );
    $basename  = pathinfo($path, PATHINFO_BASENAME );
    $workDir   = realpath(Config::get('absolutePath')) . "/" . pathinfo($path, PATHINFO_DIRNAME  );
    $absOutputDir = realpath(Config::get('absolutePath')) . "/" . $outputDir;

    $exefile = is_null(Config::get('ampersand', 'RAP3')) ? "ampersand" : Config::get('ampersand', 'RAP3');
    $default = $exefile . " {$basename} --proto=\"{$absOutputDir}\" --language=NL --gen-as-rap-model";
    $cmd = is_null(Config::get('LoadInRap3Cmd', 'RAP3')) ? $default : Config::get('LoadInRap3Cmd', 'RAP3');

    // Execute cmd, and populate 'loadedInRAP3Ok' upon success
    Execute($cmd, $response, $exitcode, $workDir);
    setProp('loadedInRAP3Ok', $scriptVersionAtom, $exitCode == 0);
    saveCompileResponse($scriptVersionAtom, $response);
    
    if ($exitcode == 0) {
        $cpt_Concept = Concept::getConceptByLabel('Context');
        $relContextScriptV = Relation::getRelation('context', $scriptVersionAtom->concept, $cpt_Concept);
        // Open and decode generated metaPopulation.json file
        $pop = file_get_contents("{$absOutputDir}/generics/metaPopulation.json");
        $pop = json_decode($pop, true);
    
        // Add atoms to database    
        foreach($pop['atoms'] as $atomPop){
            $concept = Concept::getConceptByLabel($atomPop['concept']);
            foreach($atomPop['atoms'] as $atomId){
                $a = getRAPAtom($atomId, $concept);
                $a->addAtom(); // Add to database
                if($concept == $cpt_Concept) $relContextScriptV->addLink($scriptVersionAtom, $a);
            }
        }
    
        // Add links to database
        foreach($pop['links'] as $linkPop){
            $relation = Relation::getRelation($linkPop['relation']);
            foreach($linkPop['links'] as $link){
                $src = getRAPAtom($link['src'], $relation->srcConcept);
                $tgt = getRAPAtom($link['tgt'], $relation->tgtConcept);
                $relation->addLink($src, $tgt); // Add link to database
            }
        }
    }        
}

function Cleanup($atomId, $cptId){
    static $skipRelations = ['context[ScriptVersion*Context]'];
    $logger = Logger::getLogger('RAP3_CLEANUP');
    $logger->debug("Cleanup called for {$atomId}[{$cptId}]");
    
    $concept = Concept::getConceptByLabel($cptId);
    
    // Don't cleanup atoms with REPRESENT type
    if(!$concept->isObject){
       $logger->debug("'{$concept->name}' is not an object, so it will not be cleaned up.");
       return;
    };
    $atom = new Atom($atomId,$concept);
    
    // Skip cleanup if atom does not exists (anymore)
    if(!$atom->atomExists()){
       $logger->debug("'{$atom->id}' does not exist any longer.");
       return;
    };
    // Walk all relations
    $allrelations = Relation::getAllRelations();
    $logger->debug("found " . count($allrelations) . " relations.");
    foreach(Relation::getAllRelations() as $rel){
        if(in_array($rel->signature, $skipRelations)) continue; // Skip relations that are explicitly excluded
        
        // If cleanup-concept is in same typology as relation src concept
        if($rel->srcConcept->inSameClassificationTree($concept)){ 
            $logger->debug("Inspecting relation {$rel->signature} (current atom is src)");
            $allLinks = $rel->getAllLinks();
            $logger->debug("found " . count($allLinks) . " links in this relation:");
            foreach($rel->getAllLinks() as $link){
                
                if($link['src'] == $atom->id){
                    // Delete link
                    $rel->deleteLink(new Atom($atom->id,$rel->srcConcept), new Atom($link['tgt'], $rel->tgtConcept));
                    
                    // tgt atom in cleanup set
                    $logger->debug("To be cleaned up later: {$link['tgt']}[{$rel->tgtConcept->name}]");
                    $cleanup[$rel->tgtConcept->name][] = $link['tgt'];
                }
            }
        }
        
        // If cleanup-concept is in same typology as relation tgt concept
        if($rel->tgtConcept->inSameClassificationTree($concept)){
            $logger->debug("Inspecting relation {$rel->signature} (current atom is trg)");
            foreach($rel->getAllLinks() as $link){
                
                if($link['tgt'] == $atom->id){
                    // Delete link
                    $rel->deleteLink(new Atom($link['src'], $rel->srcConcept), new Atom($atom->id,$rel->tgtConcept));
                    
                    // tgt atom in cleanup set
                    $logger->debug("To be cleaned up later: {$link['src']}[{$rel->srcConcept->name}]");
                    $cleanup[$rel->srcConcept->name][] = $link['src'];
                }
            }
        }
    }
    
    // Delete atom
    $atom->deleteAtom();
    
    // Cleanup filter double values
    $logger->debug("cleanup is now: {$cleanup} ");
    foreach($cleanup as $cpt => &$list) $list = array_unique($list);
    
    // Call Cleanup recursive
    foreach($cleanup as $cpt => $list)
        foreach ($list as $atomId) Cleanup($atomId, $cpt);
    
}

function getRAPAtom($atomId, $concept){
    if (!isset($GLOBALS['RapAtoms'])) $GLOBALS['RapAtoms']=[];

    switch($concept->isObject){
        case true : // non-scalar atoms get a new unique identifier
            // Caching of atom identifier is done by its largest concept
            $largestC = $concept->getLargestConcept(); 
            
            // If atom is already changed earlier, use new id from cache
            if(isset($GLOBALS['RapAtoms'][$largestC->name]) && array_key_exists($atomId, $GLOBALS['RapAtoms'][$largestC->name])){
                $atom = new Atom($GLOBALS['RapAtoms'][$largestC->name][$atomId], $concept); // Atom itself is instantiated with $concept (!not $largestC)
            
            // Else create new id and store in cache
            }else{
                $atom = $concept->createNewAtom(); // Create new atom (with generated id)
                // TODO: Guarantee that we have a new id. (Issue #528) (for now, the next logger statement seems to take enough time, which is great as workaround.)
                Logger::getLogger('COMPILEENGINE')->debug("concept:'{$concept->name}' --> atomId: '{$atomId}': {$atom->id}");
                $GLOBALS['RapAtoms'][$largestC->name][$atomId] = $atom->id; // Cache pair of old and new atom identifier
            }
            break;
        
        default : // All other atoms are left untouched
            $atom = new Atom($atomId, $concept);
            break;
    }
        
    return $atom;
}

/**
 * @param string $cmd command that needs to be executed
 * @param string &$response reference to textual output of executed command
 * @param int &$exitcode reference to exitcode of executed command

 */
function Execute($cmd, &$response, &$exitcode, $workingDir=null){

    Logger::getLogger('COMPILEENGINE')->debug("cmd:'{$cmd}'");
    Logger::getLogger('COMPILEENGINE')->debug("workingDir:'{$workingDir}'");
    $output = array();
    if (isset($workingDir)) chdir($workingDir);
    exec($cmd, $output, $exitcode);
    if($exitcode==1) throw new Exception ("Error occurred while attempting to execute `{$cmd}`. Exitcode={$exitcode}",500);
  
    // format execution output
    $response = implode("\n",$output);
    Logger::getLogger('COMPILEENGINE')->debug("exitcode:'{$exitcode}' response:'{$response}'");
    
}

/**
 * @param string $proprelname name of ampersand property relation that must be (de)populated upon success/failure
 * @param Atom $atom ampersand atom used for populating
 */
function setProp($proprelname, $atom, $bool){
    // Set property '$proprelname[Script*Script] [PROP]' depending on $bool
    $proprel = Relation::getRelation($proprelname, $atom->concept, $atom->concept);
    $proprel->addLink($atom, $atom, false, 'COMPILEENGINE');
    // Before deleteLink always addLink (otherwise Exception will be thrown when link does not exist)
    if(!$bool) $proprel->deleteLink($atom, $atom, false,'COMPILEENGINE');
}

function createFileObject($relPath, $displayName){
    $foAtom = Concept::getConceptByLabel('FileObject')->createNewAtom();
    $cptFilePath = Concept::getConceptByLabel('FilePath');
    $cptFileName = Concept::getConceptByLabel('FileName');
    
    Relation::getRelation('filePath[FileObject*FilePath]')->addLink($foAtom, new Atom($relPath, $cptFilePath));
    Relation::getRelation('originalFileName[FileObject*FileName]')->addLink($foAtom, new Atom($displayName, $cptFileName));
    
    return $foAtom;
}

// saving the response in  RELATION compileresponse[ScriptVersion*CompileResponse] [UNI]
function saveCompileResponse($atom, $compileResponse){
    $cptCompileResponse = Concept::getConceptByLabel("CompileResponse");
    $responseAtom = new Atom($compileResponse, $cptCompileResponse);
    
    $relCompileResponse = Relation::getRelation('compileresponse', $atom->concept, $cptCompileResponse)->addLink($atom, $responseAtom, false, 'COMPILEENGINE');
}

?>
