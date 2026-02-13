gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Hermes",
	internalBoonName = "HermesWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"EarthBoon",
	},
	addToExistingGod = { boonPosition = 14 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Witch Time",
	description = "Whenever you {$Keywords.Dodge}, make everything else move {#BoldFormatGraft}{$TooltipData.ExtractData.SlowAmount}% {#Prev} slower for {#BoldFormatGraft}1.5 Sec.",
	StatLines = { "HermesWrathDodgeStatDisplay1" },
	customStatLine = {
		ID = "HermesWrathDodgeStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus Dodge Chance:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},
	requirements = {
		OneOf = { "SprintShieldBoon", "SorcerySpeedBoon", "SlowProjectileBoon", "MoneyMultiplierBoon", "RestockBoon" },
	},
	flavourText = "The God of Swiftness shall grant to witches alike the signature ability of distant coven sisters.",
	boonIconPath = "Wistiti-WrathOfOlympusBoonIcons\\HermesWrath",
	boonIconScale = 1.66,

	ExtractValues ={
        {
            Key = "ReportedTotalDodgeBonus",
            ExtractAs = "TooltipTotalDodgeBonus",
            Format = "Percent",
            SkipAutoExtract = true,
        },
        {
            Key = "ReportedDodgeBonus",
            ExtractAs = "TooltipDodgeBonus",
            Format = "Percent",
        },
        {
			Key = "DodgeSlowAmount",
			ExtractAs = "SlowAmount",
            SkipAutoExtract = true,
            Format = "Percent",
			HideSigns = true,
		},
    },

	ExtraFields = {
        DodgeSlowAmount = 0.75,
        PropertyChanges = 
		{
			{
				LifeProperty = "DodgeChance",
				BaseValue = 0.15,
				ChangeType = "Add",
				DataValue = false,
				ReportValues = 
				{ 
					ReportedTotalDodgeBonus = "ChangeValue",
					ReportedDodgeBonus = "BaseValue",
				},
			},
		},
		OnDodgeFunction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "SetupHermesSlow",
			RunOnce = true,
			FunctionArgs =
			{
				Modifier = 0.25, 
                Duration = 1.5, 
                LoopingSound = "/SFX/Player Sounds/TimeSlowLoop",
                EndWarnNum = 1,
                EndWarnPresentationFunction = "SpellSlowWarnPresentation",
                EndSlowMotionSound = "/VO/MelinoeEmotes/EmoteGasping",
                EndSlowMotionFunctionName = _PLUGIN.guid .. "." .. "HermesEndTimeSlow",
			},
		},
	},
})