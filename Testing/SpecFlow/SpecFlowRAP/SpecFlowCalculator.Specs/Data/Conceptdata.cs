
namespace SpecFlowRAP.Specs.Data
{

    // Klasse voor View object
    public class ViewCourse
    {
        public string? Imgfile { get; set; }
    }

    // Klasse voor het sub-object binnen Concept_58_
    public class ConceptSubObject : subBaseClass
    { }

    // Klasse voor Purpose objecten
    public class Purpose : subBaseClass
    { }

    // Klasse voor UsedInRules object
    public class UsedInRules : subBaseClass
    {
        public ViewCourse? _view_ { get; set; }
    }


    // Klasse voor de root van het JSON object
    public class Conceptdata : subBaseClass
    {
        public ConceptSubObject Concept_58_ { get; set; }
        public List<object> Definition { get; set; } // Gebruik object omdat het leeg is, kan naar type aangepast worden als nodig.
        public List<Purpose> Purpose_58_ { get; set; }
        public UsedInRules Used_32_in_32_rules { get; set; }
        public Context Context { get; set; }
    }
}
