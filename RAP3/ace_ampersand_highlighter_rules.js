var AmpersandHighlightRules = function() {
    // regexp must not have capturing parentheses. Use (?:) instead.
    // regexps are ordered -> the first match is used
// Syntax: { token: <token>, // String, Array, or Function: the CSS token to apply (<span class="ace_<token>">)
//           regex: <regex>, // String or RegExp: the regexp to match
//           next:  <next>   // [Optional] String: next state to enter upon a match.
//           caseInsensitive: false, // [Optional] boolean: whether or not match is case insenstive
//         }
   this.$rules = 
   {
   	"start":[
         { token : "comment"
             ,regex : "--[^\n\r]*", // line comment
             ,caseInsensitive: false,
         //  ,next : "start"
         }
        ,{ token : "comment"
             ,regex : "{-" // start Haskell block comment
             ,next : "haskellblockcomment"
         }
        ,{ token : "comment"
             ,regex : "{+" // start Ampersand block comment (as in PURPOSE, MEANING, ...)
             ,next : "ampersandblockcomment"
         }
        ,{ token : "string" // Strings
             ,regex : "\"(?:[^\"](?!\"))*\""
         //  ,next : "start"
         }
        ,{ token : "keyword" // Reserved words
             ,regex : "\b(INCLUDE|THEMES|CONTEXT|ENDCONTEXT|IN|DUTCH|ENGLISH|REST|HTML|LATEX|MARKDOWN|META|THEMES|PATTERN|ENDPATTERN|PROCESS|ENDPROCESS|SERVICE|ENDSERVICE|CLASSIFY|SPEC|ISA|IS|RULE|MEANING|MESSAGE|VIOLATION|RELATION|PRAGMA|CONCEPT|BYPLUG|TYPE|REPRESENT|SRC|TGT|TXT|ALPHANUMERIC|BIGALPHANUMERIC|HUGEALPHANUMERIC|PASSWORD|BINARY|BIGBINARY|HUGEBINARY|DATE|DATETIME|BOOLEAN|INTEGER|FLOAT|IDENT|VIEW|ENDVIEW|HTML|TEMPLATE|TXT|PRIMHTML|CLASS|PURPOSE|POPULATION|CONTAINS|ROLE|SERVICE|MAINTAINS)\b",
         //  ,next : "start"
         }
        ,{ token : "keyword" // Multiplicities
             ,regex : "\[(\s*+(INJ|SUR|UNI|TOT|SYM|ASY|RFX|IRF|TRN|PROP)(\s*+(,\s*+(INJ|SUR|UNI|TOT|SYM|ASY|RFX|IRF|TRN|PROP))*+)?+)?+\s*+\]"
         //  ,next : "start"
         }
        ,{ token : "keyword" // Frontend keywords
             ,regex : "\b(INTERFACE|FOR|[Cc][Rr][Uu][Dd]|BOX|ROWS|TABS|COLS|LINKTO)\b"
         //  ,next : "start"
         }
        ,{ token : "keyword" // Frontend templates
             ,regex : "\b<(TABS|ROWS|COLS|SCOLS|HCOLS|HROWS|SHCOLS|SPCOLS|SPHCOLS|ROWSNL|COLSNL)>\b"
         //  ,next : "start"
         }
        ,{ token : "keyword" // Specials
             ,regex : "(\bExecEngine\b|\b{EX}\b|\b(InsPair|DelPair|NewStruct|DelAtom)\b|'ONE'|"_SESSION")\[SESSION\]|"_SESSION"|\bSESSION\b|\b_NEW\b)"
         //  ,next : "start"
         }
        ,{ token : "operator" // V, I
             ,regex : "\b[VI](?=\s*\[\s*([A-Z][a-zA-Z0-9_-]*)\s*(|\*\s*([A-Z][a-zA-Z0-9_-]*)\s*)\])"
         //  ,next : "start"
         }
        ,{ token : "operator" // V, I
             ,regex : "\|-|-|->|=|~|\+|;|!|\*|::|:|\\/|/\\|\\|/|<>"
         //  ,next : "start"
         }
//        ,{ token : ["relation", "src", "tgt"]
//             ,regex : "RELATION\s+([a-z][a-zA-Z0-9_-]*)\s*\[\s*([A-Z][a-zA-Z0-9_-]*)\s*\*\s*([A-Z][a-zA-Z0-9_-]*)\s*\]"
//         } // RELATION rel[Alpha*Beta] -> relation($1=rel), src($2=Alpha), tgt($3=Beta)
//        ,{ token : ["multiplicities", "src", "tgt"]
//             ,regex : "RELATION\s*([a-z]^[\s]*)\s*\[\s*([A-Z]^[\s]*)\*\s*([A-Z]^[\s]*)\s*\]"
//         } // RELATION rel[Alpha*Beta] -> relation(rel), src(Alpha), tgt(Beta)
        ]

        ,"haskellblockcomment":[
         { token : "comment"
	     ,regex : ".*(?=-})"
             ,caseInsensitive: true
         //  ,next : "haskellblockcomment"
         }
        ,{ token : "comment"
	     ,regex : "-})"
             ,caseInsensitive: true
             ,next : "start"
         }
        ]

        ,"ampersandblockcomment":[
         { token : "comment"
	     ,regex : ".*(?=+})"
             ,caseInsensitive: true
         //  ,next : "ampersandblockcomment"
         }
        ,{ token : "comment"
	     ,regex : "+})"
             ,caseInsensitive: true
             ,next : "start"
         }
        ]
    };
};
