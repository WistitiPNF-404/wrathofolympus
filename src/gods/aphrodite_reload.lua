function mod.AphroWrath ( unit, args )
	local cooldown = args.AphroWrathCooldown
	if not unit or unit.SkipModifiers or not CheckCooldown( "AphroWrathBoon", cooldown ) then
		return
	end
	local weaponName = "WeaponCast"
	local projectileName = "ProjectileCast"
	local derivedValues = GetDerivedPropertyChangeValues({
		ProjectileName = projectileName,
		WeaponName = weaponName,
		Type = "Projectile",
	})
	derivedValues.ThingPropertyChanges = derivedValues.ThingPropertyChanges or {}
	derivedValues.ThingPropertyChanges.Graphic = "null"
	local projectileId = CreateProjectileFromUnit({ WeaponName = weaponName, Name = projectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = CurrentRun.Hero.ObjectId, FireFromTarget = true, 
		DataProperties = derivedValues.PropertyChanges, ThingProperties = derivedValues.ThingPropertyChanges })
			ArmAndDetonateProjectiles({ Ids = { projectileId }})
end

modutil.mod.Path.Wrap("CreateProjectileFromUnit", function (baseFunc, args)
	if args.Name == "AphroditeBurst" then
		local HeartthrobWrathMultiplier = GetTotalHeroTraitValue("ReportedHeartthrobMultiplier", { IsMultiplier = true })
		args.DamageMultiplier = args.DamageMultiplier * HeartthrobWrathMultiplier
	end
	return baseFunc(args)
end)