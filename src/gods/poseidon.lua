gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Poseidon",
	internalBoonName = "PoseidonWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"WaterBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Merciless Undertow",
	description = "Your {$Keywords.KnockbackAmplify} effects are guaranteed, and may fire your waves from {$TraitData.OmegaPoseidonProjectileBoon.Name}.",
	StatLines = { "ChanceOceanSwellStatDisplay1" },
	customStatLine = {
		ID = "ChanceOceanSwellStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Waves from Froth Chance:",
		description = "{#UpgradeFormat}{$TooltipData.ExtractData.FrothWaveChance}%",
	},
	requirements = {
		OneFromEachSet = {
			{ "PoseidonWeaponBoon", "PoseidonSpecialBoon", "PoseidonSprintBoon", "PoseidonManaBoon" },
			{ "OmegaPoseidonProjectileBoon" },
			{ "PoseidonCastBoon", "PoseidonStatusBoon" },
		},
	},
	flavourText = "Any and all would get crushed under the sea's astronomical weight, even the sturdiest Titan.",
	boonIconPath = "Wistiti-WrathOfOlympusBoonIcons\\PoseidonWrath",
	boonIconScale = 1.66,

	ExtractValues = {
		{
			Key = "WaveChance",
			ExtractAs = "FrothWaveChance",
			Format = "LuckModifiedPercent",
			SkipAutoExtract = true,
		},
		{
			ExtractAs = "KnockbackAmplifyDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "AmplifyKnockbackEffect",
			BaseProperty = "Duration",
			DecimalPlaces = 1,
		},
		{
			ExtractAs = "FontChance",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectLuaData",
			BaseName = "AmplifyKnockbackEffect",
			BaseProperty = "Chance",
			Format = "LuckModifiedPercent"
		},
		{
			External = true,
			ExtractAs = "FontDamage",
			BaseType = "ProjectileBase",
			BaseName = "PoseidonEffectFont",
			BaseProperty = "Damage",
		},
	},

	ExtraFields = {
		OnEnemyDamagedAction = {
			Args = {
				ProjectileName = "PoseidonOmegaWave",
				FallbackWeaponDamageMultiplier = 1.0,
				ImpactVelocity = 600,
			},
		},
		WaveChance = { BaseValue = 0.4 },
	},
})