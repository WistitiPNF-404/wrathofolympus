--[[function mod.ApolloWrath (unit, traitArgs)
	if unit.ActiveEffects then
		if unit.ActiveEffects["BlindEffect"] then
			local dodgeProjectileDelay = traitArgs.ProjectileDelay
			wait(dodgeProjectileDelay)
			if unit and not unit.IsDead then
				CreateProjectileFromUnit({ Name = traitArgs.ProjectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = unit.ObjectId, DamageMultiplier = traitArgs.DamageMultiplier})
				ApplyEffect( { DestinationId = unit.ObjectId, Id = CurrentRun.Hero.ObjectId, EffectName = traitArgs.EffectName, DataProperties = EffectData[traitArgs.EffectName].EffectData })
			end
		end
	end
end]]

function mod.ApolloWrath ( triggerArgs, functionArgs )
	if triggerArgs.name ~= functionArgs.ValidProjectileName then
		return
	end

	if SessionState.ApolloSecondExCastTarget[triggerArgs.ProjectileId] then
		return
	end		
	if triggerArgs.Armed then
		local dropLocation = SessionState.ApolloSecondExCastTarget[triggerArgs.ProjectileId]
		if not dropLocation then
			dropLocation = SpawnObstacle({ Name = "BlankObstacle", LocationX = triggerArgs.LocationX, LocationY = triggerArgs.LocationY  })
		else
			SessionState.ApolloSecondExCastTarget[triggerArgs.ProjectileId] = nil
		end
		wait (functionArgs.Interval)
		local weaponName = "WeaponCast"
		local projectileName = "ProjectileCast"
		local derivedValues = GetDerivedPropertyChangeValues({
			ProjectileName = projectileName,
			WeaponName = weaponName,
			Type = "Projectile",
		})
		derivedValues.ThingPropertyChanges = derivedValues.ThingPropertyChanges or {}
		derivedValues.ThingPropertyChanges.Graphic = "null"
		local cooldown = functionArgs.Cooldown
		if not CheckCooldown( "ApolloWrathBoon", cooldown ) then
			return
		end
		local projectileId = CreateProjectileFromUnit({ WeaponName = weaponName, Name = projectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = dropLocation, FireFromTarget = true, 
			DataProperties = derivedValues.PropertyChanges, ThingProperties = derivedValues.ThingPropertyChanges })
		SetDamageRadiusMultiplier({ Id = projectileId, Fraction = functionArgs.SecondCastSize })
		ArmAndDetonateProjectiles({ Ids = { projectileId }})
		thread( DestroyOnDelay, { dropLocation }, 0.1)
	end	
end