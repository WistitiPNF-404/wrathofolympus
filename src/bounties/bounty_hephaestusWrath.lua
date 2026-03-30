bountyAPI.RegisterBounty({
    Id = _PLUGIN.guid .. "BountyHephaestusWrath",
    Title = "Trial of Defense",
    Description = "Wildly retaliate foes' attacks with a BONK by keeping alive the Wrath of the God of the Forge.",
    Difficulty = 3,
    IsStandardBounty = true,
    BiomeChar = "F",

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
		InheritFrom = { "DefaultPackagedBounty", "BasePackageBountyBiomeF", },
        WeaponKitName = "WeaponAxe",
		WeaponUpgradeName = "AxeRallyAspect",
		KeepsakeName = "ArmorGainKeepsake",
		RemoveFamiliar = true,

        ForcedRewards =
		{
			{
				Name = "Boon",
				LootName = "HephaestusUpgrade",
				ForcedUpgradeOptions =
				{
					{
						Type = "Trait",
						ItemName = "MassiveDamageBoon",
						Rarity = "Epic",
					},
                    {
						Type = "Trait",
						ItemName = "MassiveKnockupBoon",
                        Rarity = "Epic",
					},
                    {
						Type = "Trait",
						ItemName = gods.GetInternalBoonName("HephWrathBoon"),
						Rarity = gods.GetInternalRarityName("Wrath"),
					},
				},
			},
		},

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
					LootName = "HephaestusUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "Boon",
					LootName = "ZeusUpgrade",
					AllowDuplicates = true,
				},
				{
					Name = "MaxManaDrop",
					GameStateRequirements =
					{
						-- None
					},
				},
			},
		},

		RunOverrides =
		{
			MaxGodsPerRun = 3,
			LootTypeHistory =
			{
                HephaestusUpgrade = 5,
				ZeusUpgrade = 2,
                AresUpgrade = 3,
			},
		},

        StartingTraits =
		{
			{ Name = "AresWeaponBoon", Rarity = "Epic", },
            { Name = "HephaestusSpecialBoon", Rarity = "Epic", },
			{ Name = "HephaestusCastBoon", Rarity = "Epic", },
            { Name = "ZeusSprintBoon", Rarity = "Epic", },
			{ Name = "HephaestusManaBoon", Rarity = "Heroic", },
            { Name = "HeavyArmorBoon", Rarity = "Epic", },
            { Name = "ArmorBoon", Rarity = "Epic", },
            { Name = "EncounterStartDefenseBuffBoon", Rarity = "Epic", },
			{ Name = "RoomRewardMaxHealthTrait", },
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
            EnemyHealthShrineUpgrade = 3, --3
            EnemySpeedShrineUpgrade = 1, --3
            EnemyCountShrineUpgrade = 3, --3
			NextBiomeEnemyShrineUpgrade = 2, --3
            EnemyEliteShrineUpgrade = 1, --2
			BossDifficultyShrineUpgrade = 1, --2
		},

        UnlockGameStateRequirements =
		{
			-- Biome and Shrine unlocks
			NamedRequirements = { "PackageBountyBiomeF", "ShrineUnlocked", },
			-- Bounty progress
			{
				Path = { "GameState", "PackagedBountyClears" },
				HasAny = { "PackageBountyChaosIntro", "PackageBountyOceanus", "PackageBountyStarter", },
			},
			-- Weapon
			{
				Path = { "GameState", "WeaponsUnlocked", },
				HasAll = { "WeaponAxe", "AxeRallyAspect", },
			},
			-- FirstLoot
			{
				Path = { "GameState", "TextLinesRecord", },
				HasAll = { "HephaestusFirstPickUp", },
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