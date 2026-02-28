modutil.mod.Path.Override("CheckPoseidonFont", function (victim, triggerArgs)
	local effectData = EffectData.AmplifyKnockbackEffect
	if not triggerArgs.SourceProjectile or effectData.ProjectileNameBlacklistLookup[triggerArgs.SourceProjectile] then
		return
	end
	if HeroHasTrait(gods.GetInternalBoonName("PoseidonWrathBoon")) then
		mod.PoseidonWrath(victim, triggerArgs)
	else
		if RandomChance( effectData.Chance * GetTotalHeroTraitValue("LuckMultiplier", {IsMultiplier = true})) and CheckCooldown("PoseidonStatusFont", effectData.Cooldown) then
			CreateProjectileFromUnit({ Name = effectData.ProjectileName, DestinationId = victim.ObjectId, Id = CurrentRun.Hero.ObjectId, FireFromTarget = true, DamageMultiplier = GetTotalHeroTraitValue("PoseidonFontMultiplier", { IsMultiplier = true }) })
		end
	end
end)

function mod.PoseidonWrath (victim, triggerArgs)
	local effectData = EffectData.AmplifyKnockbackEffect
	local omegaWaveChance = GetTotalHeroTraitValue("WaveChance")
	local traitData = GetHeroTrait("OmegaPoseidonProjectileBoon")
	local dataProperties = GetProjectileProperty({ ProjectileId = triggerArgs.ProjectileId, Property = "DataProperties" })
	local omegaPoseidonProjectile = 
	{
		Name = "PoseidonOmegaWave",
		Id = CurrentRun.Hero.ObjectId,
		Angle = triggerArgs.ImpactAngle,
		DestinationId = victim.ObjectId,
		FireFromTarget = true,
		DamageMultiplier = (traitData.OnWeaponFiredFunctions.FunctionArgs.DamageMultiplier or 1.0),
		DataProperties =
		{
			StartFx = dataProperties.StartFx,
			ImpactVelocity = triggerArgs.ImpactVelocity or 600, --Check ImpactVelocity in PoseidonWrath functionArgs
			StartDelay = 0
		},
		ProjectileCap = 2,
	}
	if CheckCooldown("PoseidonStatusFont", effectData.Cooldown) then
		CreateProjectileFromUnit({ Name = effectData.ProjectileName, DestinationId = victim.ObjectId, Id = CurrentRun.Hero.ObjectId, FireFromTarget = true, DamageMultiplier = GetTotalHeroTraitValue("PoseidonFontMultiplier", { IsMultiplier = true }) })
		if not HeroHasTrait("OmegaPoseidonProjectileBoon") then
			return
		end
		if RandomChance( omegaWaveChance * GetTotalHeroTraitValue( "LuckMultiplier", { IsMultiplier = true }) ) then
			CreateProjectileFromUnit(omegaPoseidonProjectile)
			local doubleChance = GetTotalHeroTraitValue("DoubleOlympianProjectileChance") * GetTotalHeroTraitValue( "LuckMultiplier", { IsMultiplier = true })
			if RandomChance(doubleChance) then
				wait( GetTotalHeroTraitValue("DoubleOlympianProjectileInterval" ))
				CreateProjectileFromUnit(omegaPoseidonProjectile)
			end
		end
	end
end