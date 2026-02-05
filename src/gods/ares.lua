gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Ares",
	internalBoonName = "AresWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"EarthBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Ferocious Ichor",
	description = "Gain a chance to deal {$TraitData.AresStatusDoubleDamageBoon.DamagePercent:F} damage based on your current {!Icons.BloodDropWithCountIcon} count.",
	StatLines = { "PlasmaDoubleDamageStatDisplay1" },
	TrayStatLines = { "PlasmaDoubleDamageStatDisplay2" },
	customStatLine = {
		{
			ID = "PlasmaDoubleDamageStatDisplay1",
			displayName = "{!Icons.Bullet}{#PropertyFormat}Chance per Collected Plasma:",
			description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
		},
		{
			ID = "PlasmaDoubleDamageStatDisplay2",
			displayName = "{!Icons.Bullet}{#PropertyFormat}Current Double Damage Chance:",
			description = "{#UpgradeFormat}{$TooltipData.ExtractData.CurrentMultiplier:P}",
		},
	},
	requirements = {
		OneFromEachSet = {
			{ "AresWeaponBoon", "AresSpecialBoon" },
			{ "AresManaBoon", "BloodDropRevengeBoon", "RendBloodDropBoon" },
			{ "AresStatusDoubleDamageBoon", "MissingHealthCritBoon" },
		},
	},
	flavourText = "Bloodbaths shall stain one's soul when dangerously consumed by wrath.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Ares_37",

	ExtractValues = {
		{
			Key = "ReportedPlasmaCritMultiplier",
			ExtractAs = "Chance",
			Format = "LuckModifiedPercent",
			DecimalPlaces = 2,
			HideSigns = true,
		},
		{
			Key = "ReportedPlasmaCritMultiplier",
			ExtractAs = "CurrentMultiplier",
			Format = "LuckModifiedPercent",
			MultiplyByPlasmaCount = true,
			DecimalPlaces = 2,
			SkipAutoExtract = true,
			HideSigns = true,
		},
	},

	ExtraFields = {
		AddOutgoingDoubleDamageModifiers = {
			IncreasingPlasmaCritChance = {
				BaseValue = 0.005,
				DecimalPlaces = 4,
			},
			ReportValues = { ReportedPlasmaCritMultiplier = "IncreasingPlasmaCritChance" },
		},
	},
})