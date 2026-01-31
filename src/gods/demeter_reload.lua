modutil.mod.Path.Wrap("ApplyRoot", function( baseFunc, victim, functionArgs, triggerArgs )
	local enemyRooted = false
	if victim.ActiveEffects["ChillEffect"] and victim.RootActive then
		enemyRooted = true
	end
	baseFunc(victim, functionArgs, triggerArgs)
	if victim.ActiveEffects then
		if victim.ActiveEffects["ChillEffect"] and victim.RootActive then
			if not enemyRooted then
				thread( mod.FrostbiteDamage, enemy, functionArgs, triggerArgs)
			end
		end
	end
end)

function mod.FrostbiteDamage (victim, functionArgs, triggerArgs)
	if not HeroHasTrait(gods.GetInternalBoonName("DemeterWrathBoon")) then
		return
	end
	local victim = triggerArgs.Victim
	local dataProperties = MergeAllTables({
		EffectData["ChillEffect"].EffectData, 
		functionArgs.EffectArgs
	})
	
	local freezeDuration = dataProperties.Duration - (dataProperties.ExpiringTimeThreshold - GetTotalHeroTraitValue("RootDurationExtension"))

	local damageAmount = freezeDuration * 125
	
	local frostbiteProjectile = {
		Name = "DemeterAmmoWind",
		Id = CurrentRun.Hero.ObjectId,
		DestinationId = victim.ObjectId,
		FireFromTarget = true,
		DamageMultiplier = damageAmount / 30, -- divided by projectile base damage
		DataProperties =
		{
			Fuse = 0,
			Range = 200,
			DamageRadius = 250,
			DamageRadiusScaleY = 0,
			DamageRadiusScaleX = 0,
		},
	}

	wait(freezeDuration - 0.15) --substract to make sure Frostbite hits against faster enemies
	if victim and not victim.IsDead then
		CreateProjectileFromUnit(frostbiteProjectile)
	end
end