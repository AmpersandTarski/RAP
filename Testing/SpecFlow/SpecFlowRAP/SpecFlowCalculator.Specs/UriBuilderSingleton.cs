using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowRAP
{
    using System;

    public sealed class UriBuilderSingleton
    {
        private static readonly Lazy<UriBuilder> lazyInstance = new Lazy<UriBuilder>(() => new UriBuilder("http", "stjohn.localhost"));

        // Private constructor to prevent instantiation outside of the class
        private UriBuilderSingleton() { }

        // Property to access the singleton instance
        public static UriBuilder Instance => lazyInstance.Value;
    }
}
