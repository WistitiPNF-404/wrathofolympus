gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Demeter",
	internalBoonName = "DemeterWrathBoon",
    isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"WaterBoon",
	},
    addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
    BlockStacking = true,

    displayName = "Hypothermic Shock",
    description = "Foes suffer from {$Keywords.ModsWistitiFrostbiteDesc} as long as they're inflicted by {$Keywords.Root}.",
	StatLines = { "FrostbiteBurstStatDisplay1" },
    customStatLine = {
        Id = "FrostbiteBurstStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Frostbite Damage:",
        description = "{#UpgradeFormat}+{$TooltipData.ExtractData.FrostbiteDamage} {#Prev}{#ItalicFormat}(every 1 Sec.)",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "DemeterWeaponBoon", "DemeterSpecialBoon", "DemeterCastBoon" },
			{ "DemeterSprintBoon", "CastNovaBoon" },
			{ "SlowExAttackBoon", "CastAttachBoon" },
		},
	},
    flavourText = "As limbs turn blue and fall, the Goddess of Seasons does not bat an eye.",
    boonIconPath = "Wistiti-WrathOfOlympusBoonIcons\\DemeterWrath",
	boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedFrostbiteDamage",
			ExtractAs = "FrostbiteDamage",
			SkipAutoExtract = true,
		},
		{
			ExtractAs = "ChillDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "ChillEffect",
			BaseProperty = "Duration",
		},
		{
			ExtractAs = "ChillActiveDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "ChillEffect",
			BaseProperty = "ActiveDuration",
		},
	},

	ExtraFields = 
	{
		OnEffectApplyFunction =
		{
			FunctionName = _PLUGIN.guid .. "." .. "CheckRootFrostbite",
			FunctionArgs = {
				Interval = 1.0,
				EffectName = "ChillEffect",
				ProjectileName = "DemeterAmmoWind",
				FrostbiteBaseDmg = 100,
				ReportValues = {
					ReportedFrostbiteDamage = "FrostbiteBaseDmg",
				},
			},
		},
    },
})