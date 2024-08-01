using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using SpecFlowRAP.Specs;
using System.Text.Json;
using System.Collections;
using SpecFlowRAP.Specs.Data;



namespace SpecFlowRAP
{
    public sealed class Request
    {
        public static async Task<HttpResponseMessage> requestMessage(HttpClient client, string url)
        {
            HttpResponseMessage response = new HttpResponseMessage();
            try
            {
                response = await client.GetAsync(url);

                // Check if the request was successful
                if (response.IsSuccessStatusCode)
                {
                    // Read the response content as a string
                    string responseBody = await response.Content.ReadAsStringAsync();

                    // Output the response body
                    Console.WriteLine("Response van requestMessage: ");
                    Console.WriteLine(responseBody);
                }
                else
                {
                    // Output the status code if the request was not successful
                    Console.WriteLine($"Failed to get data. Status code: {response.StatusCode}");
                }
                return response;
            }
            catch (HttpRequestException e)
            {
                // Output any exception that occurred during the request
                Console.WriteLine($"Request exception: {e.Message}");
                //response.tatusCode = 404;
                return response;
            }
        }

        //        public static async Task<int> putMessage(HttpClient client, string url, object data)
        public static async Task<HttpResponseMessage> putMessage(HttpClient client, string url, object data)
        {

            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(data);

            // Maak een HttpRequestMessage met de JSON-gegevens en de content type header
            var request = new HttpRequestMessage(HttpMethod.Put, url);
            request.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");

            // Voer de request uit en wacht op de response
            HttpResponseMessage response = await client.SendAsync(request);

            // Controleer of de request succesvol was
            if (response.IsSuccessStatusCode)
            {
                Console.WriteLine("Script succesvol toegevoegd.");
            }
            else
            {
                Console.WriteLine("Er is een fout opgetreden bij het toevoegen van een script: " + response.StatusCode);
            }
            return response;
        }


        public static async Task<HttpResponseMessage> patchMessage(HttpClient client, string url, object[] data)
        {
            object[] arrdata = data;
            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(data);

            // Maak een HttpRequestMessage met de JSON-gegevens en de content type header
            var request = new HttpRequestMessage(HttpMethod.Patch, url);
            request.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");

            // Voer de request uit en wacht op de response
            HttpResponseMessage response = await client.SendAsync(request);
            string responseBody = await response.Content.ReadAsStringAsync();

            // Controleer of de request succesvol was
            if (response.IsSuccessStatusCode)
            {
                Console.WriteLine("Script succesvol toegevoegd.");
            }
            else
            {
                Console.WriteLine("Er is een fout opgetreden bij het toevoegen van een script: " + response.StatusCode);
            }
            return response;
        }

        public static async Task<HttpResponseMessage> postMessage(HttpClient client, string url, object data)
        {

            string jsonData = Newtonsoft.Json.JsonConvert.SerializeObject(data);

            // Maak een HttpRequestMessage met de JSON-gegevens en de content type header
            var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");

            // Voer de request uit en wacht op de response
            HttpResponseMessage response = await client.SendAsync(request);

            // Controleer of de request succesvol was
            if (response.IsSuccessStatusCode)
            {
                Console.WriteLine("Script succesvol toegevoegd.");
            }
            else
            {
                Console.WriteLine("Er is een fout opgetreden bij het toevoegen van een script: " + response.StatusCode);
            }
            return response;
        }

        public static async Task<HttpResponseMessage> getRegisterId(HttpClient client, string url)
        {
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            };
            HttpResponseMessage resp = await Request.requestMessage(client, url);
            //string pathlocation = "/Login/" + sessId + "/Register/" + sessId + "/Form_32_to_32_fill_32_in/Userid_32__40__42__41_";
            string body = await resp.Content.ReadAsStringAsync();
            ResponseData? responsedata = JsonSerializer.Deserialize<ResponseData>(body, options);
            string? id = responsedata?.Register?._id_;
            return resp;
        }

        public static async Task<HttpResponseMessage> RegisterForAccount(HttpClient client, string url, string? sessId)
        {
            string pathlocation = "/Login/" + sessId + "/Login/" + sessId + "/_32__32__32_/" + sessId + "/Register/property";
            Dictionary<string, object>[] accountData = new Dictionary<string, object>[1];
            accountData[0] = new Dictionary<string, object>
            {
                { "op", "replace" },
                { "path", pathlocation },
                { "value", true }
            };
            HttpResponseMessage resp = await patchMessage(client, url, accountData);
            string body = await resp.Content.ReadAsStringAsync();
            PatchSessiondata? responsedata = JsonSerializer.Deserialize<PatchSessiondata>(body);
            // Account Id opslaan in _featureContext
            return resp; //.StatusCode;
        }

        public static async Task<HttpResponseMessage> CreateAccount(HttpClient client, string url)
        {
            // Vervang de URL door de juiste endpoint van je API
            //string apiUrl = "http://localhost/api/v1/resource/SESSION/1";

            // Bereid de gegevens voor die je wilt verzenden
            var accountData = new
            {
                userid = "Piet3",
                password = "welkom",
                person = "Pietd3"

            };
            HttpResponseMessage resp = await putMessage(client, url, accountData);
            // Account Id opslaan in _featureContext
            return resp; // (int)resp.StatusCode;
        }


        public static async Task<HttpResponseMessage> scriptOpdracht(HttpClient client, UriBuilder uriBuilder, string path, object value)
        {
            uriBuilder.Host = "localhost";
            Dictionary<string, object>[] scriptData = new Dictionary<string, object>[1];
            scriptData[0] = new Dictionary<string, object>
            {
                { "op", "replace" },
                { "path", path },
                { "value", value }
            };
            HttpResponseMessage resp = await Request.patchMessage(client, uriBuilder.Uri.AbsoluteUri, scriptData);
            return resp;
        }

    }
}

