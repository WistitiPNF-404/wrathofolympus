function mod.ApolloWrath (unit, traitArgs)
	if unit.ActiveEffects then
		if unit.ActiveEffects["BlindEffect"] then
			local dodgeProjectileDelay = GetTotalHeroTraitValue("ProjectileDelay")
			wait(dodgeProjectileDelay)
			if unit and not unit.IsDead then
				CreateProjectileFromUnit({ Name = traitArgs.ProjectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = unit.ObjectId, DamageMultiplier = traitArgs.DamageMultiplier})
				ApplyEffect( { DestinationId = unit.ObjectId, Id = CurrentRun.Hero.ObjectId, EffectName = traitArgs.EffectName, DataProperties = EffectData[traitArgs.EffectName].EffectData })
			end
		end
	end
end