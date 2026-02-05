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
	description = "Your {$Keywords.HeartBurstPlural} are stronger and fire your {$Keywords.CastEX} upon striking a foe.",
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
	flavourText = "Love hits like a truck. What is a truck? They don't know yet.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Aphrodite_39",

	ExtractValues = {
		{
			Key = "ReportedHeartthrobMultiplier",
			ExtractAs = "HeartthrobMultiplier",
			Format = "PercentDelta",
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
		HeartthrobBonusDamageModifiers = {
			ValidProjectiles = "AphroditeBurst",
			HeartthrobBonusMultiplier = {
				BaseValue = 1.5,
			},
			SourceIsMultiplier = true,
			ReportValues = { ReportedHeartthrobMultiplier = "HeartthrobBonusMultiplier" },
		},
	},
})