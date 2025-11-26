---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- These are some sample code snippets of what you can do with our modding framework:
local file = rom.path.combine(rom.paths.Content, 'Game/Text/en/ShellText.en.sjson')
sjson.hook(file, function(data)
	return sjson_ShellText(data)
end)

modutil.mod.Path.Wrap("SetupMap", function(base, ...)
	prefix_SetupMap()
	return base(...)
end)

local TraitTextFile = rom.path.combine(rom.paths.Content, "Game/Text/en/TraitText.en.sjson")
local Order = { "Id", "InheritFrom", "DisplayName", "Description" }

local not_public = {}
public["not"] = not_public

mod.HeraRandomCurseBoon_Text = sjson.to_object({
    Id = "BonusOlympianDamageStatDisplay1",
    InheritFrom = "BaseStatLine",
    DisplayName = "{!Icons.Bullet}{#PropertyFormat}Bonus Olympian Damage:",
    Description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
}, Order)

sjson.hook(TraitTextFile, function(data)
    table.insert(data.Texts, mod.HeraRandomCurseBoon_Text)
end)

--[[ 
uid, internal, charactername ,legendary, rarity, slot, blockstacking,  statlines, extractval, elements, displayName
extrafields, boonIconPath, requirements, flavourtext
]]
gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    internalBoonName = "RandomCurseBoon",
    isLegendary = false,
    Elements = {"Fire"},
    characterName = "Hera",
    addToExistingGod = true,

    displayName = "Family Discourse",
    description = "Whenever you inflict {$Keywords.Link}, also randomly inflict a {$Keywords.Status} from other Olympians.",
	StatLines = { "BonusOlympianDamageStatDisplay1" },
	requirements = { OneOf = { "HeraWeaponBoon", "HeraSpecialBoon", "HeraCastBoon", "HeraSprintBoon" } },
    boonIconPath = "GUI\\Screens\\BoonIcons\\Hera_37",
	reuseBaseIcons = true,
	BlockStacking = true,
	RarityLevels = {
			Common = 1.00,
       		Rare = 4 / 3,
        	Epic = 5 / 3,
        	Heroic = 6 / 3,
	},	

	ExtractValues = { 
		{
			Key = "ReportedBonusOlympianDamage",
			ExtractAs = "TooltipDamageBonus",
			Format = "PercentDelta",
		},
		-- Hitch highlight Duration and Share Damage
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
		AddOutgoingDamageModifiersArray = 
		{
			{
				ValidProjectiles = WeaponSets.OlympianProjectileNames,
				BonusOlympianDamageMultiplier =
				{
					BaseValue = 1.03,
					SourceIsMultiplier = true,
				},
				ReportValues = { ReportedBonusOlympianDamage = "BonusOlympianDamageMultiplier", },
			},
			{
				ValidEffects = WeaponSets.OlympianEffectNames,
				BonusOlympianDamageMultiplier =
				{
					BaseValue = 1.03,
					SourceIsMultiplier = true,
				},
			},
		},
		OnEffectApplyFunction = 
		{
			FunctionName = "rom.mods." .. _PLUGIN.guid .. ".not.CheckRandomShareDamageCurse",
			FunctionArgs = 
			{
				Count = 1,
				Effects = 
				{
					AmplifyKnockbackEffect = 
					{
						GameStateRequirements =
						{
							{
								PathTrue = { "GameState", "TextLinesRecord", "PoseidonFirstPickUp" },
							},
						},
						CopyValuesFromTraits = 
						{
							Modifier = {"PoseidonStatusBoon" }
						}
					},
					BlindEffect = 
					{
						GameStateRequirements =
						{
							{
								PathTrue = { "GameState", "TextLinesRecord", "ApolloFirstPickUp" },
							},
						},
					},
					DamageEchoEffect = 
					{ 
						GameStateRequirements =
						{
							{
								PathTrue = { "GameState", "TextLinesRecord", "ZeusFirstPickUp" },
							},
						},
						ExtendDuration = "EchoDurationIncrease", 
						DefaultModifier = 1,
						CopyValuesFromTraits = 
						{
							Modifier = {"ZeusWeaponBoon", "ZeusSpecialBoon"}
						}
					},
					
					DelayedKnockbackEffect = 
					{
						GameStateRequirements =
						{
							{
								PathTrue = { "GameState", "TextLinesRecord", "HephaestusFirstPickUp" },
							},
						},
						CopyValuesFromTraits = 
						{
							TriggerDamage = { "MassiveKnockupBoon" }
						}
					},
					ChillEffect = 
					{
						GameStateRequirements =
						{
							{
								PathTrue = { "GameState", "TextLinesRecord", "DemeterFirstPickUp" },
							},
						},
						CustomFunction = "ApplyRoot"
					},

					WeakEffect =
					{
						GameStateRequirements =
						{
							{
								PathTrue = { "GameState", "TextLinesRecord", "AphroditeFirstPickUp" },
							},
						},
						CustomFunction = "ApplyAphroditeVulnerability",
					}, 
					
					BurnEffect = 
					{ 
						GameStateRequirements =
						{
							{
								PathTrue = { "GameState", "TextLinesRecord", "HestiaFirstPickUp" },
							},
						},
						CustomFunction = "ApplyBurn", 
						DefaultNumStacks = 30,
						CopyNumStacksFromTraits = { "HestiaWeaponBoon", "HestiaSpecialBoon" },
					},
					
					--[[AresStatus = 
					{
						GameStateRequirements =
						{
							{
								Path = { "GameState", "TextLinesRecord", },
								HasAny = { "AresFirstPickUp" },
							},
						},
						CustomFunction = "AresRendApplyPresentation",
						CopyValuesFromTraits = 
						{
							Modifier = {"AresWeaponBoon", "AresSpecialBoon"},
						},
					},]]--
				},
				ReportValues = { ReportedCount = "Count" }
			},
		}
	}
})

