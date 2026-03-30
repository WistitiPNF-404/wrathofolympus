bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyHeraWrath",
    Title = "Trial of the Queen",
    Description = "With the Wrath of the Queen of Olympus, project the summoned Shawn's pain to the invading foes of Mount Olympus (but worry not, Shawn is fine).",
    Difficulty = 5,
    IsStandardBounty = true,
    BiomeChar = "P",

    DataOverrides = function (RegisterValues)
        print("Overriding all the needed game tables for this challenge run...")
    end,
    SetupFunctions = function (BountyRunData, FromSave)
        if FromSave then
            print("Reacting to the data found in the persisted storage for this challenge run...")
        else
            print("Setting up the persisted data storage for this challenge run...")
        end
    end,
    RoomTransition = function (BountyRunData, RoomName)
        print("Room " .. RoomName .. " is being left. Choosing next room...")
    end,
    CanEnd = function (BountyRunData, RoomName)
        print("Determining whether this challenge run should end")
        return true
    end,
    EndFunctions = function (BountyRunData, Cleared)
        print("Challenge run is ending. Cleaning up...")
    end,
    BaseData = {
		InheritFrom = { "DefaultPackagedBounty", "BasePackageBountyBiomeP", },
        WeaponKitName = "WeaponDagger",
		WeaponUpgradeName = "DaggerTripleAspect",
		KeepsakeName = "ForceHeraBoonKeepsake",
		RemoveFamiliar = true,

		RewardStoreOverrides =
		{
			RunProgress =
			{
				{
					Name = "Boon",
					LootName = "HeraUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "Boon",
					LootName = "HephaestusUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "Boon",
					LootName = "ApolloUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "HermesUpgrade",
					GameStateRequirements =
					{
						--None
					}
				},
				{
					Name = "MaxHealthDrop",
				},
				{
					Name = "MaxHealthDrop",
				},
				{
					Name = "MaxManaDrop",
				},
			},
		},

		RunOverrides =
		{
			MaxGodsPerRun = 3,
			LootTypeHistory =
			{
                HeraUpgrade = 4,
				HephaestusUpgrade = 3,
				ApolloUpgrade = 3,
			},
		},

        StartingTraits =
		{
			{ Name = "HeraWeaponBoon", Rarity = "Epic", },
			{ Name = "HephaestusSpecialBoon", Rarity = "Epic", },
            { Name = "HeraCastBoon", Rarity = "Epic", }, 
			{ Name = "HeraManaBoon", Rarity = "Epic", }, 
            { Name = "MassiveKnockupBoon", Rarity = "Epic", }, 
            { Name = "ArmorBoon", Rarity = "Epic", }, 
			{ Name = "ApolloCastAreaBoon", Rarity = "Epic", }, 
			{ Name = "HermesSpecialBoon", Rarity = "Epic", }, 
			{ Name = gods.GetInternalBoonName("HeraWrathBoon"), },
			{ Name = "DaggerRapidAttackTrait", },
			{ Name = "DaggerTripleRepeatWomboTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
            { Name = "RoomRewardMaxHealthTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
			{ Name = "RoomRewardMaxManaTrait", },
			{ Name = "RoomRewardMaxManaTrait", },
			{ Name = "RoomRewardMaxManaTrait", },
		},

		MetaUpgradeStateEquipped =
		{
			"ChanneledCast", --1
			"HealthRegen", --1
			"LowHealthBonus", --4
			"ScreenReroll", --4
			"StatusVulnerability", --5
		},

        ShrineUpgradesActive = --15 Fear total
		{
			EnemyHealthShrineUpgrade = 2,
			EnemySpeedShrineUpgrade = 1,
			NextBiomeEnemyShrineUpgrade = 2,
			BossDifficultyShrineUpgrade = 3,
		},

        UnlockGameStateRequirements =
		{
			-- Biome and Shrine unlocks
			NamedRequirements = { "PackageBountyBiomeP", "ShrineUnlocked", },
			-- Bounty progress
			{
				Path = { "GameState", "PackagedBountyClears" },
				HasAny = { "PackageBountyChaosIntro", "PackageBountyOceanus", "PackageBountyStarter", },
			},
			-- Weapon
			{
				Path = { "GameState", "WeaponsUnlocked", },
				HasAll = { "WeaponDagger", "DaggerTripleAspect", },
			},
			-- FirstLoot
			{
				Path = { "GameState", "TextLinesRecord", },
				HasAll = { "DemeterFirstPickUp", },
			},

			-- MetaUpgrades
			{
				Path = { "GameState", "MetaUpgradeLimitLevel", },
				Comparison = ">=",
				Value = 15,
			},
		},
    },
})