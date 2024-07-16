using System.Text.Json.Serialization;

namespace SpecFlowRAP.Specs.Data
{
    public class Logoutdata : BaseClass
    {
        [JsonPropertyName("Userid")]
        public string? UserId { get; set; }

        [JsonPropertyName("Person")]
        public string? Person { get; set; }

        [JsonPropertyName("Logout")]
        public LogoutSettings? LogoutSettings { get; set; }
    }

    public class LogoutSettings : BaseClass
    {
        [JsonPropertyName("property")]
        public bool property { get; set; }
    }
}