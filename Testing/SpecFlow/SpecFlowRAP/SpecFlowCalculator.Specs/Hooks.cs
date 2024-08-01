
namespace SpecFlowRAP.StepDefinitions
{

    [Binding]
    public static class Hooks
    {
        // For additional details on SpecFlow hooks see http://go.specflow.org/doc-hooks

        [BeforeFeature]
        public static void BeforeTestRun(FeatureContext featureContext)
        {
            DIContainer.ConfigureServices();

            RAPStepDefinitions rAPStepDefinitions = new RAPStepDefinitions(featureContext);
            Task.Run(async () => await rAPStepDefinitions.GivenIReinstallTheApplication()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.GivenINeedASessionIdOfRAP()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.GivenINeedToSeeTheRegisterButton()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.GivenINeedARegisterIdOfRAP()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.WhenIFillInMyUserid()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.WhenIFillInMyPasswordAndName()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.WhenICreateMyAccount()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.ThenIWantToAddANewScript()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.WhenIAddMyLatestScript()).GetAwaiter().GetResult();
            Task.Run(async () => await rAPStepDefinitions.WhenCompileMyLatestScript()).GetAwaiter().GetResult();
        }
    }
}
