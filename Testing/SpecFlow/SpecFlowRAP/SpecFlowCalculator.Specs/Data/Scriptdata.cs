using System.Text.Json.Serialization;

namespace SpecFlowRAP
{
    public class ScriptIddata
    {
        [JsonPropertyName("_id_")]
        public string? _id_ { get; set; }
    }
}