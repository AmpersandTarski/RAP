using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using SpecFlowRAP.Specs;
using System.Security.Policy;
using System.Collections;
using TechTalk.SpecFlow.CommonModels;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Formats.Asn1;
using System.Data;
using Microsoft.VisualStudio.TestPlatform.ObjectModel.DataCollection;
using FluentAssertions.Execution;
using Microsoft.VisualStudio.TestPlatform.CommunicationUtilities;
using static System.Collections.Specialized.BitVector32;
using static System.Net.Mime.MediaTypeNames;
using System.Configuration;
using System.Numerics;
using System.Reflection;
using TechTalk.SpecFlow;
using Newtonsoft.Json.Linq;
using System.IO;
using SpecFlowRAP.Specs.Data;



namespace SpecFlowRAP.StepDefinitions
{

    [Binding]
    public class RAPStepDefinitions : StepsBase
    {
        readonly FeatureContext? _featureContext;
        public RAPStepDefinitions(FeatureContext featureContext)
        {
            _featureContext = featureContext;
        }


        private UriBuilder uriBuilder = UriBuilderSingleton.Instance;
        private int _result;
        string basePath = "/api/v1/resource";
        //private RAPState state;

        [BeforeScenario("@FeatureA")]
        public void BeforeScenarioFeatureA()
        {
            Console.WriteLine($"BeforeScenarioFeatureA");

        }

        [Given("i reinstall the application")]
        public async Task GivenIReinstallTheApplication()
        {
            uriBuilder.Host = "localhost";
            uriBuilder.Fragment = "";
            uriBuilder.Path = "api/v1/admin/installer";
            uriBuilder.Query = "defaultPop=true";
            _featureContext?.Set("NOT_REGISTERED", "Status");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Reinstalldata? installinfo = JsonSerializer.Deserialize<Reinstalldata>(body);
        }


        [Given("i need a session id of RAP")]
        public async Task GivenINeedASessionIdOfRAP()
        {
            uriBuilder.Fragment = "";
            uriBuilder.Path = basePath + "/SESSION/1/Login";
            uriBuilder.Host = "localhost";
            uriBuilder.Query = "";

            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Save PHPsessionId in _featureContext for later use
            string body = await resp.Content.ReadAsStringAsync();
            ResponseData? respons = JsonSerializer.Deserialize<ResponseData>(body);
            string? id = respons?._id_;
            _featureContext?.Set(id, "PHPsessid");
            _result = (int)resp.StatusCode;
        }


        [Given("i need to see the register button")]
        public async Task GivenINeedToSeeTheRegisterButton()
        {
            //api/v1/resource/SESSION/1/Login       //RegisterForAccount werkt, maar eerst inloggen
            uriBuilder.Fragment = "";
            uriBuilder.Host = "localhost";
            string? state = _featureContext?.Get<string>("Status");
            string? sessionId = _featureContext?.Get<string>("PHPsessid");
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
            //if (state.Equals("NOT_REGISTERED"))
            //{
                HttpResponseMessage resp = await Request.RegisterForAccount(client, uriBuilder.Uri.AbsoluteUri, sessionId);
                string body = await resp.Content.ReadAsStringAsync();
                ResponseData? rapArrClass = JsonSerializer.Deserialize<ResponseData>(body);
                _featureContext?.Set("BUSY_REGISTERING", "Status");
            //}

        }


        [Given("i need a register id of RAP")]
        public async Task GivenINeedARegisterIdOfRAP()
        {
            uriBuilder.Fragment = "";
            uriBuilder.Path = basePath + "/SESSION/1/Login";
            uriBuilder.Host = "localhost";
            uriBuilder.Query = "";
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            string body = await resp.Content.ReadAsStringAsync();
            ResponseData? respons = JsonSerializer.Deserialize<ResponseData>(body);
            // Save RegisterId in _featureContext for later use
            Register? register = respons?.Register;
            string? id = register?._id_;
            _featureContext?.Set(id, "Registerid");
            //_result = (int)resp.StatusCode;
        }


