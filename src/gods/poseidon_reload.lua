function mod.PoseidonWrath (unit, functionArgs, triggerArgs)
	-- If Hero doesnt have Ocean Swell, dont crash, just dont do it
	if not HeroHasTrait("OmegaPoseidonProjectileBoon") then
		return
	end

	local traitData = GetHeroTrait("OmegaPoseidonProjectileBoon")

	-- This does nothing currently, but we can for example extract if red color must be used if trigger projectile is Ares one 
	local dataProperties = GetProjectileProperty({ ProjectileId = triggerArgs.ProjectileId, Property = "DataProperties" })

	local omegaPoseidonProjectile = 
	{
		Name = functionArgs.ProjectileName,
		Id = CurrentRun.Hero.ObjectId,
		Angle = triggerArgs.ImpactAngle,
		DestinationId = unit.ObjectId,
		FireFromTarget = true,
		DamageMultiplier = (traitData.OnWeaponFiredFunctions.FunctionArgs.DamageMultiplier or functionArgs.FallbackWeaponDamageMultiplier) * functionArgs.DamageMultiplier,
		DataProperties =
		{
			StartFx = dataProperties.StartFx,
			ImpactVelocity = triggerArgs.ImpactVelocity or functionArgs.ImpactVelocity,
			StartDelay = 0
		},
		ProjectileCap = 2,
	}

	local count = 1
	for i=1, count do
		CreateProjectileFromUnit(omegaPoseidonProjectile)
		local doubleChance = GetTotalHeroTraitValue("DoubleOlympianProjectileChance") * GetTotalHeroTraitValue( "LuckMultiplier", { IsMultiplier = true })
		if RandomChance(doubleChance) then
			wait( GetTotalHeroTraitValue("DoubleOlympianProjectileInterval" ))
			CreateProjectileFromUnit(omegaPoseidonProjectile)
		end
	end
end