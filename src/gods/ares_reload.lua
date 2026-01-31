modutil.mod.Path.Wrap("CalculateDoubleDamageChance", function(baseFunc, attacker, victim, weaponData, triggerArgs)
	baseFunc(attacker, victim, weaponData, triggerArgs)
	return mod.CalculatePlasmaDoubleDamageChance (attacker, victim, weaponData, triggerArgs)
end)

function mod.CalculatePlasmaDoubleDamageChance ( attacker, victim, weaponData, triggerArgs )
	--[[if not HeroHasTrait(gods.GetInternalBoonName("AresWrathBoon")) then
		return
	end]]--
	if attacker ~= nil and attacker.OutgoingDoubleDamageModifiers ~= nil then
		local appliedEffectTable = {}
		for i, modifierData in ipairs( attacker.OutgoingDoubleDamageModifiers ) do

			local validWeapon = modifierData.ValidWeaponsLookup == nil or ( modifierData.ValidWeaponsLookup[ triggerArgs.SourceWeapon ] ~= nil and triggerArgs.EffectName == nil )
			local validTrait = modifierData.RequiredTrait == nil or ( attacker == CurrentRun.Hero and HeroHasTrait( modifierData.RequiredTrait ) )
			local validActiveEffect = modifierData.ValidActiveEffects == nil or (victim.ActiveEffects and ContainsAnyKey( victim.ActiveEffects, modifierData.ValidActiveEffects))
			local validEx = true
			if modifierData.IsEx or modifierData.IsNotEx then
				validEx = false
				if weaponData then
					local baseWeaponData = WeaponData[weaponData.Name]
					local isEx = IsExWeapon( weaponData.Name, { Combat = true }, triggerArgs )
					if modifierData.IsEx and isEx then
						validEx = true
					elseif modifierData.IsNotEx and not isEx then
						validEx = true
					end
				end
			end
			if validWeapon and validTrait and validActiveEffect and validEx then
				if modifierData.IncreasingPlasmaCritChance then
					local totalPlasma = CurrentRun.CurrentRoom.BloodDropCount * GetTotalHeroTraitValue( "BloodDropMultiplier", { IsMultiplier = true } )
					addDdMultiplier( modifierData, modifierData.IncreasingPlasmaCritChance * totalPlasma, triggerArgs)
					-- modutil.mod.Hades.PrintOverhead("DoubleDamageChance "..(triggerArgs.DdChance))
				end
			end
		end
	end
	return triggerArgs.DdChance
end

modutil.mod.Path.Wrap("FormatExtractedValue", function(baseFunc, value, extractData)
	if extractData.MultiplyByPlasmaCount then
		value = value * (CurrentRun.CurrentRoom.BloodDropCount * 0.5)
	end
	return baseFunc(value, extractData)
end)