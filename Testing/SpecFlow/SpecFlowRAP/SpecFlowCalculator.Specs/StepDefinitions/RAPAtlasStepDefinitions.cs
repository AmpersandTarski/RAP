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
    public class RAPAtlasStepDefinitions : StepsBase
    {
        readonly FeatureContext _featureContext;
        public RAPAtlasStepDefinitions(FeatureContext featureContext)
        {
            _featureContext = featureContext;
        }

        private UriBuilder uriBuilder = UriBuilderSingleton.Instance;
        private int _result;
        string basePath = "/api/v1/resource";
        //private RAPState state;

        //[BeforeTestRun]
        //[Given("i reinstall the application")]
        //public async Task GivenIReinstallTheApplication()
        //{
        //    uriBuilder.Host = "localhost";
        //    uriBuilder.Fragment = "";
        //    uriBuilder.Path = "api/v1/admin/installer";
        //    uriBuilder.Query = "defaultPop=true";
        //    _featureContext.Set("NOT_REGISTERED", "Status");
        //    HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
        //    // Get content of respons just for illustration.
        //    string body = await resp.Content.ReadAsStringAsync();
        //    Reinstalldata? installinfo = JsonSerializer.Deserialize<Reinstalldata>(body);
        //}


        //[Given("i need a session id of RAP")]
        //public async Task GivenINeedASessionIdOfRAP()
        //{
        //    uriBuilder.Fragment = "";
        //    uriBuilder.Path = basePath + "/SESSION/1/Login";
        //    uriBuilder.Host = "localhost";
        //    uriBuilder.Query = "";
        //    HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
        //    // Save PHPsessionId in _featureContext for later use
        //    string body = await resp.Content.ReadAsStringAsync();
        //    ResponseData? respons = JsonSerializer.Deserialize<ResponseData>(body);
        //    string? id = respons._id_;
        //    _featureContext.Set(id, "PHPsessid");
        //    _result = (int)resp.StatusCode;
        //}


        //[Given("i need to see the register button")]
        //public async Task GivenINeedToSeeTheRegisterButton()
        //{
        //    //api/v1/resource/SESSION/1/Login       //RegisterForAccount werkt, maar eerst inloggen
        //    uriBuilder.Fragment = "";
        //    uriBuilder.Host = "localhost";
        //    string state = _featureContext.Get<string>("Status");
        //    string sessionId = _featureContext.Get<string>("PHPsessid");
        //    uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
        //    if (state.Equals("NOT_REGISTERED"))
        //    {
        //        HttpResponseMessage resp = await Request.RegisterForAccount(client, uriBuilder.Uri.AbsoluteUri, sessionId);
        //        string body = await resp.Content.ReadAsStringAsync();
        //        ResponseData? rapArrClass = JsonSerializer.Deserialize<ResponseData>(body);
        //        _featureContext.Set("BUSY_REGISTERING", "Status");
        //    }

        //}

        //[Given("i need a register id of RAP")]
        //public async Task GivenINeedARegisterIdOfRAP()
        //{
        //    uriBuilder.Fragment = "";
        //    uriBuilder.Path = basePath + "/SESSION/1/Login";
        //    uriBuilder.Host = "localhost";
        //    uriBuilder.Query = "";
        //    HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
        //    string body = await resp.Content.ReadAsStringAsync();
        //    ResponseData? respons = JsonSerializer.Deserialize<ResponseData>(body);
        //    // Save RegisterId in _featureContext for later use
        //    Register? register = respons.Register;
        //    string? id = register._id_;
        //    _featureContext.Set(id, "Registerid");
        //    //_result = (int)resp.StatusCode;
        //}

        //[When("i fill in my userid")]
        //public async Task WhenIFillInMyUserid()
        //{
        //    uriBuilder.Fragment = "";
        //    uriBuilder.Host = "localhost";
        //    string state = _featureContext.Get<string>("Status");
        //    string sessionId = _featureContext.Get<string>("PHPsessid");
        //    string registerId = _featureContext.Get<string>("Registerid");
        //    uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
        //    string pathlocation = "/Login/" + sessionId + "/Register/" + registerId + "/Form_32_to_32_fill_32_in/Userid_32__40__42__41_";
        //    Dictionary<string, object>[] accountData = new Dictionary<string, object>[1];
        //    accountData[0] = new Dictionary<string, object>
        //    {
        //        { "op", "replace" },
        //        { "path", pathlocation },
        //        { "value", "Bertus" }
        //    };
        //    HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
        //    // Get content of respons just for illustration.
        //    string body = await resp.Content.ReadAsStringAsync();
        //    PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
        //    uriBuilder.Fragment = "";
        //}

        //[When("i fill in my password and name")]
        //public async Task WhenIFillInMyPasswordAndName()
        //{
        //    uriBuilder.Host = "localhost";
        //    string state = _featureContext.Get<string>("Status");
        //    string sessionId = _featureContext.Get<string>("PHPsessid");
        //    string registerId = _featureContext.Get<string>("Registerid");
        //    uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
        //    string pathlocation_pasw = "/Login/" + sessionId + "/Register/" + registerId + "/Form_32_to_32_fill_32_in/Password_32__40__42__41_";
        //    string pathlocation_name = "/Login/" + sessionId + "/Register/" + registerId + "/Form_32_to_32_fill_32_in/Your_32_name";
        //    Dictionary<string, object>[] accountData = new Dictionary<string, object>[2];
        //    accountData[0] = new Dictionary<string, object>
        //    {
        //        { "op", "replace" },
        //        { "path", pathlocation_pasw },
        //        { "value", "welkom" }
        //    };
        //    accountData[1] = new Dictionary<string, object>
        //    {
        //        { "op", "replace" },
        //        { "path", pathlocation_name },
        //        { "value", "Bertje" }
        //    };
        //    HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
        //    // Get content of respons just for illustration.
        //    string body = await resp.Content.ReadAsStringAsync();
        //    PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
        //}


        //[When("i create my account")]
        //public async Task WhenICreateMyAccount()
        //{
        //    uriBuilder.Fragment = "";
        //    uriBuilder.Host = "localhost";
        //    string state = _featureContext.Get<string>("Status");
        //    string sessionId = _featureContext.Get<string>("PHPsessid");
        //    string registerId = _featureContext.Get<string>("Registerid");
        //    uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
        //    string pathlocation = "/Login/" + sessionId + "/Register/" + registerId + "/Buttons/Create_32_account/property";
        //    Dictionary<string, object>[] accountData = new Dictionary<string, object>[1];
        //    accountData[0] = new Dictionary<string, object>
        //    {
        //        { "op", "replace" },
        //        { "path", pathlocation },
        //        { "value", true }
        //    };
        //    HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
        //    // Get content of respons just for illustration.
        //    string body = await resp.Content.ReadAsStringAsync();
        //    PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
        //    _result = (int)resp.StatusCode;
        //}


        [BeforeScenario("@FeatureB")]
        public void BeforeScenarioFeatureB()
        {
            Console.WriteLine($"BeforeScenarioFeatureB");
        }

        //[When("i log out")]
        //public async Task WhenILogOut()
        //{
        //    uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Logout");
        //    HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
        //    string body = await resp.Content.ReadAsStringAsync();
        //    ResponseData? rapArrClass = JsonSerializer.Deserialize<ResponseData>(body);
        //}

        //[When("i confirm my log out")]
        //public async Task WhenIConfirmMyLogOut()
        //{
        //    string sessionId = _featureContext.Get<string>("PHPsessid");
        //    uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Logout" + sessionId);
        //    Dictionary<string, object>[] logoutData = new Dictionary<string, object>[1];
        //    logoutData[0] = new Dictionary<string, object>
        //    {
        //        { "op", "replace" },
        //        { "path", "/Logout/property" },
        //        { "value", true }
        //    };
        //    HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, logoutData);
        //    // Get content of respons just for illustration.
        //    string body = await resp.Content.ReadAsStringAsync();
        //    Logoutdata? logoutClass = JsonSerializer.Deserialize<Logoutdata>(body);
        //}

        //[When("i try to login")]
        //public async Task WhenITryToLogin()
        //{
        //    string sessionId = _featureContext.Get<string>("PHPsessid");
        //    string pathlocation_pasw = "/Login/" + sessionId + "/Login/" + sessionId + "/Password";
        //    string pathlocation_name = "/Login/" + sessionId + "/Login/" + sessionId + "/Login/property";
        //    uriBuilder.Path = string.Join("/", basePath, "SESSION/1");
        //    Dictionary<string, object>[] accountData = new Dictionary<string, object>[2];
        //    accountData[0] = new Dictionary<string, object>
        //    {
        //        { "op", "replace" },
        //        { "path", pathlocation_pasw },
        //        { "value", "welkom" }
        //    };
        //    accountData[1] = new Dictionary<string, object>
        //    {
        //        { "op", "replace" },
        //        { "path", pathlocation_name },
        //        { "value", true }
        //    };
        //    HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, accountData);
        //    // Get content of respons just for illustration.
        //    string body = await resp.Content.ReadAsStringAsync();
        //    PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
        //    _result = (int)resp.StatusCode;

        //}

        [Then("the RAP result should be (.*)")]
        public void ThenTheRAPResultShouldBe(int result)
        {
            _result.Should().Be(result);
        }

        [Given("i do have an account")]
        //http://localhost/api/v1/resource/SESSION/1/MyAccount
        public async Task GivenIDoHaveAnAccount()
        {
            string state = _featureContext.Get<string>("Status");
            if (state.Equals("REGISTERED"))
            {
                uriBuilder.Host = "localhost";
                HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
                _result = (int)resp.StatusCode;
            }
        }



        [Then("the result should be (.*)")]
        public void ThenTheResultShouldBe(int result)
        {
            _result.Should().Be(result);
        }



        [Given("i check my atlas")]
        public async Task GivenICheckMyAtlas()
        {
            // http://localhost/api/v1/resource/SESSION/1/Atlas
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Atlas");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            string body = await resp.Content.ReadAsStringAsync();
            List<Atlasdata>? atlas = JsonSerializer.Deserialize<List<Atlasdata>>(body);

            // Save the Id's for all concepts, like Student, Module, SESSION, etc.
            string? context_label = atlas?[0]._EMPTY_?.context?._label_;
            _featureContext.Set(atlas?[0]._EMPTY_?.context?._id_, "context_" + context_label?.ToLower());
            string? properties_label = atlas?[0]._EMPTY_?.properties?[0]._label_;
            _featureContext.Set(atlas?[0]._EMPTY_?.properties?[0]._id_, "properties_" + properties_label?.ToLower());
            for (int i = 0; i < atlas?[0]._EMPTY_?.concepts?.Count; i++)
            {
                string? concepts_label = atlas?[0]._EMPTY_?.concepts?[i]._label_;
                _featureContext.Set(atlas?[0]._EMPTY_?.concepts?[i]._id_, "concept_" + concepts_label?.ToLower());
            }
            // Save the Id's for all rules, like "TOT takes[Student*Course]" and "ModuleEnrollment".
            for (int i = 0; i < atlas?[0]?._EMPTY_?.rules?.Count; i++)
            {
                string? rules_label = atlas?[0]._EMPTY_?.rules?[i]._label_?.Split(" ")[0];
                _featureContext.Set(atlas?[0]._EMPTY_?.rules?[i]._id_, "rule_" + rules_label?.ToLower());
            }
            // Save the Id's for all relations, like takes and isPartOf, isEnrolledFor.
            for (int i = 0; i < atlas?[0]._EMPTY_?.relations?.Count; i++)
            {
                string? relation_label = atlas?[0]._EMPTY_?.relations?[i]._label_?.Split("[")[0];
                _featureContext.Set(atlas?[0]._EMPTY_?.relations?[i]._id_, "relation_" + relation_label?.ToLower());
            }
            // Save the Id's for all patterns, like Courses.
            for (int i = 0; i < atlas?[0]._EMPTY_?.patterns?.Count; i++)
            {
                string? pattern_label = atlas?[0]._EMPTY_?.patterns?[i]._label_;
                _featureContext.Set(atlas?[0]._EMPTY_?.patterns?[i]._id_, "pattern_" + pattern_label?.ToLower());
            }
        }

        [When("i check the concept course")]
        public async Task WhenICheckTheConceptCourse()
        {
            // http://localhost/api/v1/resource/Concept/Concept_36a30387-d780-47bd-b7e1-105cbc33f9e3/Concept
            string course = _featureContext.Get<string>("concept_course");
            uriBuilder.Path = string.Join("/", basePath, "Concept/" + course + "/Concept");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Conceptdata? atlas = JsonSerializer.Deserialize<Conceptdata>(body);
            _result = (int)resp.StatusCode;
        }


        [When("i check the concept student")]
        public async Task WhenICheckTheConceptStudent()
        {
            // http://localhost/api/v1/resource/Concept/Concept_36a30387-d780-47bd-b7e1-105cbc33f9e3/Concept
            string course = _featureContext.Get<string>("concept_student");
            uriBuilder.Path = string.Join("/", basePath, "Concept/" + course + "/Concept");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Conceptdata? atlas = JsonSerializer.Deserialize<Conceptdata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the concept module")]
        public async Task WhenICheckTheConceptModule()
        {
            // http://localhost/api/v1/resource/Concept/Concept_36a30387-d780-47bd-b7e1-105cbc33f9e3/Concept
            string module = _featureContext.Get<string>("concept_module");
            uriBuilder.Path = string.Join("/", basePath, "Concept/" + module + "/Concept");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Conceptdata? atlas = JsonSerializer.Deserialize<Conceptdata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the concept session")]
        public async Task WhenICheckTheConceptSession()
        {
            // http://localhost/api/v1/resource/Concept/Concept_36a30387-d780-47bd-b7e1-105cbc33f9e3/Concept
            string session = _featureContext.Get<string>("concept_session");
            uriBuilder.Path = string.Join("/", basePath, "Concept/" + session + "/Concept");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Conceptdata? atlas = JsonSerializer.Deserialize<Conceptdata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the concept one")]
        public async Task WhenICheckTheConceptOne()
        {
            // http://localhost/api/v1/resource/Concept/Concept_36a30387-d780-47bd-b7e1-105cbc33f9e3/Concept
            string one = _featureContext.Get<string>("concept_one");
            uriBuilder.Path = string.Join("/", basePath, "Concept/" + one + "/Concept");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Conceptdata? atlas = JsonSerializer.Deserialize<Conceptdata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the rule moduleenrollment")]
        public async Task WhenICheckTheRuleModuleEnrollment()
        {
            // http://localhost/api/v1/resource/Rule/PropertyRule_4e579c72-08eb-46ea-9719-1bba89a5c8af/Rule
            string ModuleEnrollment = _featureContext.Get<string>("rule_moduleenrollment");
            uriBuilder.Path = string.Join("/", basePath, "Rule/" + ModuleEnrollment + "/Rule");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Ruledata? atlas = JsonSerializer.Deserialize<Ruledata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the rule tot")]
        public async Task WhenICheckTheRuleTot()
        {
            // http://localhost/api/v1/resource/Rule/PropertyRule_4e579c72-08eb-46ea-9719-1bba89a5c8af/Rule
            string tot = _featureContext.Get<string>("rule_tot");
            uriBuilder.Path = string.Join("/", basePath, "Rule/" + tot + "/Rule");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Ruledata? atlas = JsonSerializer.Deserialize<Ruledata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the relation takes")]
        public async Task WhenICheckTheRelationTakes()
        {
            // http://localhost/api/v1/resource/Relation/PropertyRule_4e579c72-08eb-46ea-9719-1bba89a5c8af/Relation
            string takes = _featureContext.Get<string>("relation_takes");
            uriBuilder.Path = string.Join("/", basePath, "Relation/" + takes + "/Relation");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Relationdata? atlas = JsonSerializer.Deserialize<Relationdata>(body);
            _result = (int)resp.StatusCode;
        }


        [When("i check the relation ispartof")]
        public async Task WhenICheckTheRelationIspartof()
        {
            // http://localhost/api/v1/resource/Relation/PropertyRule_4e579c72-08eb-46ea-9719-1bba89a5c8af/Relation
            string ispartof = _featureContext.Get<string>("relation_ispartof");
            uriBuilder.Path = string.Join("/", basePath, "Relation/" + ispartof + "/Relation");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Relationdata? atlas = JsonSerializer.Deserialize<Relationdata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the relation IsEnrolledFor")]
        public async Task WhenICheckTheRelationIsEnrolledFor()
        {
            string isenrolledfor = _featureContext.Get<string>("relation_isenrolledfor");
            uriBuilder.Path = string.Join("/", basePath, "Relation/" + isenrolledfor + "/Relation");

            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            Relationdata? atlas = JsonSerializer.Deserialize<Relationdata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the properties tot")]
        public async Task WhenICheckThePropertiesTot()
        {
            string properties_tot = _featureContext.Get<string>("properties_tot takes[student*course]");
            uriBuilder.Path = string.Join("/", basePath, "PropertyRule/" + properties_tot + "/PropRule");

            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            //Propertiesdata? atlas = JsonSerializer.Deserialize<Propertiesdata>(body);
            _result = (int)resp.StatusCode;
        }

        [When("i check the context Enrolledment")]
        public async Task WhenICheckTheContextEnrollment()
        {
            string context_enrollment = _featureContext.Get<string>("context_enrollment");
            uriBuilder.Path = string.Join("/", basePath, "Context/" + context_enrollment + "/Context");

            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            //Propertiesdata? atlas = JsonSerializer.Deserialize<Propertiesdata>(body);
            _result = (int)resp.StatusCode;

        }
    }
}

