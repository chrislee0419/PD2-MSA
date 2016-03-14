
-- Preparing global variable and data values
_G.MouseSensitivityAdditions = _G.MouseSensitivityAdditions or {}
MouseSensitivityAdditions._path = ModPath
MouseSensitivityAdditions._data_path = SavePath .. "msa_options.txt"
MouseSensitivityAdditions._data = {}

--[[
	SAVING AND LOADING USER SETTINGS
]]

-- Options menu save function (used to save user settings)
function MouseSensitivityAdditions:Save()
	local file = io.open ( self._data_path, "w+" )
	if file then
		file:write( json.encode( self._data ) )
		file:close()
	end
end

-- Options menu load function
function MouseSensitivityAdditions:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self._data = json.decode( file:read("all") )
		file:close()
	end
end

--[[
	HOOKS
]]

Hooks:Add("LocalizationManagerPostInit", "MSALocalizationManagerPostInit", function( loc )
	loc:load_localization_file( MouseSensitivityAdditions._path .. "loc/en.json" )
end)

Hooks:Add("MenuManagerInitialize", "MSAMenuManagerInitialize", function( menu_manager )
	-- Define options menu callback functions
	MenuCallbackHandler.MSASetPrimarySensitivity = function(self, item)
		MouseSensitivityAdditions._data.primary_sensitivity = item:value()
		MouseSensitivityAdditions:Save()
	end

	MenuCallbackHandler.MSASetSecondarySensitivity = function(self, item)
	end

	MenuCallbackHandler.MSASetToggle = function(self, item)
	end

	-- Load saved user options
	MouseSensitivityAdditions:Load()

	-- Create custom menus
	MenuHelper:LoadFromJsonFile( MouseSensitivityAdditions._path .. "menu/mouse_sensitivity_options.json", MouseSensitivityAdditions, MouseSensitivityAdditions._data )

end)