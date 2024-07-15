
namespace SpecFlowRAP.Specs.Data
{
    using System;
    using System.Collections.Generic;
    using System.Text.Json;
    using System.Text.Json.Serialization;

    public class Myaccountdata : BaseClass
    {
        [JsonPropertyName("no_32_session_32_account")]
        public List<object>? NoSessionAccount { get; set; }

        [JsonPropertyName("session_32_account")]
        public SessionAccount? SessionAccount { get; set; }
    }

    public class SessionAccount : BaseClass
    {
        [JsonPropertyName("Userid")]
        public string? Userid { get; set; }

        [JsonPropertyName("Nieuw_32_wachtwoord")]
        public List<NieuwWachtwoord>? NieuwWachtwoord { get; set; }

        [JsonPropertyName("Persoon")]
        public string? Persoon { get; set; }

        [JsonPropertyName("Toegestane_32_rollen")]
        public List<ToegestaneRol>? ToegestaneRollen { get; set; }
    }

    public class View
    {
        [JsonPropertyName("uid")]
        public string? Uid { get; set; }
    }

    public class NieuwWachtwoord : BaseClass
    {
        [JsonPropertyName("Nieuw")]
        public object? Nieuw { get; set; }

        [JsonPropertyName("_40_herhaal_41_")]
        public object? Herhaal { get; set; }
    }

    public class ToegestaneRol : BaseClass
    {
    }
}
