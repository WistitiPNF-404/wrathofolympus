function mod.ApolloWrath (unit, traitArgs)
	if unit.ActiveEffects then
		if unit.ActiveEffects["BlindEffect"] then
			CreateProjectileFromUnit({ Name = traitArgs.ProjectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = unit.ObjectId, DamageMultiplier = traitArgs.DamageMultiplier})
			ApplyEffect( { DestinationId = unit.ObjectId, Id = CurrentRun.Hero.ObjectId, EffectName = traitArgs.EffectName, DataProperties = EffectData[traitArgs.EffectName].EffectData })
		end
	end
end