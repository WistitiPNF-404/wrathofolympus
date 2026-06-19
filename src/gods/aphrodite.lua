gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Aphrodite",
	internalBoonName = "AphroWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"WaterBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Lustful Confession",
	description = "Your {$Keywords.HeartBurstPlural} are stronger, and fire your {$Keywords.CastEX} upon striking a foe.",
	StatLines = { "BonusHeartthrobDamageStatDisplay1" },
	customStatLine = {
		ID = "BonusHeartthrobDamageStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus Heartthrob Damage:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneFromEachSet = {
			{ "AphroditeWeaponBoon", "AphroditeSpecialBoon" },
			{ "ManaBurstBoon" },
			{ "HighHealthOffenseBoon", "HealthRewardBonusBoon", "FocusRawDamageBoon" },
		},
	},
	flavourText = "Love is like a hurricane, and she is older than storm itself.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Aphrodite_39",

	ExtractValues = {
		{
			Key = "ReportedHeartthrobMultiplier",
			ExtractAs = "HeartthrobMultiplier",
			Format = "PercentDelta",
		},
		{
			Key = "ReportedCooldown",
			ExtractAs = "WrathCooldown",
		},
		{
			ExtractAs = "Duration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "ProjectileBase",
			BaseName = "AphroditeBurst",
			BaseProperty = "Fuse",
		},
	},

	ExtraFields = {
		OnEnemyDamagedAction = {
			FunctionName = _PLUGIN.guid .. "." .. "AphroWrath",
			ValidProjectiles = { "AphroditeBurst" },
			FunctionArgs = {
				AphroWrathCooldown = 0.10,
				HeartthrobBonusMultiplier = {
					BaseValue = 1.25,
				},
				SourceIsMultiplier = true,
				ReportValues = { 
					ReportedHeartthrobMultiplier = "HeartthrobBonusMultiplier",
					ReportedCooldown = "AphroWrathCooldown", 
				},
			},
		},
	},
})