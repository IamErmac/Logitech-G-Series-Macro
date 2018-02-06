--Description:
--Script write for logitech g102 mouse. For other devices (with > 6 button)
--you can redefine some local definitions below
--By default (at least for first version) script for ONE weapon

--Event types:
--PROFILE_ACTIVATED
--PROFILE_DEACTIVATED

--Mouse buttons map
local rightButton = 	2
local leftButton = 	1
local middleButton = 	3
local dpiButton	= 	6
local forwardButton =	5
local backwardButton = 	4

--Script engine buttons
----if active - script will be work in normal mode
----else - script deactivated
local scriptEnableButton = "scrolllock"
local changeWeaponButton = middleButton
local fireKey = "capslock"

--Some default parameters
local defaultShootingRange = 0.0
local shootingRange = 0.0
local currentWeapon = "none"
local weaponTable = {'ump9', 'akm', 'm16a4', 'm416', 'scarl', 'uzi', 'none'}
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
		shootingRange = 0.0
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
		OutputLogMessage("Current weapon is %s\n", currentWeapon, arg)
	end
	
	
	--Weapon start shooting cycle
	if event == "MOUSE_BUTTON_PRESSED" and arg == leftButton then
		if currentWeapon == 'none' then
			PressKey(fireKey)
			repeat
				Sleep(30)
			until not IsMouseButtonPressed(leftButton)
			ReleaseKey(fireKey)
		else
			local shootingRange = 0.0
            repeat
				local intervals,recovery = recoil_value(currentWeapon,shootingRange)
				PressAndReleaseKey(fireKey)
                MoveMouseRelative(0, recovery )
                Sleep(intervals)
                shootingRange = shootingRange + intervals
			until not IsMouseButtonPressed(leftButton)
		end
	end


	
	--Weapon stop shooting cycle
	if event == "MOUSE_BUTTON_RELEASED" and arg == leftButton then
		ReleaseKey(fireKey)
	end
end








---- ignore key ----
---- can use "lalt", "ralt", "alt"  "lshift", "rshift", "shift"  "lctrl", "rctrl", "ctrl"

local ignore_key = "lshift"

--- Sensitivity in Game
--- default is 50.0

local target_sensitivity = 50
local scope_sensitivity = 50
local scope4x_sensitivity = 50

---- Obfs setting
---- Two firing time intervals = weapon_speed * interval_ratio * ( 1 + random_seed * ( 0 ~ 1))
local weapon_speed_mode = false
-- local obfs_mode = false
local obfs_mode = true
local interval_ratio = 0.75
local random_seed = 1

--------------------------------------------------------------------------
----------------        Recoil Table        ------------------------------
---------------- You can fix the value here ------------------------------
--------------------------------------------------------------------------

local recoil_table = {}

recoil_table["ump9"] = {
    basic={18,19,18,19,18,19,19,21,23,24,23,24,23,24,23,24,23,24,23,24,23,24,24,25,24,25,24,25,24,25,24,25,25,26,25,26,25,26,25,26,25,26,25,26,25,26},
    quadruple={83.3,83.3,83.3,83.3,83.3,83.3,83.3,116.7,116.7,116.7,116.7,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3},
    speed = 92
}

recoil_table["akm"] = {
    basic={23.7,23.7,23.7,23.7,23.7,23.7,23.7,23.7,23.7,23.7,23.7,28,28,28,28,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7,29.7},
    quadruple={66.7,66.7,66.7,66.7,66.7,66.7,66.7,66.7,66.7,66.7,66.7,123.3,123.3,123.3,123.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3,93.3},
    speed = 100
}

recoil_table["m16a4"] = {
    basic={25,25,25,29,33,33,32,33,32,32,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30},
    quadruple={86.7,86.7,86.7,86.7,86.7,86.7,86.7,150,150,150,150,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120,120},
    speed = 75
}

recoil_table["m416"] = {
    basic={21,21,21,21,21,21,21,21,21,23,23,24,23,24,25,25,26,27,27,32,31,31,31,31,31,31,31,32,32,32,35,35,35,35,35,35,35,35,35,35,35},
    quadruple={86.7,86.7,86.7,86.7,86.7,86.7,86.7,150,150,150,150,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7},
    speed = 86
}

recoil_table["scarl"] = {
    basic={20,21,22,21,22,22,23,22,23,23,24,24,25,25,25,25,26,27,28,29,30,32,34,34,35,34,35,34,35,34,35,34,34,34,34,34,35,35,35,35,35,35,35,35,35,35},
    quadruple={86.7,86.7,86.7,86.7,86.7,86.7,86.7,150,150,150,150,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7,96.7},
    speed = 96
}

recoil_table["uzi"] = {
    basic={16,17,18,20,21,22,23,24,25,26,28,30,32,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34},
    quadruple={13.3,13.3,13.3,13.3,13.3,21.7,21.7,21.7,21.7,21.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7,46.7},
    speed = 48
}

recoil_table["none"] = {
    basic={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    quadruple={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    speed = 60
}


--------------------------------------------------------------------------
----------------          Function          ------------------------------
--------------------------------------------------------------------------


function convert_sens(unconvertedSens) 
    return 0.002 * math.pow(10, unconvertedSens / 50)
end

function calc_sens_scale(sensitivity)
    return convert_sens(sensitivity)/convert_sens(50)
end

local target_scale = calc_sens_scale(target_sensitivity)
local scope_scale = calc_sens_scale(scope_sensitivity)
local scope4x_scale = calc_sens_scale(scope4x_sensitivity)

function recoil_mode()
        return "basic";

end


function recoil_value(_weapon,_duration)
    local _mode = recoil_mode()
    local step = (math.floor(_duration/100)) + 1
    if step > 40 then
        step = 40
    end
    local weapon_recoil = recoil_table[_weapon][_mode][step]
    -- OutputLogMessage("weapon_recoil = %s\n", weapon_recoil)
    
    local weapon_speed = 30
    if weapon_speed_mode then
        weapon_speed = recoil_table[_weapon]["speed"]
    end
    -- OutputLogMessage("weapon_speed = %s\n", weapon_speed)

    local weapon_intervals = weapon_speed
    if obfs_mode then

        local coefficient = interval_ratio * ( 1 + random_seed * math.random())
        weapon_intervals = math.floor(coefficient  * weapon_speed) 
    end
    -- OutputLogMessage("weapon_intervals = %s\n", weapon_intervals)

    recoil_recovery = weapon_recoil * weapon_intervals / 100
    
    -- issues/3
    if IsMouseButtonPressed(2) then
        recoil_recovery = recoil_recovery / target_scale
    elseif recoil_mode() == "basic" then
        recoil_recovery = recoil_recovery / scope_scale
    elseif recoil_mode() == "quadruple" then
        recoil_recovery= recoil_recovery / scope4x_scale
    end

    return weapon_intervals,recoil_recovery
end