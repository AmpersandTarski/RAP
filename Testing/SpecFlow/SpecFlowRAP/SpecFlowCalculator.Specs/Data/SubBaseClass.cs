using System.Text.Json.Serialization;

namespace SpecFlowRAP.Specs.Data
{
    public abstract class subBaseClass : InterfaceList
    {
        public string? _id_ { get; set; }
        public string? _label_ { get; set; }
        public string? _path_ { get; set; }
        public subBaseClass()
        {
            _id_ = null;
            _label_ = null;
            _path_ = null;
        }
        public subBaseClass(string id, string label, string path)
        {
            _id_ = id;
            _label_ = label;
            _path_ = path;
        }
    }

    public abstract class InterfaceList
    {
        [JsonPropertyName("_ifcs_")]
        public List<Interface>? Interfaces { get; set; }
    }

    public class Interface
    {
        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("label")]
        public string? Label { get; set; }
        public Interface()
        {
            Id = null;
            Label = null;
        }
        public Interface(string? id, string? label)
        {
            Id = id;
            Label = label;
        }
    }
}
