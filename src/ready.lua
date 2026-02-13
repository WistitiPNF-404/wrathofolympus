---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- These are some sample code snippets of what you can do with our modding framework:
modutil.mod.Path.Wrap("SetupMap", function(base, ...)
	prefix_SetupMap()
	return base(...)
end)

import 'requirements.lua'

local HelpTextFile = rom.path.combine(rom.paths.Content, "Game/Text/en/HelpText.en.sjson")
local Order = { "Id", "InheritFrom", "DisplayName", "Description" }

local not_public = {}
public["not"] = not_public

-- Keywords and help texts
mod.ZeusWrathBoon_CombatText = sjson.to_object({
	Id = "ZeusWrath_CombatText",
	DisplayName = "{#CombatTextHighlightFormat}{$TempTextData.BoonName} {#Prev}{$TempTextData.Amount}x!",
}, Order)

local newKeywords = {
	"ModsWistitiFrostbiteDesc",
}
game.ConcatTableValuesIPairs(game.KeywordList, newKeywords)

local newQuestOrderData = {
	"ModsWistiti_QuestGetAllWrathBoons",
}
game.ConcatTableValuesIPairs(game.QuestOrderData, newQuestOrderData)

local newQuestData = {
	ModsWistiti_QuestGetAllWrathBoons = {
		Name = "ModsWistiti_QuestGetAllWrathBoons",
		InheritFrom = { "DefaultQuestItem", "DefaultOlympianQuest" },
		RewardResourceName = "WeaponPointsRare",
		RewardResourceAmount = 5,
		UnlockGameStateRequirements = {
			{
				Path = { "GameState", "TraitsTaken" },
				CountOf = {
					gods.GetInternalBoonName("ZeusWrathBoon"),
					gods.GetInternalBoonName("HeraWrathBoon"),
					gods.GetInternalBoonName("PoseidonWrathBoon"),
					gods.GetInternalBoonName("DemeterWrathBoon"),
					gods.GetInternalBoonName("ApolloWrathBoon"),
					gods.GetInternalBoonName("AphroWrathBoon"),
					gods.GetInternalBoonName("HephWrathBoon"),
					gods.GetInternalBoonName("HestiaWrathBoon"),
					gods.GetInternalBoonName("AresWrathBoon"),
					gods.GetInternalBoonName("HermesWrathBoon"),
				},
				Comparison = ">=",
				Value = 1,
			},
		},
		CompleteGameStateRequirements = {
			{
				Path = { "GameState", "TraitsTaken" },
				HasAll = {
					gods.GetInternalBoonName("ZeusWrathBoon"),
					gods.GetInternalBoonName("HeraWrathBoon"),
					gods.GetInternalBoonName("PoseidonWrathBoon"),
					gods.GetInternalBoonName("DemeterWrathBoon"),
					gods.GetInternalBoonName("ApolloWrathBoon"),
					gods.GetInternalBoonName("AphroWrathBoon"),
					gods.GetInternalBoonName("HephWrathBoon"),
					gods.GetInternalBoonName("HestiaWrathBoon"),
					gods.GetInternalBoonName("AresWrathBoon"),
					gods.GetInternalBoonName("HermesWrathBoon"),
				},
			},
		},
	},
}
game.QuestData["ModsWistiti_QuestGetAllWrathBoons"] = newQuestData.ModsWistiti_QuestGetAllWrathBoons

mod.DemeterWrathBoon_FrostbiteDesc = sjson.to_object({
	Id = "ModsWistitiFrostbiteDesc",
	DisplayName = "Frostbite",
	Description = "Burst of damage that increases depending on the duration of {$Keywords.Root}.",
}, Order)

mod.WrathBoonProphecy_Quest = sjson.to_object({
	Id = "ModsWistiti_QuestGetAllWrathBoons",
	DisplayName = "Vengeful Gods",
	Description = "The daughter of the god of the dead shall someday earn the most vengeful boons from the Olympians.",
}, Order)

sjson.hook(HelpTextFile, function(data)
	table.insert(data.Texts, mod.ZeusWrathBoon_CombatText)
	table.insert(data.Texts, mod.DemeterWrathBoon_FrostbiteDesc)
	table.insert(data.Texts, mod.WrathBoonProphecy_Quest)
end)

ResetKeywords()

--Damage coloring
game.OverwriteTableKeys( game.ProjectileData, {
	DemeterAmmoWind =
	{
		InheritFrom = { "DemeterColorProjectile" },
	},
})
game.ProcessDataStore(game.ProjectileData)

game.ConcatTableValues(game.WeaponSets.OlympianProjectileNames,{
    "DemeterAmmoWind",
})

--Wrath rarity
gods.CreateCustomRarity({
	Name = "Wrath",
	BlockStacking = true,
	BlockInRunRarify = true,
	BlockMenuRarify = true,
	RarityLevels = {
		Legendary = {
			MinMultiplier = 1,
			MaxMultiplier = 1,
		},
	},
	Display = {
		PathOverrides = {
			framePath = true,
			backingPath = true,
		},
		CustomRarityColor = Color.AresVoice,
		frameScale = 1.66,
		framePath = "Wistiti-WrathOfOlympusBoonFrames\\wrath_1",
		backingPath = "Wistiti-WrathOfOlympusBoonFrames\\BoonSlot_Wrath",
	},
})
mod.wrathTrait = gods.GetInternalRarityName("Wrath")

game.OverwriteTableKeys( game.ScreenData.RunClear.DamageSourceMap, {
    DemeterAmmoWind = "Frostbite",
})