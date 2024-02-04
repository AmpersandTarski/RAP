# Templates
Templates are used to generate prototype user interfaces based on Ampersand INTERFACE definitions.
There are 3 types of templates:
1. Box template -> 
2. Atomic templates -> used for interface leaves nodes (without a user defined VIEW specified)
3. View templates -> used for user defined views

e.g.
```adl
INTERFACE Project : I[Project] cRud BOX           <-- the default FORM box template is used
  [ "Name"                : projectName             <-- the default atomic template for a alphanumeric type is used
  , "Description"         : projectDescription
  , "(Planned) start date": projectStartDate 
  , "Active"              : projectActive
  , "Current PL"          : pl <PersonEmail>        <-- a user defined PersonEmail view template is used
  , "Project members"     : member BOX <TABLE>      <-- the built-in TABLE box template is used
    [ "Name"              : personFirstName
    , "Email"             : personEmail
    ]
  ]
```

## BOX templates

### FORM (=default BOX template)
Interface template for forms structures. For each target atom a form is added. The sub interfaces are used as form fields.
This template replaces former templates: `ROWS`, `HROWS`, `HROWSNL` and `ROWSNL`

Usage `BOX <FORM attributes*>`

For root interface boxes automatically a title is added which equals the interface name. To hide this title use `noRootTitle` attribute.

Examples:
- `BOX <FORM>`
- `BOX <FORM hideLabels>`
- `BOX <FORM hideOnNoRecords>`
- `BOX <FORM title="Title of your form">`
- `BOX <FORM hideLabels hideOnNoRecords noRootTitle>`

Possible attributes are:
| attribute | value | description |
| --------- | ----- | ----------- |
| hideOnNoRecords | n.a. | when attribute is set, the complete form is hidden in the interface when there are no records |
| hideLabels | n.a. | when attribute is set, no field labels are shown |
| title | string | title / description for the forms. Title is shown above the form |
| noRootTitle | n.a. | hides title; usefull for root interface boxes where a title is automatically is added |

### TABLE
Interface template for table structures. The target atoms of the interface make up the records / rows. The sub interfaces are used as columns.
This templates replaces former templates: `COLS`, `SCOLS`, `HCOLS`, `SHCOLS` and `COLSNL`

Usage: `BOX <TABLE attributes*>`

For root interface boxes automatically a title is added which equals the interface name. To hide this title use `noRootTitle` attribute.

Examples:
- `BOX <TABLE>`                              -- was: COLS
- `BOX <TABLE noHeader>`
- `BOX <TABLE hideOnNoRecords>`              -- was: HCOLS
- `BOX <TABLE title="Title of your table">`
- `BOX <TABLE noHeader hideOnNoRecords title="Table with title">`

Possible attributes are:
| attribute | value | description |
| --------- | ----- | ----------- |
| hideOnNoRecords | n.a. | when attribute is set, the complete table is hidden in the interface when there are no records |
| noHeader | n.a. | when attribute is set, no table header is used |
| title | string | title / description for the table. Title is shown above table |
| noRootTitle | n.a. | hides title; usefull for root interface boxes where a title is automatically is added |
| sortable | n.a. | makes table headers clickable to support sorting on some property of the data. Only applies to univalent fields |
| sortBy | sub interface label | Add default sorting for given sub interface. Use in combination with 'sortable' |
| order | `desc`, `asc` | Specifies default sorting order. Use in combination with 'sortBy'. Use `desc` for descending, `asc` for ascending |

### TABS
Interface template for a form structure with different tabs. For each sub interface a tab is added.
This template is used best in combination with univalent interface expressions (e.g. `INTERFACE Test : univalentExpression BOX <TABS>`), because for each target atom of the expression a complete form (with all tabs) is shown.

Usage `BOX <TABS attributes*>`

For root interface boxes automatically a title is added which equals the interface name. To hide this title use `noRootTitle` attribute.

Example:
- `BOX <TABS>`
- `BOX <TABS title="Tabs with title">`
- `BOX <TABS noRootTitle>`

