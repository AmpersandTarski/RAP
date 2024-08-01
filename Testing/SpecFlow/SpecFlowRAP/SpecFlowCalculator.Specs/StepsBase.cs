
namespace SpecFlowRAP.StepDefinitions
{
    public class StepsBase
    {

        public StepsBase()
        {
            client = DIContainer.GetService<HttpClient>();
        }
        protected HttpClient client { get; private set; }

    }
}
