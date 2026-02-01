gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Hestia",
	internalBoonName = "HestiaWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"FireBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Cindered Ritual",
	description = "Foes combust when their inflicted {$Keywords.Burn} exceeds their current remaining {!Icons.EnemyHealth}.",
	StatLines = { "CombustThresholdStatDisplay1" },
	customStatLine = {
		ID = "CombustThresholdStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Health Threshold for Combustion:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneFromEachSet = {
			{ "HestiaWeaponBoon", "HestiaSpecialBoon", "HestiaCastBoon" },
			{ "OmegaZeroBurnBoon", "BurnArmorBoon" },
			{ "BurnExplodeBoon", "AloneDamageBoon" },
		},
	},
	flavourText = "Traditions are to be heeded, as once broken can unleash the wrath of the Goddess of Hearth.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Hestia_39",

	ExtractValues = {
		{
			Key = "ReportedThreshold",
			ExtractAs = "CombustThreshold",
			Format = "Percent",
			HideSigns = true,
		},
		{
			ExtractAs = "BurnRate",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectLuaData",
			BaseName = "BurnEffect",
			BaseProperty = "DamagePerSecond",
			DecimalPlaces = 1,
		},
	},

	ExtraFields = {
		OnDamageEnemyFunction = {
			FunctionName = _PLUGIN.guid .. "." .. "BurnInstaKill",
			FunctionArgs = {
				ExecuteImmunities = {
					Prometheus = {
						GameStateRequirement = {
							{
								Path = { "GameState", "ShrineUpgrades", "BossDifficultyShrineUpgrade" },
								Comparison = ">=",
								Value = 3,
							},
						}
					}
				},
				CombustDeathThreshold = 0.4,
				ProjectileName = "IcarusExplosion",
				DamageMultiplier = 0,
				ReportValues = 
				{ 
					ReportedThreshold = "CombustDeathThreshold",
				}
			},
		},
	},
})