gods.IsBoonRegistered("RandomCurseBoon", true)

-- Function Library --

-- FamilyDiscourse custom function
function not_public.CheckRandomShareDamageCurse(victim, functionArgs, triggerArgs)
	if triggerArgs.EffectName == "DamageShareEffect" and not triggerArgs.Reapplied and victim.ActivationFinished then
		local eligibleEffects = { }
		for name, data in pairs( functionArgs.Effects ) do
			if not data.GameStateRequirements or IsGameStateEligible( data, data.GameStateRequirements ) then
				table.insert( eligibleEffects, name )
			end
		end
		local count = functionArgs.Count or 1
		for i=1, count do 
			local effectName = RemoveRandomValue( eligibleEffects )
			if not effectName then
				return
			end
			local applicationData = functionArgs.Effects[effectName]
			if applicationData.CustomFunction then
				local stacks = applicationData.DefaultNumStacks
				if applicationData.CopyNumStacksFromTraits then
					for _, traitName in pairs(applicationData.CopyNumStacksFromTraits ) do
							if HeroHasTrait( traitName ) then
								local traitData = GetHeroTrait( traitName )
								if traitData.OnEnemyDamagedAction and traitData.OnEnemyDamagedAction.Args then
									local args = traitData.OnEnemyDamagedAction.Args
									if args.NumStacks and stacks < args.NumStacks then
										stacks = args.NumStacks
									end
								end
							end
					end
				end

				CallFunctionName( applicationData.CustomFunction, victim, {EffectName = effectName, NumStacks = stacks } )
			else
				local dataProperties = EffectData[effectName].EffectData or EffectData[effectName].DataProperties
				if applicationData.ExtendDuration then
					dataProperties.Duration = dataProperties.Duration + GetTotalHeroTraitValue(applicationData.ExtendDuration)
				end
				if applicationData.DefaultModifier then
					dataProperties.Modifier = applicationData.DefaultModifier
				end
				if applicationData.CopyValuesFromTraits then
					for property, traitNames in pairs(applicationData.CopyValuesFromTraits ) do
						for _, traitName in pairs( traitNames ) do
							if HeroHasTrait( traitName ) then
								local traitData = GetHeroTrait( traitName )
								if traitData and traitData.OnEnemyDamagedAction and traitData.OnEnemyDamagedAction.Args then
									if not dataProperties[property] or ( dataProperties[property] and traitData.OnEnemyDamagedAction.Args[property] > dataProperties[property] ) then
										dataProperties[ property ] = traitData.OnEnemyDamagedAction.Args[property]
									end
								end
							end
						end
					end
				end
				ApplyEffect( { DestinationId = victim.ObjectId, Id = CurrentRun.Hero.ObjectId, EffectName = effectName, DataProperties = dataProperties })
			end
		end
	end
end


--[[
	AirBoon = 
	{
		Elements = { "Air" },
		DebugOnly = true,
	},
	FireBoon = 
	{
		Elements = {"Fire"},
		DebugOnly = true,
	},
	EarthBoon = 
	{
		Elements = {"Earth"},
		DebugOnly = true,
	},
	WaterBoon = 
	{
		Elements = {"Water"},
		DebugOnly = true,
	},
	AetherBoon = 
	{
		Elements = {"Aether"},
		DebugOnly = true,
	},
    	SynergyTrait =
	{
		InheritFrom = { "AetherBoon", },
		GameStateRequirements =
		{
			{
				Path = { "CurrentRun", "CurrentRoom", "ChosenRewardType", },
				IsNone = { "Devotion", },
			},
		},
		IsDuoBoon = true,
		Frame = "Duo",
		BlockStacking = true,
		DebugOnly = true,
		RarityLevels =
		{
			Duo =
			{
				MinMultiplier = 1,
				MaxMultiplier = 1,
			},
		},
	},

	LegacyTrait = 
	{
		IsLegacyTrait = true,
		DebugOnly = true,
	},

	UnityTrait = 
	{
		IsElementalTrait = true,
		BlockStacking = true,
		BlockInRunRarify = true,
		BlockMenuRarify = true,
		ExcludeFromRarityCount = true,
		CustomRarityName = "Boon_Infusion",
		CustomRarityColor = Color.BoonPatchElemental,
		InfoBackingAnimation = "BoonSlotUnity",
		UpgradeChoiceBackingAnimation = "BoonSlotUnity",
		Frame = "Unity",
		DebugOnly = true,
		RarityLevels =
		{
			Common =
			{
				Multiplier = 1,
			},
			Rare =
			{
				Multiplier = 1,
			},
			Epic =
			{
				Multiplier = 1,
			},
		}
	},
]]