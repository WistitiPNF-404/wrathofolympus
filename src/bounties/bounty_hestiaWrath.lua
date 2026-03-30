bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyHestiaWrath",
    Title = "Trial of Cinders",
    Description = "Incinerate foes that willfully broke traditions by gaining the rarely seen Wrath of the Goddess of Hearth.",
    Difficulty = 4,
    IsStandardBounty = true,
    BiomeChar = "O",

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
		InheritFrom = { "DefaultPackagedBounty", "BasePackageBountyBiomeO", },
        WeaponKitName = "WeaponStaffSwing",
		WeaponUpgradeName = "StaffSelfHitAspect",
		KeepsakeName = "ForceHestiaBoonKeepsake",
		RemoveFamiliar = true,

		RewardStoreOverrides =
		{
			RunProgress =
			{
				{
					Name = "Boon",
					LootName = "HestiaUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "Boon",
					LootName = "ZeusUpgrade",
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
					Name = "StackUpgrade",
					GameStateRequirements =
					{
						NamedRequirements = { "StackUpgradeLegal", },
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
			MaxGodsPerRun = 2,
			LootTypeHistory =
			{
                HestiaUpgrade = 5,
				ZeusUpgrade = 2,
                WeaponUpgrade = 1,
			},
		},

        StartingTraits =
		{
			{ Name = "HestiaWeaponBoon", Rarity = "Epic", },
			{ Name = "ZeusSpecialBoon", Rarity = "Epic", },
			{ Name = "HestiaCastBoon", Rarity = "Epic", },
			{ Name = "ZeusManaBoon", Rarity = "Epic", },
			{ Name = "OmegaZeroBurnBoon", Rarity = "Epic", },
			{ Name = "HermesSpecialBoon", Rarity = "Epic", },
			{ Name = gods.GetInternalBoonName("HestiaWrathBoon"), },
			{ Name = "StaffAttackRecoveryTrait", },
			{ Name = "StaffOneWayAttackTrait", },
			{ Name = "RoomRewardMaxHealthTrait", },
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
			NamedRequirements = { "PackageBountyBiomeO", "ShrineUnlocked", },
			-- Bounty progress
			{
				Path = { "GameState", "PackagedBountyClears" },
				HasAny = { "PackageBountyChaosIntro", "PackageBountyOceanus", "PackageBountyStarter", },
			},
			-- Weapon
			{
				Path = { "GameState", "WeaponsUnlocked", },
				HasAll = { "WeaponStaffSwing", "StaffSelfHitAspect", },
			},
			-- FirstLoot
			{
				Path = { "GameState", "TextLinesRecord", },
				HasAll = { "HestiaFirstPickUp", },
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