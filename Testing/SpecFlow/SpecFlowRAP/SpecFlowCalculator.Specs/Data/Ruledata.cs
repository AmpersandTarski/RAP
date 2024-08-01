using System.Text.Json.Serialization;

namespace SpecFlowRAP.Specs.Data
{

    public class Ruledata : subBaseClass
    {
        [JsonPropertyName("Regel_58_")]
        public Rule? Regel58 { get; set; }

        [JsonPropertyName("origin")]
        public List<string>? Origin { get; set; }

        [JsonPropertyName("Formele_32_expressie_58_")]
        public BinaryTerm? FormeleExpressie58 { get; set; }

        [JsonPropertyName("MEANING_58_")]
        public List<Meaning>? Meaning58 { get; set; }

        [JsonPropertyName("PURPOSE_58_")]
        public List<object>? Purpose58 { get; set; } // Assuming empty array or unknown type

        [JsonPropertyName("Conceptual_32_diagram")]
        public FileObject? ConceptualDiagram { get; set; }

        [JsonPropertyName("Context")]
        public List<Context>? Context { get; set; }
    }

    public class Rule : subBaseClass
    { }

    public class BinaryTerm : subBaseClass
    { }

    public class Meaning : subBaseClass
    { }

    public class FileObject : BaseClass
    { }

}
