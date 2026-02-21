bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyDemeterWrath",
    Title = "Trial of Hypothermia",
    Description = "Drive the enemies invading Mount Olympus to hypothermia with the withering Wrath of the Goddess of Seasons.",
    Difficulty = 4,
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
        WeaponKitName = "WeaponLob",
		WeaponUpgradeName = "LobImpulseAspect",
		KeepsakeName = "ForceDemeterBoonKeepsake",
		RemoveFamiliar = true,

		RunOverrides =
		{
			MaxGodsPerRun = 3,
			LootTypeHistory =
			{
                DemeterUpgrade = 4,
				HeraUpgrade = 2,
                WeaponUpgrade = 1,
			},
		},

        StartingTraits =
		{
			{ Name = "DemeterWeaponBoon", Rarity = "Epic", },
			{ Name = "DemeterSpecialBoon", Rarity = "Epic", },
            { Name = gods.GetInternalBoonName("DemeterWrathBoon"), },
			{ Name = "LobOneSideTrait", },
			{ Name = "LobAmmoMagnetismTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
			{ Name = "RoomRewardMaxManaTrait", },
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
				HasAll = { "WeaponSuit", "SuitComboAspect", },
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