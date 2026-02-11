function mod.SetupHermesSlow ( unit, functionArgs )
	functionArgs = ShallowCopyTable(functionArgs)

	if functionArgs.LoopingSound then
		SessionMapState.TimeSlowSoundId = PlaySound({ Name = functionArgs.LoopingSound })
	end
	SessionMapState.TimeSlowActive = true
	if not GameState.Flags.UsedSlowAgainstChronos and CurrentRun.BossHealthBarRecord.Chronos then
		GameState.Flags.UsedSlowAgainstChronos = true
	end
	mod.HermesWrath ( unit, functionArgs )
end

function mod.HermesWrath ( unit, functionArgs )
	GameplaySetElapsedTimeMultiplier({ ElapsedTimeMultiplier = functionArgs.Modifier, Name = "HermesTimeSlow", Force = functionArgs.Force })
	thread( mod.EndHermesWrath, unit, functionArgs )
end

function mod.EndHermesWrath ( unit, functionArgs )
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