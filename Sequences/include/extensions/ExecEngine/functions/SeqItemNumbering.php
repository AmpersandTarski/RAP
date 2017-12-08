<?php
// SeqItemNumbering functions

function sinComputeItemValue($relation,$srcConcept,$srcAtom,$tgtConcept,$predSinValue)
	{   $predSinValue++; // See http://php.net/manual/en/language.operators.increment.php for the details.
		InsPair($relation,$srcConcept,$srcAtom,$tgtConcept,$predSinValue);
	}

function sinComputeItemText($relation,$srcConcept,$srcAtom,$tgtConcept,$prefix,$itemSinValue,$postfix)
	{   $tgtAtom = $itemSinValue;
	    if ($prefix != '_NULL') $tgtAtom = $prefix.$tgtAtom;
	    if ($postfix != '_NULL') $tgtAtom = $tgtAtom.$postfix;
		InsPair($relation,$srcConcept,$srcAtom,$tgtConcept,$tgtAtom);
	}
?>