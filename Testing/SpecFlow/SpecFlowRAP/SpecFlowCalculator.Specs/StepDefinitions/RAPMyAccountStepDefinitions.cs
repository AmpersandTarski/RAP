
using Microsoft.VisualStudio.TestPlatform.ObjectModel.DataCollection;
using SpecFlowRAP.Specs.Data;
using System.Text.Json;

namespace SpecFlowRAP.StepDefinitions
{
    [Binding]
    public sealed class RAPMyAccountStepDefinitions : StepsBase
    {
        readonly FeatureContext _featureContext;
        public RAPMyAccountStepDefinitions(FeatureContext featureContext)
        {
            _featureContext = featureContext;
        }
        private UriBuilder uriBuilder = UriBuilderSingleton.Instance;
        private int _result;
        string basePath = "/api/v1/resource";

        // For additional details on SpecFlow hooks see http://go.specflow.org/doc-hooks

        [Given("i go to MyAccount")]
        public async Task GivenIGoToMyAccount()
        {
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/MyAccount");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            string body = await resp.Content.ReadAsStringAsync();
            Myaccountdata? respons = JsonSerializer.Deserialize<Myaccountdata>(body);
            _result = (int)resp.StatusCode;
        }


        [When("i change my password")]
        public async Task WhenIChangeMyPassword()
        {
            // Het wijzigen van het wachtwoord in RAP werkt niet. De test is ook niet af
            // Hiervoor is een ticket aangemaakt. "As a RAP-user, I want to be able to change my password"
            string sessionId = _featureContext.Get<string>("PHPsessid");
            string pathlocation_pasw = "/Login/" + sessionId + "/Login/" + sessionId + "/Password";
            string pathlocation_name = "/Login/" + sessionId + "/Login/" + sessionId + "/Login/property";
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/MyAccount");
            Dictionary<string, object>[] accountData = new Dictionary<string, object>[2];
            accountData[0] = new Dictionary<string, object>
            {
                { "op", "replace" },
                { "path", pathlocation_pasw },
                { "value", "welkom" }
            };
            accountData[1] = new Dictionary<string, object>
            {
                { "op", "replace" },
                { "path", pathlocation_name },
                { "value", true }
            };
            HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            _result = (int)resp.StatusCode;
        }
    }
}