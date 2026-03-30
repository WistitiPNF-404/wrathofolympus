bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyAresWrath",
    Title = "Trial of Bloodbath",
    Description = "Spill out Plasma from your enemies to enhance your lust for blood with the God of War's Wrath.",
    Difficulty = 4,
    IsStandardBounty = true,
    BiomeChar = "H",

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
		InheritFrom = { "DefaultPackagedBounty", "BasePackageBountyBiomeH", },
        WeaponKitName = "WeaponAxe",
		WeaponUpgradeName = "AxePerfectCriticalAspect",
		KeepsakeName = "ForceAresBoonKeepsake",
		RemoveFamiliar = true,

		RewardStoreOverrides =
		{
			RunProgress =
			{
				{
					Name = "Boon",
					LootName = "AresUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "Boon",
					LootName = "AphroditeUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "MaxHealthDrop",
				},
				{
					Name = "MaxHealthDrop",
				},
			},
		},

		RunOverrides =
		{
			MaxGodsPerRun = 2,
			LootTypeHistory =
			{
                AresUpgrade = 5,
				AphroditeUpgrade = 4,
                HermesUpgrade = 3,
			},
		},

        StartingTraits =
		{
			{ Name = "AphroditeWeaponBoon", Rarity = "Epic", },
			{ Name = "AresSpecialBoon", Rarity = "Epic", },
			{ Name = "AresManaBoon", Rarity = "Epic", },
			{ Name = "BloodDropRevengeBoon", Rarity = "Epic", },
			{ Name = "RendBloodDropBoon", Rarity = "Epic", },
			{ Name = gods.GetInternalBoonName("AresWrathBoon"), },
            { Name = "AxeSpinSpeedTrait", },
            { Name = "AxeRangedWhirlwindTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
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

        ShrineUpgradesActive = --16 Fear total
		{
			EnemyHealthShrineUpgrade = 3,
            EnemyCountShrineUpgrade = 3,
            EnemyEliteShrineUpgrade = 1,
			BossDifficultyShrineUpgrade = 3,
		},

        UnlockGameStateRequirements =
		{
			-- Biome and Shrine unlocks
			NamedRequirements = { "PackageBountyBiomeH", "ShrineUnlocked", },
			-- Bounty progress
			{
				Path = { "GameState", "PackagedBountyClears" },
				HasAny = { "PackageBountyChaosIntro", "PackageBountyOceanus", "PackageBountyStarter", },
			},
			-- Weapon
			{
				Path = { "GameState", "WeaponsUnlocked", },
				HasAll = { "WeaponAxe", "AxePerfectCriticalAspect", },
			},
			-- FirstLoot
			{
				Path = { "GameState", "TextLinesRecord", },
				HasAll = { "AresFirstPickUp", },
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