        [When("i fill in my userid")]
        public async Task WhenIFillInMyUserid()
        {
            uriBuilder.Fragment = "";
            uriBuilder.Host = "localhost";
            string? state = _featureContext?.Get<string>("Status");
            string? sessionId = _featureContext?.Get<string>("PHPsessid");
            string? registerId = _featureContext?.Get<string>("Registerid");
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
            string pathlocation = "/Login/" + sessionId + "/Register/" + registerId + "/Form_32_to_32_fill_32_in/Userid_32__40__42__41_";
            Dictionary<string, object>[] accountData = new Dictionary<string, object>[1];
            accountData[0] = new Dictionary<string, object>
            {
                { "op", "replace" },
                { "path", pathlocation },
                { "value", "Bertus" }
            };
            HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
            uriBuilder.Fragment = "";
        }


        [When("i fill in my password and name")]
        public async Task WhenIFillInMyPasswordAndName()
        {
            uriBuilder.Host = "localhost";
            string? state = _featureContext?.Get<string>("Status");
            string? sessionId = _featureContext?.Get<string>("PHPsessid");
            string? registerId = _featureContext?.Get<string>("Registerid");
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
            string pathlocation_pasw = "/Login/" + sessionId + "/Register/" + registerId + "/Form_32_to_32_fill_32_in/Password_32__40__42__41_";
            string pathlocation_name = "/Login/" + sessionId + "/Register/" + registerId + "/Form_32_to_32_fill_32_in/Your_32_name";
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
                { "value", "Bertje" }
            };
            HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
        }


        [When("i create my account")]
        public async Task WhenICreateMyAccount()
        {
            uriBuilder.Fragment = "";
            uriBuilder.Host = "localhost";
            string? state = _featureContext?.Get<string>("Status");
            string? sessionId = _featureContext?.Get<string>("PHPsessid");
            string? registerId = _featureContext?.Get<string>("Registerid");
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
            string pathlocation = "/Login/" + sessionId + "/Register/" + registerId + "/Buttons/Create_32_account/property";
            Dictionary<string, object>[] accountData = new Dictionary<string, object>[1];
            accountData[0] = new Dictionary<string, object>
            {
                { "op", "replace" },
                { "path", pathlocation },
                { "value", true }
            };
            HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
            _result = (int)resp.StatusCode;
        }


        [Then("the RAP result has to be (.*)")]
        public void ThenTheRAPResultHasToBe(int result)
        {
            _result.Should().Be(result);
        }


        [AfterScenario("@FeatureA")]
        public void AfterScenarioFeatureA()
        {
            Console.WriteLine($"AfterScenarioFeatureA");

        }


        [Given("i want to add a new script")]
        public async Task ThenIWantToAddANewScript()
        {
            //Dictionary<string, object>[] data = new Dictionary<string, object>[1];
            object data = new { };
            //data[0] = { };
            uriBuilder.Host = "localhost";
            uriBuilder.Path = string.Join("/", basePath, "Script");
            HttpResponseMessage resp = await Request.postMessage(client, uriBuilder.Uri.AbsoluteUri, data);
            string body = await resp.Content.ReadAsStringAsync();
            ScriptIddata? scriptId = JsonSerializer.Deserialize<ScriptIddata>(body);
            _featureContext?.Set(scriptId?._id_, "scriptId");
            _result = (int)resp.StatusCode;
        }

