SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `ampersand_rap3` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `ampersand_rap3`;

DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
  `Account` varchar(255) COLLATE utf8_bin NOT NULL,
  `accStudNr` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accEmail` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accNewPassword` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accUserid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accPassword` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accIsInitialized` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accIsActive` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accDeactivateReq` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accPerson` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Actor`;
CREATE TABLE `Actor` (
  `Actor` varchar(255) COLLATE utf8_bin NOT NULL,
  `Person` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `personMiddle` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `personFirstName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `personLastName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `AmpersandVersion`;
CREATE TABLE `AmpersandVersion` (
  `AmpersandVersion` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Assignment`;
CREATE TABLE `Assignment` (
  `Assignment` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `AtomValue`;
CREATE TABLE `AtomValue` (
  `AtomValue` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `CompileResponse`;
CREATE TABLE `CompileResponse` (
  `CompileResponse` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Concept`;
CREATE TABLE `Concept` (
  `Concept` varchar(255) COLLATE utf8_bin NOT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `conceptualDiagram` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `urlEncodedName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ttype` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `ConceptName`;
CREATE TABLE `ConceptName` (
  `ConceptName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Context`;
CREATE TABLE `Context` (
  `Context` varchar(255) COLLATE utf8_bin NOT NULL,
  `requestDestroy` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `conceptualDiagram` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `language` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `versionInfo` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `ContextName`;
CREATE TABLE `ContextName` (
  `ContextName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `DateTime`;
CREATE TABLE `DateTime` (
  `DateTime` datetime NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Emailaddress`;
CREATE TABLE `Emailaddress` (
  `Emailaddress` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `EncodedName`;
CREATE TABLE `EncodedName` (
  `EncodedName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Expression`;
CREATE TABLE `Expression` (
  `Expression` varchar(255) COLLATE utf8_bin NOT NULL,
  `UnaryTerm` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `BinaryTerm` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Converse` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `KleeneStar` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `KleenePlus` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `UnaryMinus` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `V` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `I` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Equivalence` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Inclusion` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Singleton` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `BindedRelation` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Intersection` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Union` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `BinaryMinus` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Composition` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CartesianProduct` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `RelationalAddition` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `LeftResidual` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `RightResidual` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `src` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `tgt` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `bind` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `first` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `second` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `operator` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `arg` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `operator_1` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `singleton_1` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `userSrc` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `userTrg` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `userCpt` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `showADL` text COLLATE utf8_bin,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `FileName`;
CREATE TABLE `FileName` (
  `FileName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `FileObject`;
CREATE TABLE `FileObject` (
  `FileObject` varchar(255) COLLATE utf8_bin NOT NULL,
  `filePath` text COLLATE utf8_bin,
  `originalFileName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `FilePath`;
CREATE TABLE `FilePath` (
  `FilePath` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `FirstName`;
CREATE TABLE `FirstName` (
  `FirstName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Identity`;
CREATE TABLE `Identity` (
  `Identity` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Interface`;
CREATE TABLE `Interface` (
  `Interface` varchar(255) COLLATE utf8_bin NOT NULL,
  `interfaces` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `IsE`;
CREATE TABLE `IsE` (
  `IsE` varchar(255) COLLATE utf8_bin NOT NULL,
  `genspc` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Isa2`;
CREATE TABLE `Isa2` (
  `Isa` varchar(255) COLLATE utf8_bin NOT NULL,
  `gens` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `gengen` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `genspc` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Item`;
CREATE TABLE `Item` (
  `Item` varchar(255) COLLATE utf8_bin NOT NULL,
  `ScriptVersion` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `scriptOk` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `funcSpecRequest` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `funcSpecOk` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `funcSpec` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `diagRequest` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `diagOk` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `diag` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `loadRequest` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `loadedInRAP3Ok` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `protoRequest` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `protoOk` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `basePath` text COLLATE utf8_bin,
  `compileresponse` text COLLATE utf8_bin,
  `itemName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `itemInSeq` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `nextItem` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `ItemName`;
CREATE TABLE `ItemName` (
  `ItemName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Language`;
CREATE TABLE `Language` (
  `Language` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `LastName`;
CREATE TABLE `LastName` (
  `LastName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `LoginMessage`;
CREATE TABLE `LoginMessage` (
  `LoginMessage` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `MarkupText`;
CREATE TABLE `MarkupText` (
  `MarkupText` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Meaning2`;
CREATE TABLE `Meaning2` (
  `Meaning` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Message2`;
CREATE TABLE `Message2` (
  `Message` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Middlepart`;
CREATE TABLE `Middlepart` (
  `Middlepart` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `ONE`;
CREATE TABLE `ONE` (
  `ONE` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Operator`;
CREATE TABLE `Operator` (
  `Operator` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Organization`;
CREATE TABLE `Organization` (
  `Organization` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Origin`;
CREATE TABLE `Origin` (
  `Origin` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Pair`;
CREATE TABLE `Pair` (
  `Pair` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Password`;
CREATE TABLE `Password` (
  `Password` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Pattern`;
CREATE TABLE `Pattern` (
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `context` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `conceptualDiagram` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `urlEncodedName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `PatternName`;
CREATE TABLE `PatternName` (
  `PatternName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Population`;
CREATE TABLE `Population` (
  `Population` text COLLATE utf8_bin NOT NULL,
  `context` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Property`;
CREATE TABLE `Property` (
  `Property` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Purpose4`;
CREATE TABLE `Purpose4` (
  `Purpose` text COLLATE utf8_bin NOT NULL,
  `purpose_1` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `purpose_2` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `purpose_3` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `purpose_4` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `purpose_5` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `markupText` text COLLATE utf8_bin,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Relation`;
CREATE TABLE `Relation` (
  `Relation` varchar(255) COLLATE utf8_bin NOT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `target` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ctxds` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `declaredIn` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `decmean` text COLLATE utf8_bin,
  `sign` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `decprL` text COLLATE utf8_bin,
  `decprM` text COLLATE utf8_bin,
  `decprR` text COLLATE utf8_bin,
  `context` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `RelationName`;
CREATE TABLE `RelationName` (
  `RelationName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Role`;
CREATE TABLE `Role` (
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `RoleName`;
CREATE TABLE `RoleName` (
  `RoleName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Rule`;
CREATE TABLE `Rule` (
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `PropertyRule` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ctxrs` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `udefrules` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `multrules` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `identityRules` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `allRules` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `formalExpression` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `conceptualDiagram` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `urlEncodedName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `sign` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `origin` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `srcConcept` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `tgtConcept` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `RuleName`;
CREATE TABLE `RuleName` (
  `RuleName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `SESSION`;
CREATE TABLE `SESSION` (
  `SESSION` varchar(255) COLLATE utf8_bin NOT NULL,
  `regStudentnummer` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `regPassword1` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `regPassword2` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `regEmail` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `regCreateAccount` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `sessionAccount` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `sessionUserid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `loginUserid` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `loginPassword` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `logoutRequest` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `sessionPerson` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `ScriptContent`;
CREATE TABLE `ScriptContent` (
  `ScriptContent` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `SeqName`;
CREATE TABLE `SeqName` (
  `SeqName` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Sequence`;
CREATE TABLE `Sequence` (
  `Sequence` varchar(255) COLLATE utf8_bin NOT NULL,
  `Script` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `compileRequest` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `proto` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `submittor` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `assignment` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `submitted` datetime DEFAULT NULL,
  `content` text COLLATE utf8_bin,
  `compileresponse` text COLLATE utf8_bin,
  `seqName` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `seqFirstItem` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `seqLastItem` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `ShowADL`;
CREATE TABLE `ShowADL` (
  `ShowADL` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `Signature`;
CREATE TABLE `Signature` (
  `Signature` varchar(255) COLLATE utf8_bin NOT NULL,
  `src` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `tgt` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `String`;
CREATE TABLE `String` (
  `String` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `TType`;
CREATE TABLE `TType` (
  `TType` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `UserID`;
CREATE TABLE `UserID` (
  `UserID` varchar(255) COLLATE utf8_bin NOT NULL,
  `Studentnummer` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `View`;
CREATE TABLE `View` (
  `View` varchar(255) COLLATE utf8_bin NOT NULL,
  `default` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `__SessionTimeout__`;
CREATE TABLE `__SessionTimeout__` (
  `SESSION` varchar(255) COLLATE utf8_bin NOT NULL,
  `lastAccess` bigint(20) NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `__all_signals__`;
CREATE TABLE `__all_signals__` (
  `conjId` varchar(255) COLLATE utf8_bin NOT NULL,
  `src` varchar(255) COLLATE utf8_bin NOT NULL,
  `tgt` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `accAllowedRoles`;
CREATE TABLE `accAllowedRoles` (
  `Account` varchar(255) COLLATE utf8_bin NOT NULL,
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `accDefaultRoles`;
CREATE TABLE `accDefaultRoles` (
  `Account` varchar(255) COLLATE utf8_bin NOT NULL,
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `allRoles`;
CREATE TABLE `allRoles` (
  `Context` varchar(255) COLLATE utf8_bin NOT NULL,
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `allRules`;
CREATE TABLE `allRules` (
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `concepts`;
CREATE TABLE `concepts` (
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `Concept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `declaredIn`;
CREATE TABLE `declaredIn` (
  `Relation` varchar(255) COLLATE utf8_bin NOT NULL,
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `declaredthrough`;
CREATE TABLE `declaredthrough` (
  `PropertyRule` varchar(255) COLLATE utf8_bin NOT NULL,
  `Property` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `gengen`;
CREATE TABLE `gengen` (
  `IsE` varchar(255) COLLATE utf8_bin NOT NULL,
  `Concept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `hasView`;
CREATE TABLE `hasView` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `identityRules`;
CREATE TABLE `identityRules` (
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `in`;
CREATE TABLE `in` (
  `Pair` varchar(255) COLLATE utf8_bin NOT NULL,
  `Expression` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `interfaces`;
CREATE TABLE `interfaces` (
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `Interface` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isa1`;
CREATE TABLE `isa1` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isaCopy`;
CREATE TABLE `isaCopy` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isaPlus`;
CREATE TABLE `isaPlus` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isaRfx`;
CREATE TABLE `isaRfx` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isaRfxCopy`;
CREATE TABLE `isaRfxCopy` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isaRfxPlus`;
CREATE TABLE `isaRfxPlus` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isaRfxStar`;
CREATE TABLE `isaRfxStar` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `isaStar`;
CREATE TABLE `isaStar` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `maintains`;
CREATE TABLE `maintains` (
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `meaning1`;
CREATE TABLE `meaning1` (
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `Meaning` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `message1`;
CREATE TABLE `message1` (
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `Message` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `multrules`;
CREATE TABLE `multrules` (
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `prop`;
CREATE TABLE `prop` (
  `Relation` varchar(255) COLLATE utf8_bin NOT NULL,
  `Property` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `propertyRule`;
CREATE TABLE `propertyRule` (
  `Relation` varchar(255) COLLATE utf8_bin NOT NULL,
  `PropertyRule` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `purpose1`;
CREATE TABLE `purpose1` (
  `Context` varchar(255) COLLATE utf8_bin NOT NULL,
  `Purpose` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `purpose2`;
CREATE TABLE `purpose2` (
  `View` varchar(255) COLLATE utf8_bin NOT NULL,
  `Purpose` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `purpose3`;
CREATE TABLE `purpose3` (
  `Identity` varchar(255) COLLATE utf8_bin NOT NULL,
  `Purpose` text COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `relsDefdIn`;
CREATE TABLE `relsDefdIn` (
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `Relation` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `sessionActiveRoles`;
CREATE TABLE `sessionActiveRoles` (
  `SESSION` varchar(255) COLLATE utf8_bin NOT NULL,
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `sessionAllowedRoles`;
CREATE TABLE `sessionAllowedRoles` (
  `SESSION` varchar(255) COLLATE utf8_bin NOT NULL,
  `Role` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `source`;
CREATE TABLE `source` (
  `ScriptVersion` varchar(255) COLLATE utf8_bin NOT NULL,
  `FileObject` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `udefrules`;
CREATE TABLE `udefrules` (
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `usedIn`;
CREATE TABLE `usedIn` (
  `Relation` varchar(255) COLLATE utf8_bin NOT NULL,
  `Expression` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `uses`;
CREATE TABLE `uses` (
  `Context` varchar(255) COLLATE utf8_bin NOT NULL,
  `Pattern` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `valid1`;
CREATE TABLE `valid1` (
  `Rule` varchar(255) COLLATE utf8_bin NOT NULL,
  `Context` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `valid2`;
CREATE TABLE `valid2` (
  `Relation` varchar(255) COLLATE utf8_bin NOT NULL,
  `Context` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `valid3`;
CREATE TABLE `valid3` (
  `Concept` varchar(255) COLLATE utf8_bin NOT NULL,
  `Context` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `viewBy`;
CREATE TABLE `viewBy` (
  `SrcConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `TgtConcept` varchar(255) COLLATE utf8_bin NOT NULL,
  `ts_insertupdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;


ALTER TABLE `Account`
  ADD PRIMARY KEY (`Account`),
  ADD UNIQUE KEY `Account` (`Account`),
  ADD KEY `Account_accStudNr` (`accStudNr`),
  ADD KEY `Account_accEmail` (`accEmail`),
  ADD KEY `Account_accUserid` (`accUserid`),
  ADD KEY `Account_accIsInitialized` (`accIsInitialized`),
  ADD KEY `Account_accIsActive` (`accIsActive`),
  ADD KEY `Account_accDeactivateReq` (`accDeactivateReq`),
  ADD KEY `Account_accPerson` (`accPerson`);

ALTER TABLE `Actor`
  ADD PRIMARY KEY (`Actor`),
  ADD UNIQUE KEY `Actor` (`Actor`),
  ADD KEY `Actor_Person` (`Person`),
  ADD KEY `Actor_personMiddle` (`personMiddle`),
  ADD KEY `Actor_personFirstName` (`personFirstName`),
  ADD KEY `Actor_personLastName` (`personLastName`);

ALTER TABLE `AmpersandVersion`
  ADD KEY `AmpersandVersion_AmpersandVersion` (`AmpersandVersion`);

ALTER TABLE `Assignment`
  ADD KEY `Assignment_Assignment` (`Assignment`);

ALTER TABLE `AtomValue`
  ADD KEY `AtomValue_AtomValue` (`AtomValue`);

ALTER TABLE `Concept`
  ADD PRIMARY KEY (`Concept`),
  ADD UNIQUE KEY `Concept` (`Concept`),
  ADD KEY `Concept_name` (`name`),
  ADD KEY `Concept_context` (`context`),
  ADD KEY `Concept_conceptualDiagram` (`conceptualDiagram`),
  ADD KEY `Concept_urlEncodedName` (`urlEncodedName`),
  ADD KEY `Concept_ttype` (`ttype`);

ALTER TABLE `ConceptName`
  ADD KEY `ConceptName_ConceptName` (`ConceptName`);

ALTER TABLE `Context`
  ADD PRIMARY KEY (`Context`),
  ADD UNIQUE KEY `Context` (`Context`),
  ADD KEY `Context_requestDestroy` (`requestDestroy`),
  ADD KEY `Context_name` (`name`),
  ADD KEY `Context_conceptualDiagram` (`conceptualDiagram`),
  ADD KEY `Context_language` (`language`),
  ADD KEY `Context_versionInfo` (`versionInfo`);

ALTER TABLE `ContextName`
  ADD KEY `ContextName_ContextName` (`ContextName`);

ALTER TABLE `DateTime`
  ADD KEY `DateTime_DateTime` (`DateTime`);

ALTER TABLE `Emailaddress`
  ADD KEY `Emailaddress_Emailaddress` (`Emailaddress`);

ALTER TABLE `EncodedName`
  ADD KEY `EncodedName_EncodedName` (`EncodedName`);

ALTER TABLE `Expression`
  ADD PRIMARY KEY (`Expression`),
  ADD UNIQUE KEY `Expression` (`Expression`),
  ADD KEY `Expression_UnaryTerm` (`UnaryTerm`),
  ADD KEY `Expression_BinaryTerm` (`BinaryTerm`),
  ADD KEY `Expression_Converse` (`Converse`),
  ADD KEY `Expression_KleeneStar` (`KleeneStar`),
  ADD KEY `Expression_KleenePlus` (`KleenePlus`),
  ADD KEY `Expression_UnaryMinus` (`UnaryMinus`),
  ADD KEY `Expression_V` (`V`),
  ADD KEY `Expression_I` (`I`),
  ADD KEY `Expression_Equivalence` (`Equivalence`),
  ADD KEY `Expression_Inclusion` (`Inclusion`),
  ADD KEY `Expression_Singleton` (`Singleton`),
  ADD KEY `Expression_BindedRelation` (`BindedRelation`),
  ADD KEY `Expression_Intersection` (`Intersection`),
  ADD KEY `Expression_Union` (`Union`),
  ADD KEY `Expression_BinaryMinus` (`BinaryMinus`),
  ADD KEY `Expression_Composition` (`Composition`),
  ADD KEY `Expression_CartesianProduct` (`CartesianProduct`),
  ADD KEY `Expression_RelationalAddition` (`RelationalAddition`),
  ADD KEY `Expression_LeftResidual` (`LeftResidual`),
  ADD KEY `Expression_RightResidual` (`RightResidual`),
  ADD KEY `Expression_src` (`src`),
  ADD KEY `Expression_tgt` (`tgt`),
  ADD KEY `Expression_bind` (`bind`),
  ADD KEY `Expression_first` (`first`),
  ADD KEY `Expression_second` (`second`),
  ADD KEY `Expression_operator` (`operator`),
  ADD KEY `Expression_arg` (`arg`),
  ADD KEY `Expression_operator_1` (`operator_1`),
  ADD KEY `Expression_singleton_1` (`singleton_1`),
  ADD KEY `Expression_userSrc` (`userSrc`),
  ADD KEY `Expression_userTrg` (`userTrg`),
  ADD KEY `Expression_userCpt` (`userCpt`);

ALTER TABLE `FileName`
  ADD KEY `FileName_FileName` (`FileName`);

ALTER TABLE `FileObject`
  ADD PRIMARY KEY (`FileObject`),
  ADD UNIQUE KEY `FileObject` (`FileObject`),
  ADD KEY `FileObject_originalFileName` (`originalFileName`);

ALTER TABLE `FirstName`
  ADD KEY `FirstName_FirstName` (`FirstName`);

ALTER TABLE `Identity`
  ADD PRIMARY KEY (`Identity`),
  ADD UNIQUE KEY `Identity` (`Identity`);

ALTER TABLE `Interface`
  ADD PRIMARY KEY (`Interface`),
  ADD UNIQUE KEY `Interface` (`Interface`),
  ADD KEY `Interface_interfaces` (`interfaces`);

ALTER TABLE `IsE`
  ADD PRIMARY KEY (`IsE`),
  ADD UNIQUE KEY `IsE` (`IsE`),
  ADD KEY `IsE_genspc` (`genspc`);

ALTER TABLE `Isa2`
  ADD PRIMARY KEY (`Isa`),
  ADD UNIQUE KEY `Isa` (`Isa`),
  ADD KEY `Isa2_gens` (`gens`),
  ADD KEY `Isa2_gengen` (`gengen`),
  ADD KEY `Isa2_genspc` (`genspc`);

ALTER TABLE `Item`
  ADD PRIMARY KEY (`Item`),
  ADD UNIQUE KEY `Item` (`Item`),
  ADD KEY `Item_ScriptVersion` (`ScriptVersion`),
  ADD KEY `Item_scriptOk` (`scriptOk`),
  ADD KEY `Item_funcSpecRequest` (`funcSpecRequest`),
  ADD KEY `Item_funcSpecOk` (`funcSpecOk`),
  ADD KEY `Item_funcSpec` (`funcSpec`),
  ADD KEY `Item_diagRequest` (`diagRequest`),
  ADD KEY `Item_diagOk` (`diagOk`),
  ADD KEY `Item_diag` (`diag`),
  ADD KEY `Item_loadRequest` (`loadRequest`),
  ADD KEY `Item_loadedInRAP3Ok` (`loadedInRAP3Ok`),
  ADD KEY `Item_context` (`context`),
  ADD KEY `Item_protoRequest` (`protoRequest`),
  ADD KEY `Item_protoOk` (`protoOk`),
  ADD KEY `Item_version` (`version`),
  ADD KEY `Item_itemName` (`itemName`),
  ADD KEY `Item_itemInSeq` (`itemInSeq`),
  ADD KEY `Item_nextItem` (`nextItem`);

ALTER TABLE `ItemName`
  ADD KEY `ItemName_ItemName` (`ItemName`);

ALTER TABLE `Language`
  ADD KEY `Language_Language` (`Language`);

ALTER TABLE `LastName`
  ADD KEY `LastName_LastName` (`LastName`);

ALTER TABLE `LoginMessage`
  ADD PRIMARY KEY (`LoginMessage`),
  ADD UNIQUE KEY `LoginMessage` (`LoginMessage`);

ALTER TABLE `Middlepart`
  ADD PRIMARY KEY (`Middlepart`),
  ADD UNIQUE KEY `Middlepart` (`Middlepart`);

ALTER TABLE `ONE`
  ADD PRIMARY KEY (`ONE`),
  ADD UNIQUE KEY `ONE` (`ONE`);

ALTER TABLE `Operator`
  ADD KEY `Operator_Operator` (`Operator`);

ALTER TABLE `Organization`
  ADD PRIMARY KEY (`Organization`),
  ADD UNIQUE KEY `Organization` (`Organization`);

ALTER TABLE `Origin`
  ADD KEY `Origin_Origin` (`Origin`);

ALTER TABLE `Pair`
  ADD PRIMARY KEY (`Pair`),
  ADD UNIQUE KEY `Pair` (`Pair`);

ALTER TABLE `Pattern`
  ADD PRIMARY KEY (`Pattern`),
  ADD UNIQUE KEY `Pattern` (`Pattern`),
  ADD KEY `Pattern_context` (`context`),
  ADD KEY `Pattern_name` (`name`),
  ADD KEY `Pattern_conceptualDiagram` (`conceptualDiagram`),
  ADD KEY `Pattern_urlEncodedName` (`urlEncodedName`);

ALTER TABLE `PatternName`
  ADD KEY `PatternName_PatternName` (`PatternName`);

ALTER TABLE `Population`
  ADD KEY `Population_context` (`context`);

ALTER TABLE `Property`
  ADD KEY `Property_Property` (`Property`);

ALTER TABLE `Purpose4`
  ADD KEY `Purpose4_purpose_1` (`purpose_1`),
  ADD KEY `Purpose4_purpose_2` (`purpose_2`),
  ADD KEY `Purpose4_purpose_3` (`purpose_3`),
  ADD KEY `Purpose4_purpose_4` (`purpose_4`),
  ADD KEY `Purpose4_purpose_5` (`purpose_5`);

ALTER TABLE `Relation`
  ADD PRIMARY KEY (`Relation`),
  ADD UNIQUE KEY `Relation` (`Relation`),
  ADD KEY `Relation_name` (`name`),
  ADD KEY `Relation_source` (`source`),
  ADD KEY `Relation_target` (`target`),
  ADD KEY `Relation_ctxds` (`ctxds`),
  ADD KEY `Relation_declaredIn` (`declaredIn`),
  ADD KEY `Relation_sign` (`sign`),
  ADD KEY `Relation_context` (`context`);

ALTER TABLE `RelationName`
  ADD KEY `RelationName_RelationName` (`RelationName`);

ALTER TABLE `Role`
  ADD PRIMARY KEY (`Role`),
  ADD UNIQUE KEY `Role` (`Role`),
  ADD KEY `Role_name` (`name`);

ALTER TABLE `RoleName`
  ADD KEY `RoleName_RoleName` (`RoleName`);

ALTER TABLE `Rule`
  ADD PRIMARY KEY (`Rule`),
  ADD UNIQUE KEY `Rule` (`Rule`),
  ADD KEY `Rule_PropertyRule` (`PropertyRule`),
  ADD KEY `Rule_name` (`name`),
  ADD KEY `Rule_ctxrs` (`ctxrs`),
  ADD KEY `Rule_udefrules` (`udefrules`),
  ADD KEY `Rule_multrules` (`multrules`),
  ADD KEY `Rule_identityRules` (`identityRules`),
  ADD KEY `Rule_allRules` (`allRules`),
  ADD KEY `Rule_formalExpression` (`formalExpression`),
  ADD KEY `Rule_conceptualDiagram` (`conceptualDiagram`),
  ADD KEY `Rule_urlEncodedName` (`urlEncodedName`),
  ADD KEY `Rule_sign` (`sign`),
  ADD KEY `Rule_origin` (`origin`),
  ADD KEY `Rule_srcConcept` (`srcConcept`),
  ADD KEY `Rule_tgtConcept` (`tgtConcept`);

ALTER TABLE `RuleName`
  ADD KEY `RuleName_RuleName` (`RuleName`);

ALTER TABLE `SESSION`
  ADD PRIMARY KEY (`SESSION`),
  ADD UNIQUE KEY `SESSION` (`SESSION`),
  ADD KEY `SESSION_regStudentnummer` (`regStudentnummer`),
  ADD KEY `SESSION_regEmail` (`regEmail`),
  ADD KEY `SESSION_regCreateAccount` (`regCreateAccount`),
  ADD KEY `SESSION_sessionAccount` (`sessionAccount`),
  ADD KEY `SESSION_sessionUserid` (`sessionUserid`),
  ADD KEY `SESSION_loginUserid` (`loginUserid`),
  ADD KEY `SESSION_logoutRequest` (`logoutRequest`),
  ADD KEY `SESSION_sessionPerson` (`sessionPerson`);

ALTER TABLE `SeqName`
  ADD KEY `SeqName_SeqName` (`SeqName`);

ALTER TABLE `Sequence`
  ADD PRIMARY KEY (`Sequence`),
  ADD UNIQUE KEY `Sequence` (`Sequence`),
  ADD KEY `Sequence_Script` (`Script`),
  ADD KEY `Sequence_compileRequest` (`compileRequest`),
  ADD KEY `Sequence_proto` (`proto`),
  ADD KEY `Sequence_submittor` (`submittor`),
  ADD KEY `Sequence_assignment` (`assignment`),
  ADD KEY `Sequence_submitted` (`submitted`),
  ADD KEY `Sequence_seqName` (`seqName`),
  ADD KEY `Sequence_seqFirstItem` (`seqFirstItem`),
  ADD KEY `Sequence_seqLastItem` (`seqLastItem`);

ALTER TABLE `Signature`
  ADD PRIMARY KEY (`Signature`),
  ADD UNIQUE KEY `Signature` (`Signature`),
  ADD KEY `Signature_src` (`src`),
  ADD KEY `Signature_tgt` (`tgt`);

ALTER TABLE `TType`
  ADD KEY `TType_TType` (`TType`);

ALTER TABLE `UserID`
  ADD KEY `UserID_UserID` (`UserID`),
  ADD KEY `UserID_Studentnummer` (`Studentnummer`);

ALTER TABLE `View`
  ADD PRIMARY KEY (`View`),
  ADD UNIQUE KEY `View` (`View`),
  ADD KEY `View_default` (`default`);

ALTER TABLE `__SessionTimeout__`
  ADD PRIMARY KEY (`SESSION`),
  ADD UNIQUE KEY `SESSION` (`SESSION`),
  ADD KEY `__SessionTimeout___lastAccess` (`lastAccess`);

ALTER TABLE `__all_signals__`
  ADD KEY `__all_signals___conjId` (`conjId`),
  ADD KEY `__all_signals___src` (`src`),
  ADD KEY `__all_signals___tgt` (`tgt`);

ALTER TABLE `accAllowedRoles`
  ADD PRIMARY KEY (`Account`,`Role`),
  ADD KEY `accAllowedRoles_Account` (`Account`),
  ADD KEY `accAllowedRoles_Role` (`Role`);

ALTER TABLE `accDefaultRoles`
  ADD PRIMARY KEY (`Account`,`Role`),
  ADD KEY `accDefaultRoles_Account` (`Account`),
  ADD KEY `accDefaultRoles_Role` (`Role`);

ALTER TABLE `allRoles`
  ADD PRIMARY KEY (`Context`,`Role`),
  ADD KEY `allRoles_Context` (`Context`),
  ADD KEY `allRoles_Role` (`Role`);

ALTER TABLE `allRules`
  ADD PRIMARY KEY (`Pattern`,`Rule`),
  ADD KEY `allRules_Pattern` (`Pattern`),
  ADD KEY `allRules_Rule` (`Rule`);

ALTER TABLE `concepts`
  ADD PRIMARY KEY (`Pattern`,`Concept`),
  ADD KEY `concepts_Pattern` (`Pattern`),
  ADD KEY `concepts_Concept` (`Concept`);

ALTER TABLE `declaredIn`
  ADD PRIMARY KEY (`Relation`,`Pattern`),
  ADD KEY `declaredIn_Relation` (`Relation`),
  ADD KEY `declaredIn_Pattern` (`Pattern`);

ALTER TABLE `declaredthrough`
  ADD PRIMARY KEY (`PropertyRule`,`Property`),
  ADD KEY `declaredthrough_PropertyRule` (`PropertyRule`),
  ADD KEY `declaredthrough_Property` (`Property`);

ALTER TABLE `gengen`
  ADD PRIMARY KEY (`IsE`,`Concept`),
  ADD KEY `gengen_IsE` (`IsE`),
  ADD KEY `gengen_Concept` (`Concept`);

ALTER TABLE `hasView`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `hasView_SrcConcept` (`SrcConcept`),
  ADD KEY `hasView_TgtConcept` (`TgtConcept`);

ALTER TABLE `identityRules`
  ADD PRIMARY KEY (`Rule`,`Pattern`),
  ADD KEY `identityRules_Rule` (`Rule`),
  ADD KEY `identityRules_Pattern` (`Pattern`);

ALTER TABLE `in`
  ADD PRIMARY KEY (`Pair`,`Expression`),
  ADD KEY `in_Pair` (`Pair`),
  ADD KEY `in_Expression` (`Expression`);

ALTER TABLE `interfaces`
  ADD PRIMARY KEY (`Role`,`Interface`),
  ADD KEY `interfaces_Role` (`Role`),
  ADD KEY `interfaces_Interface` (`Interface`);

ALTER TABLE `isa1`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isa1_SrcConcept` (`SrcConcept`),
  ADD KEY `isa1_TgtConcept` (`TgtConcept`);

ALTER TABLE `isaCopy`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isaCopy_SrcConcept` (`SrcConcept`),
  ADD KEY `isaCopy_TgtConcept` (`TgtConcept`);

ALTER TABLE `isaPlus`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isaPlus_SrcConcept` (`SrcConcept`),
  ADD KEY `isaPlus_TgtConcept` (`TgtConcept`);

ALTER TABLE `isaRfx`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isaRfx_SrcConcept` (`SrcConcept`),
  ADD KEY `isaRfx_TgtConcept` (`TgtConcept`);

ALTER TABLE `isaRfxCopy`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isaRfxCopy_SrcConcept` (`SrcConcept`),
  ADD KEY `isaRfxCopy_TgtConcept` (`TgtConcept`);

ALTER TABLE `isaRfxPlus`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isaRfxPlus_SrcConcept` (`SrcConcept`),
  ADD KEY `isaRfxPlus_TgtConcept` (`TgtConcept`);

ALTER TABLE `isaRfxStar`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isaRfxStar_SrcConcept` (`SrcConcept`),
  ADD KEY `isaRfxStar_TgtConcept` (`TgtConcept`);

ALTER TABLE `isaStar`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `isaStar_SrcConcept` (`SrcConcept`),
  ADD KEY `isaStar_TgtConcept` (`TgtConcept`);

ALTER TABLE `maintains`
  ADD PRIMARY KEY (`Role`,`Rule`),
  ADD KEY `maintains_Role` (`Role`),
  ADD KEY `maintains_Rule` (`Rule`);

ALTER TABLE `meaning1`
  ADD KEY `meaning1_Rule` (`Rule`);

ALTER TABLE `message1`
  ADD KEY `message1_Rule` (`Rule`);

ALTER TABLE `multrules`
  ADD PRIMARY KEY (`Rule`,`Pattern`),
  ADD KEY `multrules_Rule` (`Rule`),
  ADD KEY `multrules_Pattern` (`Pattern`);

ALTER TABLE `prop`
  ADD PRIMARY KEY (`Relation`,`Property`),
  ADD KEY `prop_Relation` (`Relation`),
  ADD KEY `prop_Property` (`Property`);

ALTER TABLE `propertyRule`
  ADD PRIMARY KEY (`Relation`,`PropertyRule`),
  ADD KEY `propertyRule_Relation` (`Relation`),
  ADD KEY `propertyRule_PropertyRule` (`PropertyRule`);

ALTER TABLE `purpose1`
  ADD KEY `purpose1_Context` (`Context`);

ALTER TABLE `purpose2`
  ADD KEY `purpose2_View` (`View`);

ALTER TABLE `purpose3`
  ADD KEY `purpose3_Identity` (`Identity`);

ALTER TABLE `relsDefdIn`
  ADD PRIMARY KEY (`Pattern`,`Relation`),
  ADD KEY `relsDefdIn_Pattern` (`Pattern`),
  ADD KEY `relsDefdIn_Relation` (`Relation`);

ALTER TABLE `sessionActiveRoles`
  ADD PRIMARY KEY (`SESSION`,`Role`),
  ADD KEY `sessionActiveRoles2d935c2790dd92f51949173d9ae0254f` (`SESSION`),
  ADD KEY `sessionActiveRoles_Role` (`Role`);

ALTER TABLE `sessionAllowedRoles`
  ADD PRIMARY KEY (`SESSION`,`Role`),
  ADD KEY `sessionAllowedRoles2d935c2790dd92f51949173d9ae0254f` (`SESSION`),
  ADD KEY `sessionAllowedRoles_Role` (`Role`);

ALTER TABLE `source`
  ADD PRIMARY KEY (`ScriptVersion`,`FileObject`),
  ADD KEY `source_ScriptVersion` (`ScriptVersion`),
  ADD KEY `source_FileObject` (`FileObject`);

ALTER TABLE `udefrules`
  ADD PRIMARY KEY (`Rule`,`Pattern`),
  ADD KEY `udefrules_Rule` (`Rule`),
  ADD KEY `udefrules_Pattern` (`Pattern`);

ALTER TABLE `usedIn`
  ADD PRIMARY KEY (`Relation`,`Expression`),
  ADD KEY `usedIn_Relation` (`Relation`),
  ADD KEY `usedIn_Expression` (`Expression`);

ALTER TABLE `uses`
  ADD PRIMARY KEY (`Context`,`Pattern`),
  ADD KEY `uses_Context` (`Context`),
  ADD KEY `uses_Pattern` (`Pattern`);

ALTER TABLE `valid1`
  ADD PRIMARY KEY (`Rule`,`Context`),
  ADD KEY `valid1_Rule` (`Rule`),
  ADD KEY `valid1_Context` (`Context`);

ALTER TABLE `valid2`
  ADD PRIMARY KEY (`Relation`,`Context`),
  ADD KEY `valid2_Relation` (`Relation`),
  ADD KEY `valid2_Context` (`Context`);

ALTER TABLE `valid3`
  ADD PRIMARY KEY (`Concept`,`Context`),
  ADD KEY `valid3_Concept` (`Concept`),
  ADD KEY `valid3_Context` (`Context`);

ALTER TABLE `viewBy`
  ADD PRIMARY KEY (`SrcConcept`,`TgtConcept`),
  ADD KEY `viewBy_SrcConcept` (`SrcConcept`),
  ADD KEY `viewBy_TgtConcept` (`TgtConcept`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
