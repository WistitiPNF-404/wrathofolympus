--[[gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Apollo",
	internalBoonName = "ApolloWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"AirBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Critical Fiasco",
	description = "When attacks from {$Keywords.Blind}-afflicted foes miss, they take {#BoldFormatGraft}{$TooltipData.ExtractData.MissDamage} {#Prev}damage and become {$Keywords.Mark}.",
	StatLines = { "DazeCritStatDisplay1" },
	customStatLine = {
		ID = "DazeCritStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Critical Chance vs. Daze:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneFromEachSet = {
			{ "ApolloWeaponBoon", "ApolloSpecialBoon", "ApolloManaBoon" },
			{ "ApolloCastBoon", "ApolloSprintBoon" },
			{ "BlindChanceBoon", "ApolloRetaliateBoon" },
		},
	},
	flavourText = "If there's one skill the god of light never attained, it's his sister's hunting prowesses.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_38",

	ExtractValues = {
		{
			Key = "DazeMissDamage",
			ExtractAs = "MissDamage",
			SkipAutoExtract = true,
		},
		{
			ExtractAs = "BlindChance",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "BlindEffect",
			BaseProperty = "MissChance",
			Format = "Percent"
		},
		{
			ExtractAs = "BlindDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "BlindEffect",
			BaseProperty = "Duration",
		},
		{
			Key = "ReportedCritBonus",
			ExtractAs = "CritBonus",
			Format = "LuckModifiedPercent"
		},
		{
			External = true,
			BaseType = "EffectData",
			BaseName = "ArtemisBoonHuntersMark",
			BaseProperty = "Duration",
			ExtractAs = "TooltipMarkDuration",
			SkipAutoExtract = true,
		},
		{
			External = true,
			BaseType = "EffectLuaData",
			BaseName = "ArtemisBoonHuntersMark",
			BaseProperty = "CritVulnerability",
			ExtractAs = "CritRate",
			Format = "Percent",
			SkipAutoExtract = true,
		},
	},

	ExtraFields = {
		DazeMissDamage = 200, -- used for description only
		OnDodgeFunction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "ApolloWrath",
			RunOnce = true,
			FunctionArgs =
			{
				ProjectileName = "ApolloDodgeRetaliate",
				EffectName = "ArtemisBoonHuntersMark",
				DamageMultiplier =
				{
					BaseValue = 4,
					MinMultiplier = 0.1,
					IdenticalMultiplier =
					{
						Value = -0.5,
					},
				},
				ProjectileDelay = 0.1,
				ReportValues = { ReportedMissDamage = "DamageMultiplier" },--might need to remove that
			},
		},
		AddOutgoingCritModifiers =
		{
			Chance = { BaseValue = 0.1 },
			ValidActiveEffects = { "BlindEffect" },
			ReportValues = { ReportedCritBonus = "Chance"},
		},
	},
})]]

gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Apollo",
	internalBoonName = "ApolloWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"AirBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Finishing Touch",
	description = "Your {$Keywords.CastEX} fires a second time {#BoldFormatGraft}{$TooltipData.ExtractData.BonusCastSize}% {#Prev}larger, but uses more {!Icons.Mana}.",
	StatLines = { "OmegaCastCostStatDisplay1" },
	customStatLine = {
		ID = "OmegaCastCostStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Omega Cast Cost:",
		description = "{#ManaFormat}+{$TooltipData.ExtractData.ManaCostAddition}",
	},
	requirements = {
		OneFromEachSet = {
			{ "ApolloWeaponBoon", "ApolloSpecialBoon" },
			{ "ApolloCastBoon", "ApolloSprintBoon", "ApolloManaBoon" },
			{ "PerfectDamageBonusBoon", "BlindChanceBoon", "ApolloRetaliateBoon" },
		},
	},
	flavourText = "The god of light shall expand his light as far as he can, just like his ego.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_38",

	ExtractValues = {
		{
			Key = "ReportedCastSize",
			ExtractAs = "BonusCastSize",
			SkipAutoExtract = true,
			Format = "PercentDelta",
			HideSigns = true,
		},
		{
            Key = "ReportedCost",
            ExtractAs = "ManaCostAddition",
			SkipAutoExtract = true,
        },
	},

	ExtraFields = {
		ManaCostModifiers = 
		{
			WeaponNames = ConcatTableValues(WeaponSets.HeroNonPhysicalWeapons, {"WeaponCastProjectileHades", "WeaponAnywhereCast", "WeaponCastProjectile", "WeaponCastLob" }),
			ExWeapons = true,
			ManaCostAdd = 30,
			ReportValues = 
			{ 
				ReportedCost = "ManaCostAdd" 
			},
		},
		OnProjectileDeathFunction = 
		{
			Name = _PLUGIN.guid .. "." .. "ApolloWrath",
			Args = 
			{
				ValidProjectileName = "ProjectileCast",
				ProjectileName = {"ProjectileCast"},
				Cooldown = 0.5,
				SecondCastSize = 1.5,
				WaitForSecondCast = 0.2,
				MaxProjectiles = 1,
				ReportValues = { ReportedCastSize = "SecondCastSize"},
			}
		},
	},
})