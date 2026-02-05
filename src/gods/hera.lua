gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Hera",
	internalBoonName = "HeraWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"AetherBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Wicked Offspring",
	description = "Your {$Keywords.CastSet} summon a sturdy {$Keywords.Link}-afflicted critter in the binding circle.",
	StatLines = { "HitchPunchingBagStatDisplay1" },
	customStatLine = {
		ID = "HitchPunchingBagStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Hitch Damage from Critter:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneFromEachSet = {
			{ "SuperSacrificeBoonZeus" },
			{ "HeraWeaponBoon", "HeraSpecialBoon", "HeraCastBoon", "HeraSprintBoon" },
		},
	},
	flavourText = "In the Queen's own wise words: To Hell with patriarchy.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Hera_39",

	ExtractValues = {
		{
			Key = "ReportedHitchBonus",
			ExtractAs = "TooltipData",
			Format = "PercentDelta",
		},
		{
			ExtractAs = "DamageShareDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageShareEffect",
			BaseProperty = "Duration",
		},
		{
			ExtractAs = "DamageShareAmount",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageShareEffect",
			BaseProperty = "Amount",
			Format = "Percent",
		},
	},

	ExtraFields = {
		OnWeaponFiredFunctions =
		{
			ValidWeapons = WeaponSets.HeroNonPhysicalWeapons,
			FunctionName = _PLUGIN.guid .. "." .. "HeraMoutonSpawn",
			FunctionArgs =
			{
				SpawnedEnemy = "Sheep",
				EffectName = "DamageShareEffect",
				MaxHealthMultiplier = 2,
				StartDelay = 0.2,
				HitchShareAmountBonus = 2.0, --used for description only
				ReportValues = { ReportedHitchBonus = "HitchShareAmountBonus" },
			},
		},
	},
})