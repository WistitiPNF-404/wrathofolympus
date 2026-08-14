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
	local cleaveCastSizeModifier = SessionMapState.LastBlastMultiplier or 1
	if triggerArgs.name ~= functionArgs.ValidProjectileName then
		return
	end	
	mod.BiggerSecondCast(triggerArgs, functionArgs, cleaveCastSizeModifier)
end

function mod.BiggerSecondCast (triggerArgs, functionArgs, cleaveCastSizeModifier)
	--[[for k,v in pairs(triggerArgs) do
		print(k)
	end]]
	local wrathData = GetHeroTrait(gods.GetInternalBoonName("ApolloWrathBoon"))
	local wrathArgs = wrathData.OnProjectileDeathFunction.Args
	if SessionState.ApolloSecondExCastTarget[triggerArgs.ProjectileId] then
		return
	end
	if not MapState.ApolloSecondOmegaCast then
		MapState.ApolloSecondOmegaCast = {}
	end	
	if triggerArgs.Armed then
		local dropLocation = SessionState.ApolloSecondExCastTarget[triggerArgs.ProjectileId]
		if not dropLocation then
			dropLocation = SpawnObstacle({ Name = "BlankObstacle", LocationX = triggerArgs.LocationX, LocationY = triggerArgs.LocationY  })
		else
			SessionState.ApolloSecondExCastTarget[triggerArgs.ProjectileId] = nil
		end
		wait (functionArgs.WaitForSecondCast)
		
		-- Second Cast Setup

		local maxProjectiles = wrathArgs.MaxProjectiles or 1
		if HeroHasTrait("StaffClearCastAspect") then
			maxProjectiles = maxProjectiles + 1
		end
		local createdProjectiles = {}

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
		for _, projectileName in pairs( wrathArgs.ProjectileName or {} ) do
			local projectileId = CreateProjectileFromUnit({ WeaponName = weaponName, Name = projectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = dropLocation, FireFromTarget = true, 
				DataProperties = derivedValues.PropertyChanges, ThingProperties = derivedValues.ThingPropertyChanges }) 
			local sizeMultiplier = functionArgs.SecondCastSize * cleaveCastSizeModifier

			SetDamageRadiusMultiplier({ Id = projectileId, Fraction = sizeMultiplier, Duration = baseDuration })

			if HeroHasTrait("ApolloCastAreaBoon") then
				for i, traitArgs in pairs(GetHeroTraitValues("CastProjectileModifiers")) do
					SetDamageRadiusMultiplier({ Id = projectileId, Fraction = traitArgs.AreaIncrease * sizeMultiplier })
				end
			end
			table.insert(createdProjectiles, projectileId)
			SessionMapState.SecondCastProjectile = projectileId
			ArmAndDetonateProjectiles({ Ids = { projectileId }})

			-- Circe Staff stuff
			if HeroHasTrait("StaffClearCastAspect") then
				if not MapState.FamiliarUnit then	
					return
				end
				local familiarLocation = nil
				familiarLocation = GetLocation({ Id = MapState.FamiliarUnit.ObjectId })
				if not MapState.FamiliarLocationId then
					MapState.FamiliarLocationId = SpawnObstacle({ Name = "InvisibleTarget", LocationX = familiarLocation.X, LocationY = familiarLocation.Y, Group = "Scripting" })
				end
				local circeProjectileId = CreateProjectileFromUnit({ WeaponName = weaponName, Name = projectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = MapState.FamiliarLocationId, FireFromTarget = true, 
					DataProperties = derivedValues.PropertyChanges, ThingProperties = derivedValues.ThingPropertyChanges })
				derivedValues.PropertyChanges.AttachToOwner = false
				SetDamageRadiusMultiplier({ Id = circeProjectileId, Fraction = sizeMultiplier, Duration = baseDuration })
				
				if HeroHasTrait("ApolloCastAreaBoon") then
					for i, traitArgs in pairs(GetHeroTraitValues("CastProjectileModifiers")) do
						SetDamageRadiusMultiplier({ Id = circeProjectileId, Fraction = traitArgs.AreaIncrease * sizeMultiplier })
					end
				end
				table.insert(createdProjectiles, circeProjectileId)
				SessionMapState.SecondCastProjectile = circeProjectileId
				ArmAndDetonateProjectiles({ Ids = { circeProjectileId }})
			end
		end
		table.insert(MapState.ApolloSecondOmegaCast, createdProjectiles)
		if TableLength( MapState.ApolloSecondOmegaCast ) > maxProjectiles then
			ExpireProjectiles({ ProjectileIds = MapState.ApolloSecondOmegaCast[1] })
			table.remove( MapState.ApolloSecondOmegaCast, 1)
		end
		SessionMapState.LastBlastMultiplier = 1
	end
end

modutil.mod.Path.Wrap("CheckAxeCastArm", function (baseFunc, triggerArgs, args)
	if HeroHasTrait(gods.GetInternalBoonName("ApolloWrathBoon")) then
		SessionMapState.LastBlastMultiplier = args.BlastMultiplier
	end
	return baseFunc(triggerArgs, args)
end)