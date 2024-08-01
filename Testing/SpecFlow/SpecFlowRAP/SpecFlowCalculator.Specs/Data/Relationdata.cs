using System.Text.Json.Serialization;

namespace SpecFlowRAP.Specs.Data
{

    public class Relationdata : subBaseClass
    {
        [JsonPropertyName("Relation_58_")]
        public Relation? Relation58 { get; set; }

        [JsonPropertyName("Source_32_concept_58_")]
        public Concept? SourceConcept58 { get; set; }

        [JsonPropertyName("Target_32_concept_58_")]
        public Concept? TargetConcept58 { get; set; }

        [JsonPropertyName("Eigenschappen_58_")]
        public List<string>? Eigenschappen58 { get; set; }

        [JsonPropertyName("Properties_58_")]
        public List<string>? Properties58 { get; set; }

        [JsonPropertyName("MEANING_58_")]
        public List<Meaning>? Meaning58 { get; set; }

        [JsonPropertyName("PURPOSE_58_")]
        public List<object>? Purpose58 { get; set; } // Assuming empty array or unknown type

        [JsonPropertyName("Context")]
        public List<Context>? Context { get; set; }
    }
}
