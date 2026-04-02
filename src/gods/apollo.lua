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
	flavourText = "If there's one skill the God of Light never attained, it's his sister's hunting prowesses.",
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
})