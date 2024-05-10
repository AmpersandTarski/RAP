using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowRAP.StepDefinitions
{
    public sealed class Request
    {
        public static async Task<string> requestMessage(HttpClient client, string url)
        {
            try
            {
                HttpResponseMessage response = await client.GetAsync(url);

                // Check if the request was successful
                if (response.IsSuccessStatusCode)
                {
                    // Read the response content as a string
                    string responseBody = await response.Content.ReadAsStringAsync();

                    // Output the response body
                    Console.WriteLine("Response van requestMessage: ");
                    Console.WriteLine(responseBody);
                    return responseBody;
                }
                else
                {
                    // Output the status code if the request was not successful
                    Console.WriteLine($"Failed to get data. Status code: {response.StatusCode}");
                    return "";
                }
            }
            catch (HttpRequestException e)
            {
                // Output any exception that occurred during the request
                Console.WriteLine($"Request exception: {e.Message}");
                return "";
            }
        }
    }
}
