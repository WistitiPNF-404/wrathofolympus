function mod.SetupHermesSlow ( unit, functionArgs ) --based on StartSpellSlow
	functionArgs = ShallowCopyTable(functionArgs)

	if functionArgs.LoopingSound then
		SessionMapState.TimeSlowSoundId = PlaySound({ Name = functionArgs.LoopingSound })
	end
	SessionMapState.TimeSlowActive = true
	mod.StartHermesWrathPresentation()
	if not GameState.Flags.UsedSlowAgainstChronos and CurrentRun.BossHealthBarRecord.Chronos then
		GameState.Flags.UsedSlowAgainstChronos = true
	end
	mod.HermesWrath ( unit, functionArgs )
end

function mod.StartHermesWrathPresentation() --based on StartSpellSlowPresentation
	thread( PlayVoiceLines, GlobalVoiceLines.ChronosSpellResistVoiceLines, true )
	local duration = 0.25
	AdjustColorGrading({ Name = "MoonDust", Duration = duration })
	AdjustRadialBlurDistance({ Fraction = 0.05, Duration = duration })
	AdjustRadialBlurStrength({ Fraction = 2, Duration = duration })
	if ConfigOptionCache.GraphicsQualityPreset ~= "GraphicsQualityPreset_Low" then
		CreateAnimation({ Name = "SpellSlowFx", DestinationId = CurrentRun.Hero.ObjectId })
	end
end

function mod.HermesWrath ( unit, functionArgs ) --based on StartWeaponSlowMotion
	GameplaySetElapsedTimeMultiplier({ ElapsedTimeMultiplier = functionArgs.Modifier, Name = "HermesTimeSlow", Force = functionArgs.Force })
	thread( mod.EndHermesWrath, unit, functionArgs )
end

function mod.EndHermesWrath ( unit, functionArgs ) --based on EndWeaponSlowMotion
	if functionArgs == nil then
		return
	end
	if functionArgs.Duration then
		if functionArgs.EndWarnNum then
			local totalDuration = functionArgs.Duration
			waitUnmodified( functionArgs.Duration - functionArgs.EndWarnNum, "HermesTimeSlow" )
			for i=1, functionArgs.EndWarnNum do
				CallFunctionName( functionArgs.EndWarnPresentationFunction )
				waitUnmodified( 1, "HermesTimeSlow" )
			end
		else
			waitUnmodified( functionArgs.Duration, "HermesTimeSlow" )
		end
	end
	CallFunctionName( functionArgs.EndSlowMotionFunctionName, functionArgs )
	GameplaySetElapsedTimeMultiplier({ ElapsedTimeMultiplier = functionArgs.Modifier, Reverse = true, Name = "HermesTimeSlow" })
end

function mod.HermesEndTimeSlow( args ) --based on EndTimeSlow
	SessionMapState.TimeSlowActive = nil
	if SessionMapState.TimeSlowSoundId then
		StopSound({ Id = SessionMapState.TimeSlowSoundId, Duration = 0.2 })
	end
	if args.EndSlowMotionSound ~= nil then
		PlaySound({ Name = args.EndSlowMotionSound, Id = CurrentRun.Hero.ObjectId })
	end
	thread(EndSpellSlowPresentation)
end