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
	description = "Whenever {$Keywords.Blind} causes a foe to miss, it takes {#BoldFormatGraft}{$TooltipData.ExtractData.MissDamage} {#Prev}damage and becomes {$Keywords.Mark}.",
	StatLines = { "DazeCritStatDisplay1" },
	customStatLine = {
		ID = "DazeCritStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Critical Chance vs. Daze:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneFromEachSet = {
			{ "ApolloWeaponBoon", "ApolloSpecialBoon" },
			{ "ApolloCastBoon", "ApolloSprintBoon" },
			{ "BlindChanceBoon", "ApolloRetaliateBoon" },
		},
	},
	flavourText = "We cannot all be the best at what we do, for the god of light has much of it covered.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_36",

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
		}
	},

	ExtraFields = {
		DazeMissDamage = 100, -- used for description only
		OnDodgeFunction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "ApolloWrath",
			RunOnce = true,
			FunctionArgs =
			{
				ProjectileName = "ApolloRetaliateStrike",
				EffectName = "ArtemisBoonHuntersMark",
				DamageMultiplier =
				{
					BaseValue = 2,
					MinMultiplier = 0.1,
					IdenticalMultiplier =
					{
						Value = -0.5,
					},
				},
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