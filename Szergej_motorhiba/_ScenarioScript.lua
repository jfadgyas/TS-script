------------------------------------------------
-- Scenario Script
------------------------------------------------

-- true/false defn
FALSE = 0
TRUE = 1

-- condition return values
CONDITION_NOT_YET_MET = 0
CONDITION_SUCCEEDED = 1
CONDITION_FAILED = 2

-- Message types
MT_INFO = 0     	-- large centre screen pop up
MT_ALERT = 1    	-- top right alert message

MSG_TOP = 1
MSG_LEFT = 8
MSG_RIGHT = 32

MSG_SMALL = 0
MSG_REG = 1
MSG_LRG = 2

MPH = 2.23693629
KMH = 3.6

FULLSCREEN = 0
FRONT_AND_CENTERED = 1
VIDEO_CALL = 2

PLAY = 1
PAUSE = 2
STOP = 4
SEEK = 8

PAUSE_GAME = 1
DONT_PAUSE_GAME = 0

gSpeedUnits = MPH

gStopLocation = ""
gStopEvent = ""
gStopPlayerServiceName = "Driver Training"


function WatchForStopAt( location, event, tooFarEvent )
	Print ( "WatchForStopAt")
	gStopLocation = location
	gStopEvent = event
	gTooFarEvent = tooFarEvent
end

function ClearStopAt()
	gStopLocation = ""
	gStopEvent = ""
end

function TestConditionStopAtLocation()
	if (gStopLocation ~= "") then
		Speed = math.abs(SysCall("PlayerEngine:GetSpeed"))
		if (Speed <= 0.01) then
--			InfoMessage("Stopped - testing")
			local serviceAtDestination = SysCall("ScenarioManager:IsAtDestination", gStopPlayerServiceName, gStopLocation);
			if (serviceAtDestination == 1) then
				--InfoMessage("Stopped - at destination")
				local stopEvent = gStopEvent
				ClearStopAt()
				OnEvent(stopEvent);
			end
		end
	end
	return FALSE;
end



function TestCondition( condition )
	return _G["TestCondition" .. condition]()
end


-- ====================================================================================
-- == EVENT HANDLERS
-- ====================================================================================
function OnEventStart()
	SysCall ("ScenarioManager:BeginConditionCheck", "StopAtLocation" );
	SysCall ("ScenarioManager:BeginConditionCheck", "Speed" );
	SysCall ("ScenarioManager:BeginConditionCheck", "Overspeed" );
	SysCall ("ScenarioManager:BeginConditionCheck", "Controller" );
end



-- ====================================================================================
-- ====================================================================================
-- ====================================================================================


--[[
function OnEventStartMoving()
	AddSpeedEvent(">1", "Moving")
end

function OnEventMoving()
	DisplayRecordedMessage("MovingCongrats")
	WatchForStopAt("Falmouth Approach 1", "Fred")
end
------------------------

function OnEventFred()
	InfoMessage("FRED!")

end

]]
-- ====================================================================================
-- == MESSAGE HANDLERS
-- ====================================================================================

-- ------------------------------------------------------------------------------------------

-- == Intro Message
function StartDisplayIntro()
	--SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you can get started", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
	SysCall ( "ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "intro.html", 10, MSG_TOP + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayIntro()
end

function StartDisplayIntro2()
	--SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you can get started", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
	SysCall ( "ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "intro2.html", 10, MSG_TOP + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayIntro2()
end

function StartDisplayPullForward()
	--SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you can get started", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
	SysCall ( "ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "pullforward.html", 10, MSG_TOP + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayPullForward()
end

function StartDisplayFillTender()
	--SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you can get started", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
	SysCall ( "ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "filltender.html", 10, MSG_TOP + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayFillTender()
end

function StartDisplayFailed()
	--SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you can get started", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
	SysCall ( "ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "failed.html", 10, MSG_TOP + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayFailed()
end

function StartDisplayComplete()
	--SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you can get started", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
	SysCall ( "ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "complete.html", 10, MSG_TOP + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayComplete()
end

--[[

-- == GetStarted
function StartDisplayGetStarted()
	SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you can get started", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayGetStarted()
end
-- ------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------
-- == MovingCongrats
function StartDisplayMovingCongrats()
	SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you got moving", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayMovingCongrats()
end
-- ------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------
-- == MovingCongrats
function StartDisplayCutOffForwards()
	SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "move your cut off full forwards", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayCutOffForwards()
end
-- ------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------
-- == MovingCongrats
function StartDisplayTimeToGo()
	SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "move your regulator up a bit", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayTimeToGo()
end
-- ------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------
-- == MovingCongrats
function StartDisplayFinished()
	SysCall ("ScenarioManager:ShowInfoMessageExt", "4e082f8e-538d-4b5a-a970-180f9af07d27", "you're done, now go back having changed the point.", 15, MSG_LEFT + MSG_TOP, MSG_SMALL, TRUE );
end

function StopDisplayFinished()
end
]]
-- ------------------------------------------------------------------------------------------


-- ====================================================================================
-- ====================================================================================
-- ====================================================================================
