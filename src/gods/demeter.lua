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
    description = "After the {$Keywords.Root} duration on your foes expires, they suffer from {$Keywords.ModsWistitiFrostbiteDesc}.",
	StatLines = { "FrostbiteBurstStatDisplay1" },
    customStatLine = {
        Id = "FrostbiteBurstStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Frostbite Damage:",
        description = "{#UpgradeFormat}{$TooltipData.ExtractData.FrostbiteDamage} {#Prev}{#ItalicFormat}(per 1 Sec.)",
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
    boonIconPath = "GUI\\Screens\\BoonIcons\\Demeter_32",
    
	ExtractValues =
	{
		{
			Key = "FrostbiteBaseDmg",
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
		FrostbiteBaseDmg = 250,
		--[[OnEnemyDamagedAction =
		{
			FunctionName = "FrostbiteDamage",
			FunctionArgs = {
				EffectName = "ChillEffect",
				ProjectileName = "DemeterAmmoWind",
			},
		},]]
    },
})