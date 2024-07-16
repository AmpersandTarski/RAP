using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;

namespace SpecFlowRAP
{
    public class HttpClientSingleton
    {
        private static readonly Lazy<HttpClient> httpClientInstance =
            new Lazy<HttpClient>(() => new HttpClient());

        public static HttpClient Instance => httpClientInstance.Value;

        // Private constructor to prevent instantiation
        private HttpClientSingleton() { }
    }
}
