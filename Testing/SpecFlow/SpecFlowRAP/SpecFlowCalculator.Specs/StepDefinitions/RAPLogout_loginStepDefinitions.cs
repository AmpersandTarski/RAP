using SpecFlowRAP.Specs.Data;
using System.Text.Json;

namespace SpecFlowRAP.StepDefinitions
{
    [Binding]
    public sealed class RAPLogout_loginStepDefinitions : StepsBase
    {
        readonly FeatureContext _featureContext;
        public RAPLogout_loginStepDefinitions(FeatureContext featureContext)
        {
            _featureContext = featureContext;
        }
        private UriBuilder uriBuilder = UriBuilderSingleton.Instance;
        private int _result;
        string basePath = "/api/v1/resource";


        [When("i log out")]
        public async Task WhenILogOut()
        {
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Logout");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            string body = await resp.Content.ReadAsStringAsync();
            ResponseData? rapArrClass = JsonSerializer.Deserialize<ResponseData>(body);
        }

        [When("i confirm my log out")]
        public async Task WhenIConfirmMyLogOut()
        {
            string sessionId = _featureContext.Get<string>("PHPsessid");
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Logout/" + sessionId);
            Dictionary<string, object>[] logoutData = new Dictionary<string, object>[1];
            logoutData[0] = new Dictionary<string, object>
            {
                { "op", "replace" },
                { "path", "/Logout/property" },
                { "value", true }
            };
            HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, logoutData);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Logoutdata? logoutClass = JsonSerializer.Deserialize<Logoutdata>(body);
        }

        [Then("i can log myself in")]
        public async Task ThenICanLogMyselfIn()
        {
            string sessionId = _featureContext.Get<string>("PHPsessid");
            string pathlocation_pasw = "/Login/" + sessionId + "/Login/" + sessionId + "/Password";
            string pathlocation_name = "/Login/" + sessionId + "/Login/" + sessionId + "/Login/property";
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
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
            PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
            _result = (int)resp.StatusCode;
        }


        [Then("the RAP result must be (.*)")]
        public void ThenTheRAPResultMustBe(int result)
        {
            _result.Should().Be(result);
        }
    }
}