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

	wait( functionArgs.Interval, RoomThreadName )
	local count = 1
	while victim and victim.RootActive and not victim.IsDead and not CurrentRun.Hero.IsDead do
		frostbiteProjectile.DamageMultiplier = (functionArgs.FrostbiteBaseDmg * count) / 30 -- divided by projectile base damage
		CreateProjectileFromUnit(frostbiteProjectile)
		count = count + 1
		wait( functionArgs.Interval, RoomThreadName )
	end
end