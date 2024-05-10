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
using System.Formats.Asn1;
using System.Data;


namespace SpecFlowRAP.StepDefinitions 
{
    [Binding]
    internal class RAPStepDefinitions
    {
        private HttpClient client = HttpClientSingleton.Instance;
        private UriBuilder uriBuilder = UriBuilderSingleton.Instance;
        private int _result;
        string basePath = "/api/v1/resource";
        private Respons respons = new Respons();


        [Given("i just ran the installer of rap")]
        public async Task GivenIJustRanTheInstallerOfRap()
        {
            // http://localhost/api/v1/admin/installer?defaultPop=true
            uriBuilder.Fragment = "/admin/installer";
            uriBuilder.Host     = "localhost";
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            if (result.Length == 0)
                Console.WriteLine("Error in GivenIJustRanTheInstallerOfRap.");
            else
                Console.WriteLine("GivenIJustRanTheInstallerOfRap.");
        }

        [Given("i am in the welcome screen of rap")]
        public async Task GivenIAmInTheWelcomeScreenOfRap()
        {
            uriBuilder.Fragment = "/prototype/welcome";
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            if (result.Length == 0)
                Console.WriteLine("Error in GivenIAmInTheWelcomeScreenOfRap.");
            else
                Console.WriteLine("GivenIAmInTheWelcomeScreenOfRap.");
        }

        [Given("i am in the overview screen of rap")]
        public async Task GivenIAmInTheOverviewScreenOfRap()
        {
            uriBuilder.Fragment = "/Overview";
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            if (result.Length == 0)
                Console.WriteLine("Error in GivenIAmInTheOverviewScreenOfRap.");
            else
                Console.WriteLine("GivenIAmInTheOverviewScreenOfRap.");
        }

        [Given("i am in the list all interfaces screen of rap")]
        public async Task GivenIAmInTheListAllInterfacesScreenOfRap()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/List_32_all_32_interfaces
            uriBuilder.Path     = string.Join("/", basePath, "SESSION/1/List_32_all_32_interfaces");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            if (result.Length == 0)
                Console.WriteLine("Error in GivenIAmInTheOverviewScreenOfRap.");
            else
                Console.WriteLine("GivenIAmInTheOverviewScreenOfRap.");
        }


        [When("i try to login")]
        public async Task WhenITryToLogin()
        {
            // http://localhost/api/v1/resource/SESSION/1/Login
            uriBuilder.Host     = "localhost";
            uriBuilder.Path     = string.Join("/", basePath, "SESSION/1/Login");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRapArrJsonObject(result, "WhenITryToLogin");
            // Na succesvolle login komt er een speciaal Json-bericht terug met login-informatie
            // Is het zinvol om dit te controleren?
        }

        [When("i request the overview page")]
        public async Task WhenIRequestTheOverviewPage()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/Overview
            uriBuilder.Path     = string.Join("/", basePath, "SESSION/1/Overview");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRapArrJsonObject(result, "WhenIRequestTheOverviewPage");
        }

        [When("i request the listallinterfaces page")]
        public async Task WhenIRequestTheListallinterfacesPage()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/List_32_all_32_interfaces
            uriBuilder.Path     = string.Join("/", basePath, "SESSION/1/List_32_all_32_interfaces");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRepliedListLength(result, "WhenIRequestTheListallinterfacesPage");
        }

        [When("i edit the interface")]
        public async Task WhenIEditTheInterface()
        {
            // http://stjohn.localhost/api/v1/resource/PF__Interface/Edit_32_interface/Edit_32_interface
            uriBuilder.Path     = string.Join("/", basePath, "PF__Interface/Edit_32_interface/Edit_32_interface");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRapArrJsonObject(result, "WhenIEditTheInterface");
        }

        [When("i edit a menu item")]
        public async Task WhenIEditAMenuItem()
        {
            // http://stjohn.localhost/api/v1/resource/PF__Interface/Edit_32_menu_32_item/Edit_32_interface
            uriBuilder.Path     = string.Join("/", basePath, "PF__Interface/Edit_32_menu_32_item/Edit_32_interface");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRapArrJsonObject(result, "WhenIEditAMenuItem");
        }

        [When("i request the editnavigationmenu page")]
        public async Task WhenIRequestTheEditnavigationmenuPage()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/Edit_32_navigation_32_menu
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Edit_32_navigation_32_menu");
            string result = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            if (result.Length == 0)
            {
                Console.WriteLine("Error in WhenIRequestTheEditnavigationmenuPage.");
                _result = 0;
            }
            else
            {
                _result = respons.getNumberOfNavArrayElements(client, result);
            }
        }

        [When("i request the sub listallinterfaces page")]
        public async Task WhenIRequestTheSubListallinterfacesPage()
        {
            //http://stjohn.localhost/api/v1/resource/PF__Interface/List_32_all_32_interfaces/Edit_32_interface
            uriBuilder.Path = string.Join("/", basePath, "PF__Interface/List_32_all_32_interfaces/Edit_32_interface");
            string result = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRapArrJsonObject(result, "WhenIRequestTheSubListallinterfacesPage");
        }

        [When("i request for courses")]
        public async Task WhenIRequestForCourses()
        {
            // http://stjohn.localhost/api/v1/resource/Course
            uriBuilder.Path     = string.Join("/", basePath, "Course");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRepliedListLength(result, "WhenIRequestForCourses");
        }

        [When("i request for students")]
        public async Task WhenIRequestForStudents()
        {
            // http://stjohn.localhost/api/v1/resource/Student
            uriBuilder.Path     = string.Join("/", basePath, "Student");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRepliedListLength(result, "WhenIRequestForStudents");
        }

        [When("i request for modules")]
        public async Task WhenIRequestForModules()
        {
            // http://stjohn.localhost/api/v1/resource/Module
            uriBuilder.Path     = string.Join("/", basePath, "Module");
            string result       = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = respons.getRepliedListLength(result, "WhenIRequestForModules");
        }


        [Then("the result is (.*)")]
        public void ThenTheResultIs(int result)
        {
            _result.Should().Be(result);
        }
    }

}

