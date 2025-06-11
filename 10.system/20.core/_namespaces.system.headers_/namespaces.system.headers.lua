local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]) --@formatter:off  we just want to preemptively declare the namespaces so that we will be able to use strings.* inside guard.* and vice-versa

-- using "[declare] [static]" "System.Scopify"      no need to predeclare this really

using "[declare] [enum]" "System.Language.SRawTypes [Partial]"

using "[declare] [static]" "System.Nils [Partial]"
using "[declare] [static]" "System.Math [Partial]"
using "[declare] [static]" "System.Time [Partial]"
using "[declare] [static]" "System.Table [Partial]"

using "[declare] [static]" "System.Guard [Partial]"
using "[declare] [static]" "System.Guard.Utilities [Partial]"
using "[declare] [static]" "System.Guard.Assert [Partial]"
using "[declare] [static]" "System.Guard.Assert.Explained [Partial]"

using "[declare] [static]" "System.Iterators [Partial]"
using "[declare] [static]" "System.Reflection [Partial]"

using "[declare] [static]" "System.Console [Partial]"

using "[declare] [static]" "System.Classes.Fields [Partial]"
using "[declare] [static]" "System.Classes.Metatable [Partial]"
using "[declare] [static]" "System.Classes.Instantiator [Partial]"
using "[declare] [static]" "System.Classes.Mixins.MixinsBlender [Partial]"

using "[declare] [static]" "System.Helpers.Arrays [Partial]"
using "[declare] [static]" "System.Helpers.Tables [Partial]"
using "[declare] [static]" "System.Helpers.Strings [Partial]"
using "[declare] [static]" "System.Helpers.Booleans [Partial]"

using "[declare] [static]" "System.Language.RawTypeSystem [Partial]"

using "[declare] [static]" "System.Exceptions.Throw [Partial]"
using "[declare] [static]" "System.Exceptions.Utilities [Partial]"

using "[declare] [static]" "System.Externals.WoW.UI.GlobalFrames [Partial]"

using "[declare]" "System.Try [Partial]"
using "[declare]" "System.Event [Partial]"

using "[declare]" "System.IO.GenericTextWriter [Partial]"

using "[declare]" "System.Exceptions.Exception [Partial]"
using "[declare]" "System.Exceptions.NotImplementedException [Partial]"
using "[declare]" "System.Exceptions.ValueAlreadySetException [Partial]"
using "[declare]" "System.Exceptions.ValueCannotBeNilException [Partial]"
using "[declare]" "System.Exceptions.ValueIsOutOfRangeException [Partial]"
using "[declare]" "System.Exceptions.ValueIsOfInappropriateTypeException [Partial]"
