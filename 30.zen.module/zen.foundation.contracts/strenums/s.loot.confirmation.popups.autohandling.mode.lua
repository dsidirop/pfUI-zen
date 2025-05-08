local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local SLootConfirmationPopupsAutohandlingMode = using "[declare:enum]" "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SLootConfirmationPopupsAutohandlingMode"

SLootConfirmationPopupsAutohandlingMode.Automatic      = "automatic"        --@formatter:off
SLootConfirmationPopupsAutohandlingMode.LetUserChoose  = "let_user_choose"  --@formatter:on

