bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyZeusWrath",
    Title = "Trial of the King",
    Description = "With the Wrath of the King of Olympus, disintegrate anyone—and really anyone!—who dares to cross your path on Mount Olympus.",
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
        WeaponKitName = "WeaponTorch",
		WeaponUpgradeName = "TorchAutofireAspect",
		KeepsakeName = "ForceZeusBoonKeepsake",
		RemoveFamiliar = true,

		RewardStoreOverrides =
		{
			RunProgress =
			{
				{
					Name = "Boon",
					LootName = "ZeusUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "Boon",
					LootName = "AphroditeUpgrade",
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
					Name = "WeaponUpgrade",
					GameStateRequirements =
					{
						--None
					}
				},
				{
					Name = "MaxHealthDrop",
				},
				{
					Name = "MaxManaDrop",
				},
				{
					Name = "MaxManaDrop",
				},
			},
		},
		
		RunOverrides =
		{
			MaxGodsPerRun = 2,
			LootTypeHistory =
			{
                ZeusUpgrade = 4,
				AphroditeUpgrade = 4,
                WeaponUpgrade = 1,
			},
		},

        StartingTraits =
		{
			{ Name = "ZeusSpecialBoon", Rarity = "Epic", },
            { Name = "AphroditeManaBoon", Rarity = "Epic", },
            { Name = "ZeusManaBoltBoon", Rarity = "Epic", }, 
			{ Name = gods.GetInternalBoonName("ZeusWrathBoon"), },
			{ Name = "TorchSpecialImpactTrait", },
			{ Name = "TorchOrbitPointTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
            { Name = "RoomRewardMaxHealthTrait", },
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