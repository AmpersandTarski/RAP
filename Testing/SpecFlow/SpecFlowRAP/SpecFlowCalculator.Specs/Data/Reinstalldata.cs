using System.Text.Json.Serialization;

public class Reinstalldata
{
    [JsonPropertyName("errors")]
    public List<object>? Errors { get; set; }

    [JsonPropertyName("warnings")]
    public List<object>? Warnings { get; set; }

    [JsonPropertyName("infos")]
    public List<object>? Infos { get; set; }

    [JsonPropertyName("successes")]
    public List<Success>? Successes { get; set; }

    [JsonPropertyName("invariants")]
    public List<object>? Invariants { get; set; }

    [JsonPropertyName("signals")]
    public List<object>? Signals { get; set; }
}

public class Success
{
    [JsonPropertyName("message")]
    public string? Message { get; set; }
}
