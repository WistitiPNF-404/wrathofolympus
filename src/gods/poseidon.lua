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

	displayName = "Torrential Submersion",
	description = "Your splash effects fire stronger waves from {$TraitData.OmegaPoseidonProjectileBoon.Name} at no extra cost.",
	StatLines = { "BonusOceanSwellStatDisplay1" },
	customStatLine = {
		ID = "BonusOceanSwellStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Wave Bonus Damage:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneFromEachSet = {
			{ "PoseidonWeaponBoon", "PoseidonSpecialBoon", "PoseidonCastBoon" },
			{ "OmegaPoseidonProjectileBoon" },
			{ "PoseidonStatusBoon", "PoseidonExCastBoon", "EncounterStartOffenseBuffBoon" },
		},
	},
	flavourText = "Any and all would get crushed under the sea's astronomical weight, even the sturdiest Titan.",
	boonIconPath = "Wistiti-WrathOfOlympusBoonIcons\\PoseidonWrath",
	boonIconScale = 1.66,

	ExtractValues = {
		{
			Key = "ReportedWaveMultiplier",
			ExtractAs = "TooltipData",
			Format = "PercentDelta",
		},
	},

	ExtraFields = {
		AddOutgoingDamageModifiers = {
			ValidProjectiles = { "PoseidonOmegaWave" },
			ValidWaveDamageAddition = {
				BaseValue = 2.00, -- boon description only
				SourceIsMultiplier = true,
			},
			ReportValues = { ReportedWaveMultiplier = "ValidWaveDamageAddition" },
		},
		OnEnemyDamagedAction = {
			FunctionName = _PLUGIN.guid .. "." .. "PoseidonWrath",
			ValidProjectiles = 
			{
				"PoseidonSplashSplinter",
				"PoseidonCastSplashSplinter",
				"PoseidonSplashBackSplinter",
			},
			Args = {
				ProjectileName = "PoseidonOmegaWave",
				FallbackWeaponDamageMultiplier = 1.0,
				DamageMultiplier = 2.0,
				ImpactVelocity = 600,
			},
		},
	},
})