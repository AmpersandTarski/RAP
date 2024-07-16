
namespace SpecFlowRAP.Specs.Data
{
    public class Script : subBaseClass
    { }

    public class Pattern : subBaseClass
    { }

    public class Concept : subBaseClass
    { }

    public class Property : subBaseClass
    { }

    public class Relation : subBaseClass
    { }

    public class SortValues
    {
        public string? Context { get; set; }
        public string? VersionInfo { get; set; }
    }

    public class Context : subBaseClass
    { }

    public class Empty : subBaseClass
    {
        public Context? context { get; set; }
        public SortValues? _sortValues_ { get; set; }
        public List<Pattern>? patterns { get; set; }
        public List<Concept>? concepts { get; set; }
        public List<Rule>? rules { get; set; }
        public List<Property>? properties { get; set; }
        public List<Relation>? relations { get; set; }
        public string? versionInfo { get; set; }
    }

    public class Atlasdata : subBaseClass
    {
        public List<Script>? Terug_32_naar_32_script { get; set; }
        public Empty? _EMPTY_ { get; set; }
    }
}
