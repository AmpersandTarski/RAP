using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TechTalk.SpecFlow.CommonModels;
using System.Text.Json;
using SpecFlowRAP.Specs;

namespace SpecFlowRAP.StepDefinitions
{
    public sealed class Respons
    {

        public int getNumberOfRapArrayElements(string result)
        {
            // Deserialize the JSON array
            RapArrClass[]? deserializedArray = JsonSerializer.Deserialize<RapArrClass[]>(result);
            int numberOfArrayElements = 0;

            // Output the deserialized array
            if (deserializedArray is not null)
            {
                foreach (RapArrClass item in deserializedArray)
                {
                    Console.WriteLine($"id: {item._id_}, label: {item._label_}, path: {item._path_} ");
                    numberOfArrayElements += 1;
                }
            }
            return numberOfArrayElements;
        }


        public int getNumberOfNavArrayElements(HttpClient client, string result)
        {
            int numberOfArrayElements = 0;
            try
            {
                // Deserialize the JSON array
                RapDictClass[]? jsonObject = JsonSerializer.Deserialize<RapDictClass[]>(result);

                // Output the deserialized array
                if (jsonObject is not null)
                {
                    foreach (RapDictClass item in jsonObject)
                    {
                        Console.WriteLine($"id: {item._id_}, label: {item._label_}, path: {item._path_} ");
                        numberOfArrayElements += 1;
                    }
                }

            }
            catch (Exception e)
            {
                // Output any exception that occurred during the request
                Console.WriteLine($"Request exception: {e.Message}");
                return -1;
            }
            return numberOfArrayElements;
        }

        public int getRapArrJsonObject(string result, string errstring)
        {
            if (result.Length == 0)
            {
                Console.WriteLine("Error in " + errstring + ".");
                return -1;
            }
            // Deserialize the JSON array
            RapArrClass? rapArrClass = JsonSerializer.Deserialize<RapArrClass>(result);

            // Output the deserialized array
            if (rapArrClass is not null)
            {
                Console.WriteLine($"id: {rapArrClass._id_}, label: {rapArrClass._label_}, path: {rapArrClass._path_} ");
            }
            return 123;
        }

        public int getRepliedListLength(string result, string logmsg)
        {
            int resultInt = -1;
            if (result.Length == 0)
                Console.WriteLine("Error in " + logmsg + ".");
            else
            {
                resultInt = getNumberOfRapArrayElements(result);
            }
            return resultInt;
        }
    }
}