Possible attributes are:
| attributes | value | description |
| ---------- | ----- | ----------- |
| title      | string | title / description for the table. Title is shown above tabs structure |
| noRootTitle    | n.a. | hides title; usefull for root interface boxes where a title is automatically is added |
| hideOnNoRecords | n.a. | hides a certain tab (i.e. sub interface) when that expression has no target atoms |

### RAW
Interface template without any additional styling and without (editing) functionality. Just plain html `<div>` elements
This template replaces former templates: `DIV`, `CDIV` and `RDIV`

Usage: `BOX <RAW attributes*>`

Examples:
- `BOX <RAW>`
- `BOX <RAW form>`
- `BOX <RAW table>`

Possible attributes are:
| attribute | value | description |
| --------- | ----- | ----------- |
| form      | n.a.  | uses simple form structure to display data. Similar to `FORM` template, but without any functionality nor markup. This is the default layout for `RAW` template.
| table     | n.a.  | uses simple table structure to display data. Similar to `TABLE` template (see below), but without any functionality, header and styling

### PROPBUTTON
Interface template that provides functionality to toggle (set/unset) a property-relation using a button.
The label (i.e. text to put on the button) can be constructed from max 4 expressions or text strings (i.e. `TXT "some text here"`). Also, the color of the button can be defined for various circumstances, as well as other button properties.

Usage:
```
expr cRud BOX <PROPBUTTON> 
  [ "property": propRel cRUd -- mandatory; the property that is set/unset when the button is clicked
  , "label":  expr or txt -- optional; label text is the result of expr or txt
  , "label1": expr or txt -- optional; label text = label+label1
  , "label2": expr or txt -- optional; label text = label+label1+label2
  , "label3": expr or txt -- optional; label text = label+label1+label2+label3
  , "color": color -- optional; see below for details.
  , "popovertext": expr or txt -- optional; text that is displayed when hovering the button
  , "hide": expr cRud -- optional; button is hidden (not shown) when expression evaluates to true
  , "disabled": expr -- optional; button is disabled (not clickable) when expression evaluates to true
  , "disabledcolor": color -- optional; see below for details.
  , "disabledpopovertext": expr or txt -- optional; text is shown instead of popovertext when button is disabled.
   ]
```
where:
- `propRel` is an & `[PROP]`-type relation, whose value will be toggled when the user clicks the button.
- `expr` refers to an &-expression that should be univalent (and should be followed by `cRud` except when explicitly mentioned otherwise);
- `txt` refers to the syntax `TXT "some text here"`;
- `color` refers to `TXT "colorword"` can be primary (blue), secondary (grey), success (green), warning (yellow), danger (red), info (lightblue), light (grey), dark (black). It should be possible to precede color names 'outline-' (e.g. 'outline-primary') to make outline buttons (i.e. buttons with only the outline coloured), but that does not yet seem to work properly.


Possible attributes are:
| attribute | value | description |
| --------- | ----- | ----------- |
| *currently there are no attributes for this template*


## Atomic templates (i.e. interface leaves)

### OBJECT

### ALPHANUMERIC, BIGALPHANUMERIC, HUGEALPHANUMERIC

### BOOLEAN

### DATE, DATETIME

### INTEGER, FLOAT

### PASSWORD

### TYPEOFONE
Special interface for singleton 'ONE' atom. This probably is never used in an prototype user interface. 

### OBJECTDROPDOWN
Interface template that can be used to populate a relation (whose target concept MUST BE an object) using a dropdown list.
Objects are concepts for which there is no `REPRESENT` statement; non-objects (or values) are concepts for which there is (e.g. `REPRESENT SomeConcept TYPE ALPHANUMERIC`). This template can be used for objects. Use `BOX <VALUEDROPDOWN>` for non-objects.

Usage:
```
expr cRud BOX <OBJECTDROPDOWN>
[ "selectfrom": selExpr cRud <ObjectView> -- population from which the user can make a selection.
, "setrelation": setRel cRUd -- If the relation is [UNI], a newly selected object will replace the existing population.
, "instruction": expr or txt -- Text that shows when nothing is selected yet.
, "selectflag": selectEventFlag cRUd -- [PROP]-type relation that toggles when OBJECT is selected.
, "deselectflag": deselectEventFlag cRUd -- [PROP]-type relation that toggles when NO OBJECT is selected.
]
```

