using System.Text.Json.Serialization;

namespace SpecFlowRAP.Specs.Data
{

    public class Disabled : BaseClass
    {
    }

    public class InnerLogin : BaseClass
    {
        [JsonPropertyName("property")]
        public bool Property { get; set; }

        [JsonPropertyName("disabled")]
        public Disabled? Disabled { get; set; }
    }

    public class RegisterDetail : BaseClass
    {
        [JsonPropertyName("property")]
        public bool Property { get; set; }

        [JsonPropertyName("disabled")]
        public Disabled? Disabled { get; set; }

        [JsonPropertyName("popovertext")]
        public List<string>? Popovertext { get; set; }
    }

    public class NestedRegister : BaseClass
    {
        [JsonPropertyName("Register")]
        public RegisterDetail? Register { get; set; }
    }

    public class Login : BaseClass
    {
        [JsonPropertyName("Userid")]
        public string? Userid { get; set; }

        [JsonPropertyName("Password")]
        public string? Password { get; set; }

        [JsonPropertyName("Login")]
        public InnerLogin? InnerLogin { get; set; }

        [JsonPropertyName("_32__32__32_")]
        public NestedRegister? NestedRegister { get; set; }
    }

    public class FormToFillIn : BaseClass
    {
        [JsonPropertyName("Userid_32__40__42__41_")]
        public string? Userid { get; set; }

        [JsonPropertyName("Password_32__40__42__41_")]
        public string? Password { get; set; }

        [JsonPropertyName("Your_32_name")]
        public string? YourName { get; set; }
    }

    public class CreateAccountButton : BaseClass
    {
        [JsonPropertyName("property")]
        public bool Property { get; set; }

        [JsonPropertyName("disabled")]
        public Disabled? Disabled { get; set; }

        [JsonPropertyName("popovertext")]
        public List<string>? Popovertext { get; set; }
    }

    public class CancelButton : BaseClass
    {
        [JsonPropertyName("property")]
        public bool Property { get; set; }
    }

    public class Buttons : BaseClass
    {
        [JsonPropertyName("Create_32_account")]
        public CreateAccountButton? CreateAccount { get; set; }

        [JsonPropertyName("Cancel")]
        public CancelButton? Cancel { get; set; }
    }

    public class Register : BaseClass
    {
        [JsonPropertyName("Form_32_to_32_fill_32_in")]
        public FormToFillIn? FormToFillIn { get; set; }

        [JsonPropertyName("Buttons")]
        public Buttons? Buttons { get; set; }
    }

    public class ResponseData : BaseClass
    {
        [JsonPropertyName("Login")]
        public Login? Login { get; set; }

        [JsonPropertyName("Register")]
        public Register? Register { get; set; }
    }
}
