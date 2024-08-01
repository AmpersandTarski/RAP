using System.Text.Json;
using SpecFlowRAP.Specs.Data;



namespace SpecFlowRAP.StepDefinitions
{

    [Binding]
    public class RAPAtlasStepDefinitions : StepsBase
    {
        readonly FeatureContext _featureContext;
        public RAPAtlasStepDefinitions(FeatureContext featureContext)
        {
            _featureContext = featureContext;
        }

        private UriBuilder uriBuilder = UriBuilderSingleton.Instance;
        private int _result;
        string basePath = "/api/v1/resource";



        [Then("the result should be (.*)")]
        public void ThenTheResultShouldBe(int result)
        {
            _result.Should().Be(result);
        }



        [Given("i check my atlas")]
        public async Task GivenICheckMyAtlas()
        {
            // http://localhost/api/v1/resource/SESSION/1/Atlas
            uriBuilder.Path = string.Join("/", basePath, "SESSION/1/Atlas");
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            string body = await resp.Content.ReadAsStringAsync();
            List<Atlasdata>? atlas = JsonSerializer.Deserialize<List<Atlasdata>>(body);

            string? context_label = atlas?[0]._EMPTY_?.context?._label_;
            _featureContext.Set(atlas?[0]._EMPTY_?.context?._id_, "context_" + context_label?.ToLower());
            string? properties_label = atlas?[0]._EMPTY_?.properties?[0]._label_;
            _featureContext.Set(atlas?[0]._EMPTY_?.properties?[0]._id_, "properties_" + properties_label?.ToLower());

            // Save the Id's for all concepts, like Student, Module, SESSION, etc.
            for (int i = 0; i < atlas?[0]._EMPTY_?.concepts?.Count; i++)
            {
                string? concepts_label = atlas?[0]._EMPTY_?.concepts?[i]._label_;
                _featureContext.Set(atlas?[0]._EMPTY_?.concepts?[i]._id_, "concept_" + concepts_label?.ToLower());
            }
            // Save the Id's for all rules, like "TOT takes[Student*Course]" and "ModuleEnrollment".
            for (int i = 0; i < atlas?[0]?._EMPTY_?.rules?.Count; i++)
            {
                string? rules_label = atlas?[0]._EMPTY_?.rules?[i]._label_?.Split(" ")[0];
                _featureContext.Set(atlas?[0]._EMPTY_?.rules?[i]._id_, "rule_" + rules_label?.ToLower());
            }
            // Save the Id's for all relations, like takes and isPartOf, isEnrolledFor.
            for (int i = 0; i < atlas?[0]._EMPTY_?.relations?.Count; i++)
            {
                string? relation_label = atlas?[0]._EMPTY_?.relations?[i]._label_?.Split("[")[0];
                _featureContext.Set(atlas?[0]._EMPTY_?.relations?[i]._id_, "relation_" + relation_label?.ToLower());
            }
            // Save the Id's for all patterns, like Courses.
            for (int i = 0; i < atlas?[0]._EMPTY_?.patterns?.Count; i++)
            {
                string? pattern_label = atlas?[0]._EMPTY_?.patterns?[i]._label_;
                _featureContext.Set(atlas?[0]._EMPTY_?.patterns?[i]._id_, "pattern_" + pattern_label?.ToLower());
            }
        }


        [When("i check the '(.*)' '(.*)'")]
        public async Task WhenICheckThe(string entity, string entity_type)
        {
            // http://localhost/api/v1/resource/Rule/PropertyRule_4e579c72-08eb-46ea-9719-1bba89a5c8af/Rule
            string entityType = _featureContext.Get<string>(entity.ToLower() + "_" + entity_type.ToLower());
            uriBuilder.Path = string.Join("/", basePath, entity + "/" + entityType + "/" + entity);
            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            // Deserialization not really necessary to get the statuscode
            // Ruledata? atlas = JsonSerializer.Deserialize<Ruledata>(body);
            _result = (int)resp.StatusCode;
        }


        // Deze when is een bijzonder geval omdat het path afwijkt van de standaard (PropertyRule != PropRule)
        [When("i check the properties tot")]
        public async Task WhenICheckThePropertiesTot()
        {
            string properties_tot = _featureContext.Get<string>("properties_tot takes[student*course]");
            uriBuilder.Path = string.Join("/", basePath, "PropertyRule/" + properties_tot + "/PropRule");

            HttpResponseMessage resp = await Request.requestMessage(client, uriBuilder.Uri.AbsoluteUri);
            // Get content of respons just for illustration.
            string body = await resp.Content.ReadAsStringAsync();
            //Propertiesdata? atlas = JsonSerializer.Deserialize<Propertiesdata>(body);
            _result = (int)resp.StatusCode;
        }
    }
}

