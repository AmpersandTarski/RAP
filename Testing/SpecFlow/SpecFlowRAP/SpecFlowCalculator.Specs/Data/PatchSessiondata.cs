using System.Text.Json.Serialization;

namespace SpecFlowRAP.Specs.Data
{

    public class PatchSessiondata
    {
        [JsonPropertyName("content")]
        public object? Content { get; set; }

        [JsonPropertyName("patches")]
        public List<Patch>? Patches { get; set; }

        [JsonPropertyName("notifications")]
        public Notifications? Notifications { get; set; }

        [JsonPropertyName("invariantRulesHold")]
        public bool InvariantRulesHold { get; set; }

        [JsonPropertyName("isCommitted")]
        public bool IsCommitted { get; set; }

        [JsonPropertyName("sessionRefreshAdvice")]
        public bool SessionRefreshAdvice { get; set; }

        [JsonPropertyName("navTo")]
        public object? NavTo { get; set; }
    }

    public class Patch
    {
        [JsonPropertyName("op")]
        public string? Op { get; set; }

        [JsonPropertyName("path")]
        public string? Path { get; set; }

        [JsonPropertyName("value")]
        public object? Value { get; set; }
    }
}
