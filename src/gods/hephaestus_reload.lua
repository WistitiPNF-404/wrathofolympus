modutil.mod.Path.Override("HephRetaliate", function( unit, args )
	if not HeroHasTrait(gods.GetInternalBoonName("HephWrathBoon")) then
		return
	end
	if not unit or unit.SkipModifiers or not CheckCooldown( "HephRetaliate"..unit.ObjectId, args.Cooldown ) then
		return
	end
	if CurrentRun.Hero.HealthBuffer <= 0 then
		return
	end

	local blastModifier = GetTotalHeroTraitValue( "MassiveAttackSizeModifier", { IsMultiplier = true })
	waitUnmodified( args.BlastDelay or 0 )
	if unit then
		CreateProjectileFromUnit({ Name = args.ProjectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = unit.ObjectId, DamageMultiplier = args.DamageMultiplier, BlastRadiusModifier = blastModifier, FireFromTarget = true })
		if unit.IsDead then
			CreateAnimation({ Name = "HephMassiveHit", DestinationId = unit.ObjectId })
		end
	else
		CreateProjectileFromUnit({ Name = args.ProjectileName, Id = CurrentRun.Hero.ObjectId, ProjectileDestinationId = args.ProjectileId, DamageMultiplier = args.DamageMultiplier, BlastRadiusModifier = blastModifier, FireFromTarget = true })
	end
end)