where:
- `expr` is an expression that, if and only if 'TRUE' causes the dropdown box to be shown.
- `selExpr cRud` specifies the objects that the user may select from. 
- `<ObjectView>` the VIEW to be used to show the selectable objects in the dropdown box.
- `setRel cRUd` is the relation whose population is modified as a result of the users actions. 
  - If the relation is `[UNI]` the user may overwrite its value (tgt atom) by selecting an object.
  - If the relation is not `[UNI]`, the user can add values (tgt atoms) by selecting one or more objects.
  - When the user selects the NO OBJECT, the (list of) tgt atom(s) is cleared.
- `expr or txt` in the 'instruction' field specifies the text that the user sees when no object has been selected.
- `selectEventFlag cRUd` specifies a [PROP]-type relation that will be toggled when an object is selected.
- `deselectEventFlag cRUd` specifies a [PROP]-type relation that toggles when NO OBJECT is selected.

NOTE that the `cRud` and `cRUd` usage must be strictly followed here!

### VALUEDROPDOWN
Interface template that can be used to populate a relation (whose target concept is NOT an object) using a dropdown list. Objects are concepts for which there is no `REPRESENT` statement; non-objects (or values) are concepts for which there is (e.g. `REPRESENT SomeConcept TYPE ALPHANUMERIC`). This template can be used for values (non-objects). Use `BOX <OBJECTDROPDOWN>` for concepts that are objects.

Usage:
```
expr cRud BOX <VALUEDROPDOWN>
[ "selectfrom": selExpr cRud <ValueView> -- population from which the user can make a selection.
, "setrelation": setRel cRUd -- If the relation is [UNI], a newly selected value will replace the existing population.
, "instruction": expr or txt -- Text that shows when nothing is selected yet.
, "selectflag": selectEventFlag cRUd -- [PROP]-type relation that toggles when VALUE is selected.
, "deselectflag": deselectEventFlag cRUd -- [PROP]-type relation that toggles when NO VALUE is selected.
]
```

where:
- `expr` is an expression that, if and only if 'TRUE' causes the dropdown box to be shown.
- `selExpr cRud` specifies the values that the user may select from. 
- `<ValueView>` the VIEW to be used to show the selectable values in the dropdown box.
- `setRel cRUd` is the relation whose population is modified as a result of the users actions. 
  - If the relation is `[UNI]` the user may overwrite its value (tgt atom) by selecting an value.
  - If the relation is not `[UNI]`, the user can add values (tgt atoms) by selecting one or more values.
  - When the user selects the NO VALUE, the (list of) tgt atom(s) is cleared.
- `expr or txt` in the 'instruction' field specifies the text that the user sees when no value has been selected.
- `selectEventFlag cRUd` specifies a [PROP]-type relation that will be toggled when an value is selected.
- `deselectEventFlag cRUd` specifies a [PROP]-type relation that toggles when NO VALUE is selected.

NOTE that the `cRud` and `cRUd` usage must be strictly followed here!

## Built-in VIEW templates

### FILEOBJECT
The purpose of this template, and the associated code, is to allow users to download and upload files.

To use: add the following statements to your script:

```
  IDENT FileObjectName: FileObject (filePath)
  RELATION filePath[FileObject*FilePath] [UNI,TOT]
  RELATION originalFileName[FileObject*FileName] [UNI,TOT]

  REPRESENT FilePath,FileName TYPE ALPHANUMERIC

  VIEW FileObject: FileObject DEFAULT 
  { apiPath  : TXT "api/v1/file"
  , filePath : filePath
  , fileName : originalFileName
  } HTML TEMPLATE "View-FILEOBJECT.html" ENDVIEW
```

### LINKTO
This template can be used to specify the interface to which the user must navigate.

Usage:
```
  "label": expr LINKTO INTERFACE InterfaceName
```

where:
- `expr` is an ampersand expression, as usual
- `InterfaceName` is the name of an existing interface whose (SRC) concept matches the TGT concept of `expr`.

### PROPERTY

### STRONG

### URL