        [When("i add my latest script")]
        public async Task WhenIAddMyLatestScript()
        {
            string scriptje = "CONTEXT Enrollment IN ENGLISH\r\nPURPOSE CONTEXT Enrollment\r\n{+ A complete course consists of several modules.\r\nStudents of a course can enroll for any module that is part of the course,\r\n+}\r\n\r\nPATTERN Courses\r\n-- The concepts\r\nCONCEPT Student \"Someone who wants to study at this institute\"\r\nPURPOSE CONCEPT Student\r\n{+We have to know what person studies at this institute, so the system needs to keep track of them.+}\r\nCONCEPT Course \"A complete course that prepares for a diploma\"\r\nPURPOSE CONCEPT Course\r\n{+We have to know what courses there are, so the system needs to keep track of them.+}\r\nCONCEPT Module \"An educational entity with a single exam\"\r\nPURPOSE CONCEPT Module\r\n{+We have to know what modules exist, so the system needs to keep track of them.+}\r\n\r\n-- The relations and the initial population\r\nRELATION takes [Student*Course][TOT]\r\nMEANING \"A student takes a complete course\"\r\n\r\nPOPULATION takes CONTAINS\r\n[ (\"Peter\", \"Management\")\r\n; (\"Susan\", \"Business IT\")\r\n; (\"John\", \"Business IT\")\r\n]\r\n\r\nRELATION isPartOf[Module*Course]\r\nMEANING \"A module part of a complete course\"\r\n\r\nPOPULATION isPartOf[Module*Course] CONTAINS\r\n[ (\"Finance\", \"Management\")\r\n; (\"Business Rules\", \"Business IT\")\r\n; (\"Business Analytics\", \"Business IT\")\r\n; (\"IT-Governance\", \"Business IT\")\r\n; (\"IT-Governance\", \"Management\")\r\n]\r\n\r\nRELATION isEnrolledFor [Student*Module]\r\nMEANING \"Students enroll for each module in the course separately\"\r\n\r\n-- The one rule in this model\r\nRULE ModuleEnrollment: isEnrolledFor |- takes;isPartOf~\r\nMEANING \"A student can enroll for any module that is part of the course the student takes\"\r\nMESSAGE \"Attempt to enroll student(s) for a module that is not part of the student's course.\"\r\nVIOLATION (TXT \"Student \", SRC I, TXT \" enrolled for the module \", TGT I, TXT \" which is not part of the course \", SRC I[Student];takes)\r\nENDPATTERN\r\n\r\nINTERFACE Overview : \"_SESSION\"                  cRud\r\nBOX <TABS>\r\n     [ Students : V[SESSION*Student]             cRuD\r\n       BOX <TABLE>\r\n                [ \"Student\" : I[Student]         cRud\r\n                , \"Enrolled for\" : isEnrolledFor cRUD\r\n                , \"Course\" : takes CRUD\r\n                ]\r\n     , Course : V[SESSION*Course]                cRuD\r\n       BOX <TABLE>\r\n                [ \"Course\" : I                   cRud\r\n                , \"Modules\" : isPartOf~          CRUD\r\n                ]\r\n     , Modules : V[SESSION*Module]               cRud\r\n       BOX <TABLE>\r\n                [ \"Modules\" : I                  cRuD\r\n                , \"Course\" : isPartOf            cRUd\r\n                , \"Students\" : isEnrolledFor~    CRUD\r\n                ]\r\n     ]\r\n\r\nENDCONTEXT";
            //http://localhost/api/v1/resource/Script/Script_8c65c75e-dd99-4e28-a9d3-a6bf33d6c18e/Nieuw_32_script
            string scriptId = _featureContext.Get<string>("scriptId");

            uriBuilder.Path = string.Join("/", basePath, "Script/" + scriptId + "/Nieuw_32_script");
            string path = "/Content";
            HttpResponseMessage resp = await Request.scriptOpdracht(client, uriBuilder, path, scriptje);
            string body = await resp.Content.ReadAsStringAsync();
            PatchSessiondata? scriptId2 = JsonSerializer.Deserialize<PatchSessiondata>(body);
        }

        [When("compile my latest script")]
        public async Task WhenCompileMyLatestScript()
        {
            string scriptId = _featureContext.Get<string>("scriptId");
            uriBuilder.Path = string.Join("/", basePath, "Script/" + scriptId + "/Nieuw_32_script");
            string path = "/Actual_32_info/compile/property";
            bool value = true;
            HttpResponseMessage resp = await Request.scriptOpdracht(client, uriBuilder, path, value);
            string body = await resp.Content.ReadAsStringAsync();
            PatchSessiondata? scriptId2 = JsonSerializer.Deserialize<PatchSessiondata>(body);
            _result = (int)resp.StatusCode;
        }

    }
}

