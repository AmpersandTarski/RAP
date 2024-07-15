using System.Text.Json.Serialization;

namespace SpecFlowRAP.Specs.Data
{

    public class Navbardata
    {
        [JsonPropertyName("home")]
        public string? Home { get; set; }

        [JsonPropertyName("navs")]
        public List<Nav>? Navs { get; set; }

        [JsonPropertyName("new")]
        public List<object>? New { get; set; }

        [JsonPropertyName("ext")]
        public List<object>? Ext { get; set; }

        [JsonPropertyName("role")]
        public List<object>? Role { get; set; }

        [JsonPropertyName("defaultSettings")]
        public DefaultSettings? DefaultSettings { get; set; }

        [JsonPropertyName("notifications")]
        public Notifications? Notifications { get; set; }

        [JsonPropertyName("session")]
        public Session? Session { get; set; }

        [JsonPropertyName("sessionRoles")]
        public List<SessionRole>? SessionRoles { get; set; }

        [JsonPropertyName("sessionVars")]
        public bool SessionVars { get; set; }
    }

    public class Nav
    {
        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("label")]
        public string? Label { get; set; }

        [JsonPropertyName("seqNr")]
        public int? SeqNr { get; set; }

        [JsonPropertyName("ifc")]
        public string? Ifc { get; set; }

        [JsonPropertyName("url")]
        public string? Url { get; set; }

        [JsonPropertyName("parent")]
        public string? Parent { get; set; }
    }

    public class DefaultSettings
    {
        [JsonPropertyName("notify_showSignals")]
        public bool? NotifyShowSignals { get; set; }

        [JsonPropertyName("notify_showInfos")]
        public bool? NotifyShowInfos { get; set; }

        [JsonPropertyName("notify_showSuccesses")]
        public bool? NotifyShowSuccesses { get; set; }

        [JsonPropertyName("notify_autoHideSuccesses")]
        public bool NotifyAutoHideSuccesses { get; set; }

        [JsonPropertyName("notify_showErrors")]
        public bool NotifyShowErrors { get; set; }

        [JsonPropertyName("notify_showWarnings")]
        public bool NotifyShowWarnings { get; set; }

        [JsonPropertyName("notify_showInvariants")]
        public bool NotifyShowInvariants { get; set; }

        [JsonPropertyName("autoSave")]
        public bool AutoSave { get; set; }
    }

    public class Notifications
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

    public class Session
    {
        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("loggedIn")]
        public bool? LoggedIn { get; set; }
    }

    public class SessionRole
    {
        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("label")]
        public string? Label { get; set; }

        [JsonPropertyName("active")]
        public bool? Active { get; set; }
    }
}
