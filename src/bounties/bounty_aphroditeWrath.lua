bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyAphroditeWrath",
    Title = "Trial of Lust",
    Description = "Run down the abandonned alleys of Ephyra with the powerful Wrath of the love-goddess Aphrodite.",
    Difficulty = 4,
    IsStandardBounty = true,
    BiomeChar = "N",

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
		InheritFrom = { "DefaultPackagedBounty", "BasePackageBountyBiomeN", },
        WeaponKitName = "WeaponSuit",
		WeaponUpgradeName = "SuitComboAspect",
		KeepsakeName = "ForceAphroditeBoonKeepsake",
		RemoveFamiliar = true,

		RunOverrides =
		{
			MaxGodsPerRun = 4,
			LootTypeHistory =
			{
                AphroditeUpgrade = 1,
				ApolloUpgrade = 1,
                AresUpgrade = 1,
                PoseidonUpgrade = 1,
			},
		},

        StartingTraits =
		{
			{ Name = "AphroditeSprintBoon", Rarity = "Epic", },
			{ Name = "ApolloManaBoon", Rarity = "Epic", },
			{ Name = "ManaBurstBoon", Rarity = "Epic", },
			{ Name = "OmegaPoseidonProjectileBoon", Rarity = "Rare", },
			{ Name = "OmegaDelayedDamageBoon", Rarity = "Rare", },
            { Name = gods.GetInternalBoonName("AphroWrathBoon"), },
			{ Name = "RoomRewardMaxManaTrait", },
			{ Name = "RoomRewardMaxManaTrait", },
		},

		RewardStoreOverrides = {
			HubRewards =
			{
				{
					Name = "MaxHealthDropBig",
				},
				{
					Name = "Boon",
					ForceLootName = "AphroditeUpgrade",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
				{
					Name = "Boon",
					ForceLootName = "ApolloUpgrade",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
				{
					Name = "Boon",
					ForceLootName = "PoseidonUpgrade",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
				{
					Name = "Boon",
					ForceLootName = "AresUpgrade",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
				{
					Name = "Boon",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
				{
					Name = "Boon",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
			},

			SubRoomRewards =
			{
				{
					Name = "TalentDrop",
					GameStateRequirements =
					{
						NamedRequirements = { "TalentLegal", },
					},
				},
				{
					Name = "MaxHealthDrop",
					GameStateRequirements =
					{
						NamedRequirementsFalse = { "TalentLegal", },
					},
				},
			},
			SubRoomRewardsHard =
			{
				{
					Name = "TalentDrop",
					GameStateRequirements =
					{
						NamedRequirements = { "TalentLegal", },
					},
				},
				{
					Name = "MaxHealthDrop",
					GameStateRequirements =
					{
						NamedRequirementsFalse = { "TalentLegal", },
					},
				},
			},
		},

        ShrineUpgradesActive = --15 Fear total
		{
			EnemyHealthShrineUpgrade = 2,
			EnemySpeedShrineUpgrade = 1,
			EnemyCountShrineUpgrade = 3,
			NextBiomeEnemyShrineUpgrade = 2,
			EnemyEliteShrineUpgrade = 1,
			BossDifficultyShrineUpgrade = 1,
		},

        UnlockGameStateRequirements =
		{
			-- Biome and Shrine unlocks
			NamedRequirements = { "PackageBountyBiomeN", "ShrineUnlocked", },
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
				HasAll = { "AphroditeFirstPickUp", },
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