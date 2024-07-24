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
using SpecFlowRAP;


namespace SpecFlowRAPprototype.StepDefinitions
{
    [Binding]
    internal class SpecFlowRAPprototype
    {
        private HttpClient client = HttpClientSingleton.Instance;
        private UriBuilder uriBuilder = UriBuilderSingleton.Instance;
        private int _result;
        string basePath = "/api/v1/resource";


        [Given("i just ran the installer of prototype")]
        public async Task GivenIJustRanTheInstallerOfRap()
        {
            // http://localhost/api/v1/admin/installer?defaultPop=true
            uriBuilder.Fragment = "/admin/installer";
            uriBuilder.Host = "localhost";
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //if (result.Length == 0)
            //    Console.WriteLine("Error in GivenIJustRanTheInstallerOfRap.");
            //else
            //    Console.WriteLine("GivenIJustRanTheInstallerOfRap.");
        }

        [Given("i am in the welcome screen of prototype")]
        public async Task GivenIAmInTheWelcomeScreenOfRap()
        {
            uriBuilder.Fragment = "/prototype/welcome";
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //if (result.Length == 0)
            //    Console.WriteLine("Error in GivenIAmInTheWelcomeScreenOfRap.");
            //else
            //    Console.WriteLine("GivenIAmInTheWelcomeScreenOfRap.");
        }

        [Given("i am in the overview screen of prototype")]
        public async Task GivenIAmInTheOverviewScreenOfRap()
        {
            uriBuilder.Fragment = "/Overview";
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //if (result.Length == 0)
            //    Console.WriteLine("Error in GivenIAmInTheOverviewScreenOfRap.");
            //else
            //    Console.WriteLine("GivenIAmInTheOverviewScreenOfRap.");
        }

        [Given("i am in the list all interfaces screen of prototype")]
        public async Task GivenIAmInTheListAllInterfacesScreenOfRap()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/List_32_all_32_interfaces
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/List_32_all_32_interfaces");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //if (result.Length == 0)
            //    Console.WriteLine("Error in GivenIAmInTheOverviewScreenOfRap.");
            //else
            //    Console.WriteLine("GivenIAmInTheOverviewScreenOfRap.");
        }


        [When("i try to log myself in")]
        public async Task WhenITryToLogin()
        {
            // http://localhost/api/v1/resource/SESSION/1/Login
            uriBuilder.Host = "localhost";
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Login");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenITryToLogin");
        }

        [When("i request the overviewprototype page")]
        public async Task WhenIRequestTheOverviewPage()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/Overview
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Overview");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenIRequestTheOverviewPage");
        }

        [When("i request the listallinterfaces page")]
        public async Task WhenIRequestTheListallinterfacesPage()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/List_32_all_32_interfaces
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/List_32_all_32_interfaces");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRepliedListLength(result, "WhenIRequestTheListallinterfacesPage");
        }

        [When("i edit the interface")]
        public async Task WhenIEditTheInterface()
        {
            // http://stjohn.localhost/api/v1/resource/PF__Interface/Edit_32_interface/Edit_32_interface
            uriBuilder.Path = string.Join("/", basePath, "PF__Interface/Edit_32_interface/Edit_32_interface");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenIEditTheInterface");
        }

        [When("i edit a menu item")]
        public async Task WhenIEditAMenuItem()
        {
            // http://stjohn.localhost/api/v1/resource/PF__Interface/Edit_32_menu_32_item/Edit_32_interface
            uriBuilder.Path = string.Join("/", basePath, "PF__Interface/Edit_32_menu_32_item/Edit_32_interface");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenIEditAMenuItem");
        }

        [When("i request the editnavigationmenu page")]
        public async Task WhenIRequestTheEditnavigationmenuPage()
        {
            // http://stjohn.localhost/api/v1/resource/SESSION/1/Edit_32_navigation_32_menu
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Edit_32_navigation_32_menu");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //if (result.Length == 0)
            //{
            //    Console.WriteLine("Error in WhenIRequestTheEditnavigationmenuPage.");
            //    _result = 0;
            //}
            //else
            //{
            //    _result = respons.getNumberOfNavArrayElements(client, result);
            //}
        }

        [When("i request the sub listallinterfaces page")]
        public async Task WhenIRequestTheSubListallinterfacesPage()
        {
            //http://stjohn.localhost/api/v1/resource/PF__Interface/List_32_all_32_interfaces/Edit_32_interface
            uriBuilder.Path = string.Join("/", basePath, "PF__Interface/List_32_all_32_interfaces/Edit_32_interface");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenIRequestTheSubListallinterfacesPage");
        }

        [When("i request the sub overview page")]
        public async Task WhenIRequestTheSubOverviewPage()
        {
            // http://stjohn.localhost/api/v1/resource/PF__Interface/Overview/Edit_32_interface
            uriBuilder.Path = string.Join("/", basePath, "PF__Interface/Overview/Edit_32_interface");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenIRequestTheSubOverviewPage");
        }

        [When("i request the sub pf allroles page")]
        public async Task WhenIRequestTheSubPfAllrolesPage()
        {
            // http://stjohn.localhost/api/v1/resource/PF__Interface/PF__AllRoles/Edit_32_interface
            uriBuilder.Path = string.Join("/", basePath, "PF__Interface/PF__AllRoles/Edit_32_interface");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenIRequestTheSubPfAllrolesPage");
        }

        [When("i request the sub pf menuitems page")]
        public async Task WhenIRequestTheSubPfMenuitemsPage()
        {
            // http://stjohn.localhost/api/v1/resource/PF__Interface/PF__MenuItems/Edit_32_interface
            uriBuilder.Path = string.Join("/", basePath, "PF__Interface/PF__MenuItems/Edit_32_interface");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRapArrJsonObject(result, "WhenIRequestTheSubPfMenuitemsPage");
        }

        [When("i request for courses")]
        public async Task WhenIRequestForCourses()
        {
            // http://stjohn.localhost/api/v1/resource/Course
            uriBuilder.Path = string.Join("/", basePath, "Course");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRepliedListLength(result, "WhenIRequestForCourses");
        }

        [When("i request for students")]
        public async Task WhenIRequestForStudents()
        {
            // http://stjohn.localhost/api/v1/resource/Student
            uriBuilder.Path = string.Join("/", basePath, "Student");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRepliedListLength(result, "WhenIRequestForStudents");
        }

        [When("i request for modules")]
        public async Task WhenIRequestForModules()
        {
            // http://stjohn.localhost/api/v1/resource/Module
            uriBuilder.Path = string.Join("/", basePath, "Module");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            _result = (int)resp.StatusCode;
            //_result = respons.getRepliedListLength(result, "WhenIRequestForModules");
        }


        [Then("the result is (.*)")]
        public void ThenTheResultIs(int result)
        {
            _result.Should().Be(result);
        }
    }

}

