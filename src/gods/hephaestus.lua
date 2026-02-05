gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
	characterName = "Hephaestus",
	internalBoonName = "HephWrathBoon",
	isLegendary = false,
	InheritFrom = {
		mod.wrathTrait,
		"CostumeTrait", -- necessary for the boon's functionality
		"FireBoon",
	},
	addToExistingGod = { boonPosition = 10 },
	reuseBaseIcons = true,
	BlockStacking = true,

	displayName = "Eruptive Plating",
	description = "After you take damage while having {!Icons.ArmorTotal}, create a blast that deals {$TooltipData.ExtractData.Damage} damage in an area.",
	StatLines = { "BlastRevengeStatDisplay1" },
	customStatLine = {
		ID = "BlastRevengeStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Armor Gained Now:",
		description = "{#UpgradeFormat}+{$TooltipData.ExtractData.TooltipAmount}",
	},
	requirements = {
		OneFromEachSet = {
			{ "HephaestusWeaponBoon", "HephaestusSpecialBoon", "HephaestusSprintBoon" },
			{ "HeavyArmorBoon", "ArmorBoon", "EncounterStartDefenseBuffBoon" },
			{ "HephaestusManaBoon", "ManaToHealthBoon" },
		},
	},
	flavourText = "The best offense is defense. Or was it the other way around?",
	boonIconPath = "Wistiti-WrathOfOlympusBoonIcons\\HephWrath",
	boonIconScale = 1.66,

	ExtractValues = {
		{
			Key = "ReportedBlastDamageMultiplier",
			ExtractAs = "Damage",
			Format = "MultiplyByBase",
			BaseType = "Projectile",
			BaseName = "MassiveSlamBlast",
			BaseProperty = "Damage",
			SkipAutoExtract = true,
			DecimalPlaces = 1,
		},
		{
			Key = "ReportedExtraArmor",
			ExtractAs = "TooltipAmount",
		},
	},

	ExtraFields = {
		--Frame = "Wrath",
		Invincible = true,
		OnSelfDamagedFunction = {
			Name = _PLUGIN.guid .. "." .. "HephRetaliate",
			FunctionArgs = {
				ProjectileName = "MassiveSlamBlast",
				Cooldown = 0.4,
				BlastDelay = 0.08,
				DamageMultiplier = 3.0,
				ReportValues = {
					ReportedBlastDamageMultiplier = "DamageMultiplier",
				},
			},
		},
		AcquireFunctionName = "HeavyArmorInitialPresentation",
		SetupFunctions = {
			{
				Name = "CostumeArmor",
				Args = {
					Source = "Tradeoff",
					Delay = 0.75,
					BaseAmount = {
						BaseValue = 100,
					},
					ReportValues = {
						ReportedExtraArmor = "BaseAmount",
					},
				},
			},
		},
	},
})