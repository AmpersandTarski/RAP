using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowRAP.StepDefinitions
{
    using Microsoft.Extensions.DependencyInjection;
    using System;
    using System.Net.Http;

    public static class DIContainer
    {
        private static ServiceProvider? _serviceProvider;

        public static void ConfigureServices()
        {
            var serviceCollection = new ServiceCollection();

            // Register HttpClient as a singleton
            serviceCollection.AddSingleton<HttpClient>();

            _serviceProvider = serviceCollection.BuildServiceProvider();
        }

        public static T GetService<T>()
        {
            if (_serviceProvider == null)
            {
                throw new InvalidOperationException("Services not configured. Call ConfigureServices first.");
            }
            return _serviceProvider.GetService<T>();
        }
    }
}
