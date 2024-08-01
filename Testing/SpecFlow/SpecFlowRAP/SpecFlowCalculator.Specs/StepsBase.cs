using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowRAP.StepDefinitions
{
    public class StepsBase
    {

        public StepsBase()
        {
            client = DIContainer.GetService<HttpClient>();
        }
        protected HttpClient client { get; private set; }
        //private readonly FeatureContext _featureContext;
        //public RAPStepDefinitions(FeatureContext featureContext)
        //{
        //    _featureContext = featureContext;
        //}

    }
}
