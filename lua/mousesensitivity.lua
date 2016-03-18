
-- Preparing global variable and data values
_G.MouseSensitivityAdditions = _G.MouseSensitivityAdditions or {}
MouseSensitivityAdditions._path = ModPath
MouseSensitivityAdditions._data_path = SavePath .. "msa_options.txt"
MouseSensitivityAdditions._data = {}
MouseSensitivityAdditions.using_value = "primary"

--[[
	SAVING AND LOADING USER SETTINGS
]]

-- Options menu save function (used to save user settings)
function MouseSensitivityAdditions:Save()
	local file = io.open( self._data_path, "w+" )
	if file then
		file:write( json.encode( self._data ) )
		file:close()
	end
end

-- Options menu load function
function MouseSensitivityAdditions:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self._data = json.decode( file:read("*all") )
		file:close()
	end
end

--[[
	HELPER FUNCTIONS
]]

function MouseSensitivityAdditions:SetUsage( value )
	MouseSensitivityAdditions.using_value = value
end

function MouseSensitivityAdditions:GetUsage()
	return MouseSensitivityAdditions.using_value
end

function MouseSensitivityAdditions:Toggle()
	if MouseSensitivityAdditions.GetUsage == "primary" then
		managers.user:set_setting( "camera_sensitivity", MouseSensitivityAdditions._data.secondary_sensitivity )
		MouseSensitivityAdditions.SetUsage( "secondary" )
	else
		managers.user:set_setting( "camera_sensitivity", MouseSensitivityAdditions._data.primary_sensitivity )
		MouseSensitivityAdditions.SetUsage( "primary" )
	end
	menu_manager:set_mouse_sensitivity(false)
end

--[[
	HOOKS
]]

Hooks:Add("LocalizationManagerPostInit", "MSALocalizationManagerPostInit", function( loc )
	loc:load_localization_file( MouseSensitivityAdditions._path .. "loc/en.json" )
end)

Hooks:Add("MenuManagerInitialize", "MSAMenuManagerInitialize", function( menu_manager )
	-- Load saved user options
	MouseSensitivityAdditions:Load()

	-- Define menu callback functions
	MenuCallbackHandler.MSASetPrimarySensitivity = function(self, item)
		MouseSensitivityAdditions._data.primary_sensitivity = item:value()
		if MouseSensitivityAdditions.GetUsage() == "primary" then
			managers.user:set_setting( "camera_sensitivity", MouseSensitivityAdditions._data.primary_sensitivity )
			menu_manager:set_mouse_sensitivity(false)
		end
		MouseSensitivityAdditions:Save()
	end

	MenuCallbackHandler.MSASetSecondarySensitivity = function(self, item)
		MouseSensitivityAdditions._data.secondary_sensitivity = item:value()
		if MouseSensitivityAdditions.GetUsage() == "secondary" then
			managers.user:set_setting( "camera_sensitivity", MouseSensitivityAdditions._data.secondary_sensitivity )
			menu_manager:set_mouse_sensitivity(false)
		end
		MouseSensitivityAdditions:Save()
	end

	MouseSensitivityAdditions.MSAActivateSecondarySensitivity = function(self)
		MouseSensitivityAdditions.Toggle()
	end

	-- Create custom menus
	MenuHelper:LoadFromJsonFile( MouseSensitivityAdditions._path .. "menu/mouse_sensitivity_additions_options.json", MouseSensitivityAdditions, MouseSensitivityAdditions._data )

end)
