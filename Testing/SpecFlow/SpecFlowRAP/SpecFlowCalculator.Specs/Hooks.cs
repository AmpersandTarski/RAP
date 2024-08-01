
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

            RAPStepDefinitions rapStepDefinitions = new RAPStepDefinitions(featureContext);
            Task.Run(async () => await rapStepDefinitions.GivenIReinstallTheApplication()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.GivenINeedASessionIdOfRAP()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.GivenINeedToSeeTheRegisterButton()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.GivenINeedARegisterIdOfRAP()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.WhenIFillInMyUserid()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.WhenIFillInMyPasswordAndName()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.WhenICreateMyAccount()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.ThenIWantToAddANewScript()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.WhenIAddMyLatestScript()).GetAwaiter().GetResult();
            Task.Run(async () => await rapStepDefinitions.WhenCompileMyLatestScript()).GetAwaiter().GetResult();
        }
    }
}
