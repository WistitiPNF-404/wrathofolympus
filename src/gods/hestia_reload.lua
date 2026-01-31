function mod.BurnInstaKill ( args, attacker, victim, triggerArgs )
	--[[for k,v in pairs(victim.ActiveEffects["BurnEffect"]) do
		print(k)
	end]]--

	if attacker == CurrentRun.Hero and HasEffectWithEffectGroup( victim, "Burn" )
		and not victim.IsDead
		and not victim.CannotDieFromDamage
		and victim.Health / victim.MaxHealth <= args.CombustDeathThreshold
		and (victim.Health - victim.ActiveEffects["BurnEffect"] <= 0)
		and ( victim.Phases == nil or victim.CurrentPhase == victim.Phases ) then

		if args.ExecuteImmunities and args.ExecuteImmunities[victim.Name] and IsGameStateEligible( victim, args.ExecuteImmunities[victim.Name].GameStateRequirement ) then
			if not victim.ResistChillKillPresentation then
				victim.ResistChillKillPresentation = true
			end
			return
		end 

		-- Projectile is created but deals no damage, only for visuals
		CreateProjectileFromUnit({ Name = args.ProjectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = victim.ObjectId, DamageMultiplier = args.DamageMultiplier, FireFromTarget = true})

		thread( Kill, victim, { ImpactAngle = 0, AttackerTable = CurrentRun.Hero, AttackerId = CurrentRun.Hero.ObjectId })
		if victim.UseBossHealthBar then
			CurrentRun.BossHealthBarRecord[victim.Name] = 0 -- Health bar won't get updated again normally
		end
	end
end

modutil.mod.Path.Override("ApplyBurn", function (victim, functionArgs, triggerArgs)
	functionArgs = ShallowCopyTable(functionArgs) or { EffectName = "BurnEffect", NumStacks = 1 }
	local effectName = functionArgs.EffectName 
	
	if victim and victim.BlockEffectWhileRootActive == effectName then
		return
	end

	if victim and victim.EffectBlocks and Contains(victim.EffectBlocks, effectName) then
		return
	end

	if not EffectData[effectName] then
		return
	end
	local dataProperties = MergeAllTables({
		EffectData[effectName].EffectData, 
		functionArgs.EffectArgs
	})
	if HeroHasTrait("BurnStackBoon") then
		for _, data in pairs( GetHeroTraitValues("EffectModifier")) do
			if EffectData[effectName].DisplaySuffix == data.ValidActiveEffectGenus then
				if data.IntervalMultiplier then
					dataProperties.Cooldown = dataProperties.Cooldown * data.IntervalMultiplier
				end
				if data.DurationIncrease then
					dataProperties.Duration = dataProperties.Duration + data.DurationIncrease
				end
			end
		end
	end
	if not SessionMapState.FirstBurnRecord[ victim.ObjectId ] then
		functionArgs.NumStacks = functionArgs.NumStacks + GetTotalHeroTraitValue("BonusFirstTimeBurn")
		SessionMapState.FirstBurnRecord[ victim.ObjectId ] = true
	end
	local maxStacks = EffectData[effectName].MaxStacks
	if HeroHasTrait(gods.GetInternalBoonName("HestiaWrathBoon")) then
		maxStacks = EffectData[effectName].MaxStacks * 10
	end
	if not victim.ActiveEffects[effectName] or victim.ActiveEffects[effectName] < maxStacks then
		IncrementTableValue( victim.ActiveEffects, effectName, functionArgs.NumStacks )
		if victim.ActiveEffects[effectName] > maxStacks then
			victim.ActiveEffects[effectName] = maxStacks
		end
	end
	ApplyEffect( { DestinationId = victim.ObjectId, Id = CurrentRun.Hero.ObjectId, EffectName = effectName, NumStacks = functionArgs.NumStacks, DataProperties = dataProperties } )
end)