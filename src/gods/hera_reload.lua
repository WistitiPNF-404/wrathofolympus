modutil.mod.Path.Override("HeraMoutonSpawn", function(weaponData, traitArgs, triggerArgs)
	ShawnSummon(traitArgs.SpawnedEnemy, traitArgs, triggerArgs)
end)

modutil.mod.Path.Override("ShawnSummon", function(enemyName, traitArgs, triggerArgs)
	local args = traitArgs or {}
	local weaponDataMultipliers = 
	{ 
		MaxHealthMultiplier = args.MaxHealthMultiplier or 1, 
	}
	local enemyData = EnemyData[enemyName]
	local newEnemy = DeepCopyTable( enemyData )
	if enemyData.AlliedScaleMultiplier then
		weaponDataMultipliers.ScaleMultiplier = enemyData.AlliedScaleMultiplier
	end
	newEnemy.Name = "Shawn"
	newEnemy.SheepHitVelocity = 400
	newEnemy.HideHealthBar = false
	newEnemy.BlocksLootInteraction = false
	newEnemy.IgnoreCastSlow = false
	newEnemy.RequiredKill = false
	newEnemy.MaxHealth = newEnemy.MaxHealth * weaponDataMultipliers.MaxHealthMultiplier
	newEnemy.HealthBarOffsetY = (newEnemy.HealthBarOffsetY or -155 )
	
	newEnemy.DefaultAIData.ExitMapAfterDuration = 6

	newEnemy.DamageType = "Enemy"
	newEnemy.TriggersOnDamageEffects = true
	newEnemy.CanBeFrozen = true

	newEnemy.BlocksLootInteraction = false

	newEnemy.SkipModifiers = false
	newEnemy.SkipDamageText = false
	newEnemy.SkipDamagePresentation = false
	newEnemy.IgnoreAutoLock = false

	ProcessDataInheritance(newEnemy, EnemyData)
	
	local SpawnPoint = SpawnObstacle({ Name = "InvisibleTarget", DestinationId = CurrentRun.Hero.ObjectId, OffsetX = 0, OffsetY = 0, ForceToValidLocation = true})

	if SessionMapState.CurrentShawn then
		Kill(ActiveEnemies[SessionMapState.CurrentShawn], { Silent = true })
	end

	newEnemy.ObjectId = SpawnUnit({
		Name = enemyData.Name,
		Group = "Standing",
		DestinationId = SpawnPoint, OffsetX = 0, OffsetY = 0 })
	SessionMapState.CurrentShawn = newEnemy.ObjectId
	
	thread( CreateAlliedEnemyPresentation, newEnemy )
	thread( SetupUnit, newEnemy, CurrentRun, { SkipPresentation = true } )
	SetThingProperty({ Property = "ElapsedTimeMultiplier", Value = GetGameplayElapsedTimeMultiplier(), ValueChangeType = "Absolute", DataValue = false, DestinationId = newEnemy.ObjectId })
	
	if not newEnemy or newEnemy.SkipModifiers or not GetThingDataValue({ Id = newEnemy.ObjectId, Property = "StopsProjectiles" }) or IsInvulnerable({ Id = newEnemy.ObjectId }) or IsUntargetable({ Id = newEnemy.ObjectId }) then
		return
	end

	SetThingProperty({ Property = "ElapsedTimeMultiplier", Value = newEnemy.SpeedMultiplier, ValueChangeType = "Multiply", DataValue = false, DestinationId = newEnemy.ObjectId })

	SetScale({ Id = newEnemy.ObjectId, Fraction = 1, Duration = 0 })
	newEnemy.SummonHealthBarEffect = true
	ApplyDamageShare( newEnemy, args, triggerArgs )
	return newEnemy
end)

modutil.mod.Path.Wrap("ApplyDamageShare", function( baseFunc, victim, functionArgs, triggerArgs )
	if HeroHasTrait(gods.GetInternalBoonName("HeraWrathBoon")) then
		if functionArgs.EffectArgs == nil then
			functionArgs.EffectArgs = { Amount = 0.3 }
		end
		if victim.Name == "Shawn" then
			functionArgs.EffectArgs.Amount = 1.0 --needs to be modified with tooltip data
		end
	end
	baseFunc( victim, functionArgs, triggerArgs )
end)