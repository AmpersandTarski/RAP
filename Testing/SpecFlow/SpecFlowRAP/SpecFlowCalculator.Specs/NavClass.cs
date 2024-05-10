using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowRAP.StepDefinitions
{
    internal class NavClass : RapDictClass
    { 
        public string? Label { get; set; }
        public string? Parent { get; set; }
        public RapDictClass[]? Items { get; set; }

        public string? Interface_32_ref { get; set; }
        public string? Url { get; set; }
        public RapArrClass[]? Roles { get; set; }
        public ifcsClass[]? _ifcs_ { get; set; }
    }
}
