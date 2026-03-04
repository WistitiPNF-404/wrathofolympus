function mod.CheckRootFrostbite( victim, functionArgs, triggerArgs )
	if triggerArgs.EffectName == "ChillEffect" and victim.RootActive and not triggerArgs.Reapplied then
		thread(mod.FrostbiteDamage, victim, functionArgs )
	end
end

function mod.FrostbiteDamage (victim, functionArgs)
	local dataProperties = MergeAllTables({
		EffectData["ChillEffect"].EffectData, 
		functionArgs.EffectArgs
	})
	local damageAmount = functionArgs.FrostbiteBaseDmg
	local frostbiteProjectile = {
		Name = "DemeterFrostbite",
		Id = CurrentRun.Hero.ObjectId,
		DestinationId = victim.ObjectId,
		FireFromTarget = true,
		DamageMultiplier = damageAmount, -- divided by projectile base damage
		DataProperties =
		{
			DamageRadius = 10,
			DamageRadiusScaleX = 1.175,
			DamageRadiusScaleY = 0.56,
			ImpactVelocity = 0,
			AffectsFriends = false,
			AffectsSelf = false,
			AffectsEnemies = true,
			MaxVictimZ = 9999,
			CanHitWithoutDamage = false,
		},
	}

	wait( functionArgs.Interval, RoomThreadName )
	local count = 1
	while victim and victim.RootActive and not victim.IsDead and not CurrentRun.Hero.IsDead do
		frostbiteProjectile.DamageMultiplier = (functionArgs.FrostbiteBaseDmg * count) -- divided by projectile base damage
		CreateProjectileFromUnit(frostbiteProjectile)
		CreateAnimation({ Name = "RadialNovaDemeter", DestinationId = victim.ObjectId })
		count = count + 1
		wait( functionArgs.Interval, RoomThreadName )
	end
end