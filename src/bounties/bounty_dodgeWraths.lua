bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyDodgeWraths",
    Title = "Trial of Evasiveness",
    Description = "Dance around foes at the edge of the Underworld with the Wraths of the Gods of Sun and Switfness.",
    Difficulty = 3,
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
        WeaponKitName = "WeaponAxe",
		WeaponUpgradeName = "AxeRecoveryAspect",
		KeepsakeName = "TimedBuffKeepsake",
		RemoveFamiliar = true,

		ForcedRewards =
		{
			{
				Name = "Boon",
				LootName = "ApolloUpgrade",
				ForcedUpgradeOptions =
				{
					{
						Type = "Trait",
						ItemName = "PerfectDamageBonusBoon",
						Rarity = "Epic",
					},
					{
						Type = "Trait",
						ItemName = "ApolloRetaliateBoon",
						Rarity = "Epic",
					},
					{
						Type = "Trait",
						ItemName = gods.GetInternalBoonName("ApolloWrathBoon"),
						Rarity = gods.GetInternalRarityName("Wrath"),
					},
				},
			},
		},

		RunOverrides =
		{
			MaxGodsPerRun = 2,
			LootTypeHistory =
			{
                ApolloUpgrade = 2,
                ZeusUpgrade = 4,
				HermesUpgrade = 1,
                WeaponUpgrade = 1,
			},
		},

        StartingTraits =
		{
			{ Name = "ApolloSpecialBoon", Rarity = "Epic", },
			{ Name = "ApolloCastBoon", Rarity = "Epic", },
			{ Name = "ApolloManaBoon", Rarity = "Epic", },
            { Name = "ApolloCastAreaBoon", Rarity = "Epic", },
            { Name = "BoltRetaliateBoon", Rarity = "Epic", },
            { Name = "DodgeChanceBoon", Rarity = "Epic", },
            { Name = "ElementalDodgeBoon", },
            { Name = gods.GetInternalBoonName("HermesWrathBoon"), },
            { Name = "CoverRegenerationBoon", Rarity = "Duo", },
            { Name = "AxeThirdStrikeTrait", },
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
			EnemySpeedShrineUpgrade = 2,
			EnemyCountShrineUpgrade = 3,
			NextBiomeEnemyShrineUpgrade = 1,
			EnemyEliteShrineUpgrade = 1,
			BossDifficultyShrineUpgrade = 1,
		},

        RewardStoreOverrides = {
			HubRewards =
			{
				{
					Name = "MaxHealthDropBig",
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
					ForceLootName = "ZeusUpgrade",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
				{
					Name = "Boon",
					ForceLootName = "ZeusUpgrade",
					AllowDuplicates = true,
					GameStateRequirements =
					{
						-- None
					},
				},
				{
					Name = "Boon",
					ForceLootName = "ZeusUpgrade",
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
				HasAll = { "WeaponAxe", "AxeRecoveryAspect", },
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