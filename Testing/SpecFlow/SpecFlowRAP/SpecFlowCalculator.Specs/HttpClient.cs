
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
