bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyPoseidonWrath",
    Title = "Trial of Undertow",
    Description = "Drown foes before they get to Scylla's nightly concert with the submerging Wrath of the God of the Sea.",
    Difficulty = 4,
    IsStandardBounty = true,
    BiomeChar = "G",

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
		InheritFrom = { "DefaultPackagedBounty", "BasePackageBountyBiomeG", },
        WeaponKitName = "WeaponDagger",
		WeaponUpgradeName = "DaggerHomingThrowAspect",
		KeepsakeName = "ForcePoseidonBoonKeepsake",
		RemoveFamiliar = true,

		RewardStoreOverrides =
		{
			RunProgress =
			{
				{
					Name = "Boon",
					LootName = "PoseidonUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "Boon",
					LootName = "HeraUpgrade",
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
                PoseidonUpgrade = 3,
				HeraUpgrade = 2,
                WeaponUpgrade = 1,
			},
		},

        StartingTraits =
		{
            { Name = "HeraWeaponBoon", Rarity = "Epic", },
			{ Name = "PoseidonSpecialBoon", Rarity = "Epic", },
			{ Name = "PoseidonStatusBoon", Rarity = "Epic", },
			{ Name = "OmegaPoseidonProjectileBoon", Rarity = "Epic", },
            { Name = gods.GetInternalBoonName("PoseidonWrathBoon"), },
            { Name = "DaggerSpecialFanTrait", },
            { Name = "DaggerSpecialJumpTrait", },
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
			EnemyHealthShrineUpgrade = 3,
            EnemyCountShrineUpgrade = 3,
			EnemyShieldShrineUpgrade = 1,
            EnemyEliteShrineUpgrade = 1,
			NextBiomeEnemyShrineUpgrade = 1,
			BossDifficultyShrineUpgrade = 2,
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
				HasAll = { "WeaponDagger", "DaggerHomingThrowAspect", },
			},
			-- FirstLoot
			{
				Path = { "GameState", "TextLinesRecord", },
				HasAll = { "PoseidonFirstPickUp", },
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