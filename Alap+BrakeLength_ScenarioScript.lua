------------------------------------------------
-- Scenario Script - 'Shunting down the line'
------------------------------------------------

-- true/false defn
FALSE = 0
TRUE = 1

-- condition return values
CONDITION_NOT_YET_MET = 0
CONDITION_SUCCEEDED = 1
-- CONDITION_FAILED = 2

-- Message types
-- MT_INFO = 0     	-- large centre screen pop up
-- MT_ALERT = 1    	-- top right alert message

-- MSG_TOP = 1
-- MSG_LEFT = 8
-- MSG_RIGHT = 32

-- MSG_SMALL = 0
-- MSG_REG = 1
-- MSG_LRG = 2

-- Brake test Variables
braketeststate = 0 -- 0=begin, odd=brake applied, even=released
stillwaiting = 0
endofwaiting = 0
pipename=nil
brakepercent = math.random( 55, 100 ) --percentage to lower brakemass, freight
--brakepercent = math.random( 90, 130 ) --percentage to lower brakemass, passenger, usualy over 100%

-----------------------------------------------------------------
--Message displaying function--
-----------------------------------------------------------------

function DisplayRecordedMessage( messageName )
   SysCall("RegisterRecordedMessage", "StartDisplay" .. messageName, "StopDisplay" .. messageName, 1);
end

-----------------------------------------------------------------
--Event handler function--
-----------------------------------------------------------------

function OnEvent(event)
  _G["OnEvent" .. event]();
end

-----------------------------------------------------------------
--Condition handler function--
-----------------------------------------------------------------

function TestCondition( condition )
	return _G["TestCondition" .. condition]()
end

-----------------------------------------------------------------
--Event triggers--
-----------------------------------------------------------------

function OnEventBrakeTest()
	SysCall ("ScenarioManager:BeginConditionCheck", "BrakeTest" )
end

function OnEventQuickBrakeTest()
	braketeststate=2
	endofwaiting=-1
	SysCall ("ScenarioManager:BeginConditionCheck", "BrakeTest" )
end

function OnEventBrakeTestEnd()
	SysCall ("ScenarioManager:EndConditionCheck", "BrakeTest" )
	braketeststate=nil
	endofwaiting=nil
	enginenumber=nil
	trainlength=nil
	trainmass=nil
	brakemass=nil
	brakepercent=nil
	i=nil
	brake=nil
	cylinderpressure=nil
	linepressure=nil
	pipename=nil
end

-----------------------------------------------------------------
--Event functions--
-----------------------------------------------------------------

function StartDisplayBegintest()
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "Full brake test - Leakage test", "Sit in the front cabin then pull the train brake to the first position! The brake line pressure must not drop by 0,5 bar after a minute. Keep your eyes on it!", 10, 16, 1, FALSE )
end

function StopDisplayBegintest()
end

function StartDisplayApply1()
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "Full brake test - Leakage test result", "The brake pipe is properly sealed, no leakage detected. Release brake!", 5, 16, 1, FALSE )
end

function StopDisplayApply1()
end

function StartDisplayApply3()
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "Quick brake test - Apply test result", "The train's brake apply successful. Reduce pipe pressure to 0 bar then release the brake!", 5, 16, 1, FALSE )
end

function StopDisplayApply3()
end

function StartDisplayRelease2()
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "Quick brake test - Apply test", "Apply brake, reduce the pipe pressure by at least 1 bar!", 5, 16, 1, FALSE )
end

function StopDisplayRelease2()
end

function StartDisplayRelease4()
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "Quick brake test - failure", "Brake pipe pressure has not been flushed! Reduce the pipe pressure to 0 bar!", 5, 16, 1, FALSE )
end

function StopDisplayRelease4()
end

function StartDisplayRelease5()  
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "Brake test successful", fekbarca, 10, 16, 1, FALSE )
end

function StopDisplayRelease5()
end

