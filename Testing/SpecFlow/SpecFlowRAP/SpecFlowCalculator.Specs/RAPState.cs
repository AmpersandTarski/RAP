using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpecFlowRAP
{
    public enum RAPState
    {
        NOT_STARTED,
        NOT_REGISTERED,
        BUSY_REGISTERING,
        REGISTERED,
        NOT_LOGGED_IN,
        LOGGED_IN,
        READY_TO_ADD_SCRIPT
    }
}
