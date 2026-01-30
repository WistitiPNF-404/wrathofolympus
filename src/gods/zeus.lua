gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Zeus",
	internalBoonName = "ZeusWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"AirBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Spurned Patriarch",
	description = "Activating {$Keywords.Echo} on foes strikes them with {#BoldFormatGraft}{$TooltipData.ExtractData.BoltsNumber} {#Prev}lightning bolts, each dealing {#BoldFormatGraft}{$TooltipData.ExtractData.WrathBoltDamage} {#Prev}damage.",
	StatLines = { "BlitzVengeanceStatDisplay1" },
	customStatLine = {
		ID = "BlitzVengeanceStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Double Strike Chance:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneFromEachSet = {
			{ "SuperSacrificeBoonHera" },
			{ "ZeusWeaponBoon", "ZeusSpecialBoon" },
		},
	},
	flavourText = "The lightning bolt forever remains a symbol of the impulsive power of the Lord of Olympus.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Zeus_33",

	ExtractValues = {
		{
			Key = "ReportedBoltChance",
			ExtractAs = "DoubleChance",
			Format = "LuckModifiedPercent",
		},
		{
			Key = "ReportedMinStrikes",
			ExtractAs = "BoltsNumber",
			SkipAutoExtract = true,
		},
		{
			Key = "BoltDamage",
			ExtractAs = "WrathBoltDamage",
			SkipAutoExtract = true,
		},
		{
			ExtractAs = "EchoDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageEchoEffect",
			BaseProperty = "Duration",
		},
		{
			ExtractAs = "EchoThreshold",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageEchoEffect",
			BaseProperty = "DamageThreshold",
		},
	},

	ExtraFields = {
		BoltDamage = 100, -- used for description only
		OnEnemyDamagedAction = {
			FunctionName = _PLUGIN.guid .. "." .. "ZeusWrath",
			ValidProjectiles = { "ZeusEchoStrike" },
			Args = {
				ProjectileName = "ZeusRetaliateStrike",
				DoubleBoltChance = 0.4,
				MinStrikes = 3,
				MaxStrikes = {
					BaseValue = 6,
					MinValue = 3,
					IdenticalMultiplier = {
						Value = -0.5,
					},
				},
				ReportValues = {
					ReportedMaxStrikes = "MaxStrikes",
					ReportedMinStrikes = "MinStrikes",
					ReportedBoltChance = "DoubleBoltChance",
				},
			},
		},
	},
})