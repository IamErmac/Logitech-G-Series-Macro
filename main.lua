--Description:
--Script write for logitech g102 mouse. For other devices (with > 6 button)
--you can redefine some local definitions below
--By default (at least for first version) script for ONE weapon

--Event types:
--PROFILE_ACTIVATED
--PROFILE_DEACTIVATED

--Mouse buttons defenition
local rightButton = 	2
local leftButton = 		1
local middleButton = 	3
local dpiButton	= 		4
local forwardButton	=	5
local backwardButton = 	6

--Script engine buttons
----if active - script will be work in normal mode
----else - script deactivated
local scriptEnableButton = "scrolllock""
local changeWeaponButton = middleButton

--Some default parameters
local defaultShootingRange = 0.0
local currentWeapon = "none"
local weaponTable = {'ump', 'akm', 'm16a4', 'm416', 'scarl', 'none'}
local weaponTableIndex = #weaponTable


function OnEvent(event, arg)
	
	--log message with event and arg
	OutputLogMessage("%s, %d\n", event, arg)
	
	--Profile activate or deactivate cycle
	--First or last enter to the event function. Define profile status.
	if event == PROFILE_ACTIVATED then
		--if profile is active, start reading left button state
		EnablePrimaryMouseButtonEvents(true)
	elseif event == PROFILE_DEACTIVATED then
		--Else if profile is deactivated, set all values to default
		--and disable mous
		--?? Check default settings and var names
		currentWeapon = "none"
		defaultShootingRange = 0.0
		ReleaseKey(fireKey)
		ReleaseMouseButton(rightButton)
	end
	
	--Weapon change cycle
	if event == "MOUSE_BUTTON_PRESSED" and arg == changeWeaponButton then
		if weaponTableIndex == #weaponTable then
			weaponTableIndex = 1
		else
			weaponTableIndex = weaponTableIndex + 1
		end
		currentWeapon = weaponTable[weaponTableIndex]
	end
	
	--Weapon start shooting cycle
	if event == "MOUSE_BUTTON_PRESSED" and arg == leftButton then
		if currentWeapon = 'none' then
			--standard shooting
		else
			-- shooting with modifier
			
		end
	end
	
	--Weapon stop shooting cycle
	if event == "MOUSE_BUTTON_RELEASED" and arg == leftButton then
		ReleaseKey(fireKey)
	end
end