-----------------------------------------------------------------
--Condition checks--
-----------------------------------------------------------------

function TestConditionBrakeTest()
-- eloszor oldani kell, osszekapcsolas, feltoltes, ezt a kapcsolas utan egy perccel sima messagevel. Ez nem lesz, mert nem lehet a legnyomast valtoztatni
-- egyet huzni kell rajta, legvesztesegmeres 1 perc
-- oldas, befekezesvizsgalat legalbb 2-es allasban, ez is 1 perc
-- oldas: eloszor gyorsfek, majd oldas
-- megfekezettseg kezbesites

-- Braketest
	if (braketeststate == 0) then	
		DisplayRecordedMessage("Begintest")
		braketeststate = 1		
	end


-- Variables
	
	brake = SysCall ( "PlayerEngine:GetControlValue", "TrainBrakeControl", 0)	-- Fekkar allasa
	cylinderpressure = math.floor(SysCall ( "PlayerEngine:GetControlValue", "LocoBrakeCylinderPressureBAR", 0))	-- Fekhenger nyomas oldashoz, ha 0 a fek fel van engedve	
	trainlength = math.floor(SysCall ("PlayerEngine:GetConsistLength") * 0.1)
	if pipename == nil then
	pipename = {"BrakePipePressureBAR", "AirBrakePipePressureBAR", "HLL"}
		i=1
		while SysCall("PlayerEngine:ControlExists", pipename[i], 0) ~= 1 do
			i=i+1
		end
	end
	linepressure = SysCall ( "PlayerEngine:GetControlValue", pipename[i], 0)	-- Ha be lett huzva a gyorsfek, akkor mehetunk tovabb, ha nem, a teszt nem sikeres

-- Applying brake

	if (brake >= 0.1) then
		if (endofwaiting == 0) then
			endofwaiting = math.floor(SysCall("PlayerEngine:GetSimulationTime")) + trainlength
			SysCall ( "ScenarioManager:ShowAlertMessageExt", "Brake test in progress...", trainlength-1, FALSE )
		end
		stillwaiting = math.floor(SysCall("PlayerEngine:GetSimulationTime")) -- needed to know we are still doing the test
		if (stillwaiting == endofwaiting) then
			DisplayRecordedMessage("Apply"..braketeststate)
			endofwaiting = -1	-- needed, because rounding makes this happen more than 1 time
			braketeststate = braketeststate + 1			
		end
	end

-- Release brake

	if (cylinderpressure == 0 and endofwaiting == -1) then
		DisplayRecordedMessage("Release"..braketeststate)
		if (braketeststate == 5) then
			SysCall ("ScenarioManager:TriggerDeferredEvent", "BrakeTestEnd", 0 )
		end
		if (braketeststate == 4) then
		else
		endofwaiting = 0
		braketeststate = braketeststate + 1
		end
	end
	
	if (linepressure == 0 and braketeststate == 4) then
		braketeststate = braketeststate + 1	-- means everything done as should
		enginenumber=SysCall("PlayerEngine:GetRVNumber")
		-- trainlength=SysCall ("PlayerEngine:GetConsistLength")
		trainmass=SysCall ("PlayerEngine:GetConsistTotalMass")
		brakemass=trainmass * (brakepercent / 100)
		brakepercent=(brakemass/trainmass)*100
		if (brakepercent>80) then
			bremsart="P"
		else
			bremsart="G"
		end
		if (brakepercent>111) then
			zugart="O"
		elseif (brakepercent<65) then
			zugart="U"
		else
			zugart="M"
		end
		fekbarca=string.format("%s%s%s%03d%s%02d%s%d%s%s%s%s%s", "DB Bahn 	Loknr: ", enginenumber, "\n Length: ", trainlength, "m  Brakemass: ", brakemass, "t  Brake%: ", brakepercent, "%", "\n PZB Zugart: ", zugart, " Bremsart: ", bremsart)
	end
end