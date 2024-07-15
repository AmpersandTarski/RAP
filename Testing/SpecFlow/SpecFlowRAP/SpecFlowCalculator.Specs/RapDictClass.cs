
namespace SpecFlowRAP.Specs.Data
{
    // Define a class to represent the objects in the JSON array
    public abstract class BaseClass : subBaseClass
    {
        public string[]? _bview_ { get; set; }
        public BaseClass()
        {
            _bview_ = null;
        }
        public BaseClass(string[] view)
        {
            _bview_ = view;
        }
    }
}
