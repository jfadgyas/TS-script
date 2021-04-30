------------------------------------------------
-- Scenario Script - 'Urantrasport part 1.'
------------------------------------------------

-- true/false defn
FALSE = 0
TRUE = 1

-- condition return values
-- CONDITION_NOT_YET_MET = 0
-- CONDITION_SUCCEEDED = 1
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
--Event triggers--
-----------------------------------------------------------------

function OnEventTrainCheck()
  SysCall ( "CameraManager:ActivateCamera", "camera01", 0 );
end

function OnEventInspectionResult()
	DisplayRecordedMessage("Result")
end

function OnEventRDL01()
	SysCall ( "ScenarioManager:PlayDialogueSound", "RDL01.wav" )
	DisplayRecordedMessage("RangierLeiter01")
end

function OnEventRDL02()
	DisplayRecordedMessage("RangierLeiter02")
end

function OnEventRDL03()
	DisplayRecordedMessage("RangierLeiter03")
end

function OnEventRDL04()
	DisplayRecordedMessage("RangierLeiter04")
end

function OnEventRDL05()
	DisplayRecordedMessage("RangierLeiter05")
end

function OnEventRDL06()
	DisplayRecordedMessage("RangierLeiter06")
end

function OnEventRDL07()
	DisplayRecordedMessage("RangierLeiter07")
end

-----------------------------------------------------------------
--Event functions--
-----------------------------------------------------------------

function StartDisplayResult()
   SysCall ( "ScenarioManager:ShowInfoMessageExt", "5fbf5694-a14b-4101-96ef-220ce8a1883c", "inspection.html", 1, 16, 2, TRUE );
end

function StopDisplayResult()
end

function StartDisplayRangierLeiter01()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "Push the last empty wagon to the end of siding #105", 15, FALSE )
end

function StopDisplayRangierLeiter01()
end

function StartDisplayRangierLeiter02()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "Pull back the rest of the train, and uncouple it on #104", 15, FALSE );
end

function StopDisplayRangierLeiter02()
end

function StartDisplayRangierLeiter03()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "Round the train via the following path: #104, #107, stop on #108. Switch junction, reverse back on #106", 30, FALSE );
end

function StopDisplayRangierLeiter03()
end

function StartDisplayRangierLeiter04()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "Switch junctions to #105 an stop on it. Couple the last loaded wagon at #104 to the front of the engine", 30, FALSE );
end

function StopDisplayRangierLeiter04()
end


function StartDisplayRangierLeiter05()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "So far so good! Drop the carriage off at #107. Use #105, #106, #108, then change direction! Shunt carefully!", 30, FALSE );
end

function StopDisplayRangierLeiter05()
end

function StartDisplayRangierLeiter06()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "Now we have to join the train. Couple the consist at #104, and the empty wagon at #105! Don't forget the junctions!", 30, FALSE );
end

function StopDisplayRangierLeiter06()
end

function StartDisplayRangierLeiter07()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "Well done! Now you have to deliver the train to Vedel yard. There is no direct exit from here, so some more shunting is needed. Pull forward with the train and stop at #101!", 30, FALSE );
end

function StopDisplayRangierLeiter07()
end

function StartDisplayRangierLeiter08()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "Reverse direction and stop at Hamburg hbf 303. You're going to shunt out to the main line now, so keep an eye on the signals!", 30, FALSE );
end

function StopDisplayRangierLeiter08()
end

function StartDisplayRangierLeiter09()
   SysCall ( "ScenarioManager:ShowAlertMessageExt", "RangierLeiter", "The shunting is over. Unfortunately the train is delayed because of the unexpected events. Do your best on the way to Vedel in order to minimize the delay! You get the next instruction from Vedel RangierLeiter after you stopped at #524.", 30, FALSE );
end

function StopDisplayRangierLeiter09()
end