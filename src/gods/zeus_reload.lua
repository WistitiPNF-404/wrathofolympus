function mod.ZeusWrath (unit, args)
	local strikeCount = args.MinStrikes
	while RandomChance( args.DoubleBoltChance * GetTotalHeroTraitValue( "LuckMultiplier", { IsMultiplier = true }) ) and strikeCount < args.MaxStrikes do
		strikeCount = strikeCount + 1
	end
	if strikeCount > 1 then
		thread( InCombatTextArgs, { TargetId = unit.ObjectId, Text = "ZeusWrath_CombatText", LuaKey = "TempTextData", ShadowScaleX = 1.1, LuaValue = { Amount = strikeCount, BoonName = gods.GetInternalBoonName("ZeusWrathBoon") }} )
	end
	CreateZeusBolt({
		ProjectileName = args.ProjectileName, 
		TargetId = unit.ObjectId, 
		DamageMultiplier = args.DamageMultiplier,
		Delay = 0.2, 
		FollowUpDelay = 0.2, 
		Count = strikeCount
		})
end)