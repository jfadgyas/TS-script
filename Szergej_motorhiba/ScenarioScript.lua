------------------------------------------------
-- Scenario Script - 'Motorhiba'
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

gfailtime = 0 -- Reset variable

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

function OnEventInformations()
	DisplayRecordedMessage("FDL01")
end

function OnEventNaplo()
	DisplayRecordedMessage("Naplo")
end

function OnEventOlajnyomas()
	scenariotime = math.floor(SysCall("PlayerEngine:GetSimulationTime")) -- The actual time of the scenario	
	gfailtime = math.random(scenariotime + 60, scenariotime + 300)	-- Random time generator for the fail of the engine
	SysCall ("ScenarioManager:BeginConditionCheck", "TimeToFail" )
end


-----------------------------------------------------------------
--Event functions--
-----------------------------------------------------------------

function StartDisplayFDL01()
	SysCall ( "ScenarioManager:ShowInfoMessageExt", "8049c14b-75fd-4a99-b0dc-a5f55b1819f1", "FDL_Uelzen.html", 14, 16, 1, FALSE )
	SysCall ( "ScenarioManager:PlayDialogueSound", "FDL01.wav")
end

function StopDisplayResult()
end

function StartDisplayNaplo()
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "8049c14b-75fd-4a99-b0dc-a5f55b1819f1", "ubergabe.html", 20, 16, 2, FALSE )
end

function StopDisplayResult()
end

-----------------------------------------------------------------
--Condition checks--
-----------------------------------------------------------------

function TestConditionTimeToFail()
	scenariotime = math.floor(SysCall("PlayerEngine:GetSimulationTime"))
	if (scenariotime == gfailtime) then
		SysCall ( "PlayerEngine:SetControlValue", "Startup", 0, -1); --Kikapcsoljuk a motort
		SysCall ("ScenarioManager:BeginConditionCheck", "Power" )
		return CONDITION_SUCCEEDED
	end
	return CONDITION_NOT_YET_MET
end

function TestConditionPower()
	gfailtime = gfailtime + 60 -- Must take 2 minutes to shut down, and can be restarted
	scenariotime = math.floor(SysCall("PlayerEngine:GetSimulationTime"))
SysCall ( "ScenarioManager:ShowAlertMessageExt", "ujfailtime", gfailtime, 30, FALSE )
SysCall ( "ScenarioManager:ShowAlertMessageExt", "ujfailtime", scenariotime, 30, FALSE )	
		--if (scenariotime >= gfailtime) then
		--	kontroller = SysCall("PlayerEngine:GetControlValue", "Regulator", 0)
		--	if kontroller > 3 then
		--		SysCall ( "PlayerEngine:SetControlValue", "Startup", 0, -1); --Kikapcsoljuk a motort ujra
		--	end
		--ujrahivas, elore kel a kontrolleres feltetel
		--end

		-- utana ha a controller 3 fole megy alljon le a motor
		-- Es hivjuk meg ujra a rutint
	return CONDITION_SUCCEEDED
	--end
	--return CONDITION_NOT_YET_MET
end



