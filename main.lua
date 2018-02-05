--Event types:
--PROFILE_ACTIVATED
--PROFILE_DEACTIVATED

--Mouse buttons defenition
local rightButton = 1
local leftButton = 2
local middleButton = 3
local dpiButton	= 4
local forwardButton	=	5
local backwardButton = 6

--Some default parameters
local defaultShootingRange = 0.0

function OnEvent(event, arg)
	OutputLogMessage("%s, %d\n", event, arg)
	if (event == PROFILE_ACTIVATED) then
		EnablePrimaryMouseButtonEvents(true)
	elseif event == PROFILE_DEACTIVATED then
		currentWeapon = "none"
		shootDuration = 0.0
		ReleaseKey(fireKey)
		ReleaseMouseButton(rightButton)
	end
end