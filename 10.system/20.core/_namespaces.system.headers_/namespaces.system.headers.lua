local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off  we just want to preemptively declare the namespaces so that we will be able to use strings.* inside guard.* and vice-versa

-- using "[declare] [static]" "System.Scopify"      no need to predeclare this really

using "[declare] [enum]" "System.Language.SRawTypes"

using "[declare] [static]" "System.Nils"
using "[declare] [static]" "System.Math"
using "[declare] [static]" "System.Time"
using "[declare] [static]" "System.Table"
using "[declare] [static]" "System.Guard"
using "[declare] [static]" "System.Iterators"
using "[declare] [static]" "System.Validation"
using "[declare] [static]" "System.Reflection"

using "[declare] [static]" "System.Console"

using "[declare] [static]" "System.Classes.Fields"
using "[declare] [static]" "System.Classes.Metatable"
using "[declare] [static]" "System.Classes.Instantiator"
using "[declare] [static]" "System.Classes.Mixins.MixinsBlender"

using "[declare] [static]" "System.Helpers.Arrays"
using "[declare] [static]" "System.Helpers.Tables"
using "[declare] [static]" "System.Helpers.Strings"
using "[declare] [static]" "System.Helpers.Booleans"

using "[declare] [static]" "System.Language.RawTypeSystem"

using "[declare] [static]" "System.Exceptions.Throw"
using "[declare] [static]" "System.Exceptions.Rethrow"
using "[declare] [static]" "System.Exceptions.Utilities"

using "[declare] [static]" "System.Externals.WoW.UI.GlobalFrames"

using "[declare]" "System.Try"
using "[declare]" "System.Event"

using "[declare]" "System.IO.GenericTextWriter"

using "[declare]" "System.Exceptions.Exception"
using "[declare]" "System.Exceptions.ValueAlreadySetException"
using "[declare]" "System.Exceptions.ValueCannotBeNilException"
using "[declare]" "System.Exceptions.ValueIsOutOfRangeException"
using "[declare]" "System.Exceptions.ValueIsOfInappropriateTypeException"
