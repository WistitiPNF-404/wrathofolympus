function DeepMergeUptoDepth(base, incoming, depth, currentDepth)
    depth = depth or 0
    currentDepth = currentDepth or 0
    local returnTable = game.DeepCopyTable( base )
    for k, v in pairs( incoming ) do
		if type(v) == "table" and currentDepth<depth then
			if next(v) == nil then
				returnTable[k] = {}
			else
				returnTable[k] = DeepMergeUptoDepth( returnTable[k], v, depth, currentDepth + 1 )
			end
		elseif v == "nil" then
			returnTable[k] = nil
		else
			returnTable[k] = v
		end
	end
    return returnTable
end

local traitRequirements = {
    LuckyBoon = {
        OneOf =
		{
			"DoubleRewardBoon",
			"PoseidonCastBoon",
			"PoseidonStatusBoon",

			"BoltRetaliateBoon",
			"DoubleBoltBoon",
			"SpawnKillBoon",

			"BlindChanceBoon",
			"DoubleStrikeChanceBoon",

			"CritBonusBoon",
			"HighHealthCritBoon",
			"InsideCastCritBoon",
			"TimedCritVulnerabilityBoon",
			"FocusCritBoon",
			"DashOmegaBuffBoon",
			"SorceryCritBoon",

			"AresManaBoon",
			"BloodDropRevengeBoon",
			"MissingHealthCritBoon",
			"AresStatusDoubleDamageBoon",
			"RendBloodDropBoon",
			-- Duos
			"DoubleSplashBoon",
			"BloodManaBurstBoon",
			"MoneyDamageBoon",
            --Wraths
            gods.GetInternalBoonName("ZeusWrathBoon"),
            gods.GetInternalBoonName("ApolloWrathBoon"),
            gods.GetInternalBoonName("AresWrathBoon"),
		},
    }
}
game.TraitRequirements = DeepMergeUptoDepth(game.TraitRequirements, traitRequirements, 2)