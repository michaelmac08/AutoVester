script_name("Autobind")
script_author("akacross", "spnKO", "Adib")
script_url("https://akacross.net/")
script_tester = {"Taro", "Marowan", "Adib", "Kobe", "Liam", "Patsy"}

--[[Special thanks to Farid(Faction Locker) and P-Greggy(Autofind)]]

local script_version = 2.8
local script_version_text = '2.8'

require"lib.moonloader"
require"lib.sampfuncs"

local imgui, ffi, effil = require 'mimgui', require 'ffi', require 'effil'
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local mainc = imgui.ImVec4(0.98, 0.26, 0.26, 1.00)
local ped, h = playerPed, playerHandle
local sampev = require 'lib.samp.events'
local mem = require 'memory'
local lfs = require 'lfs'
local dlstatus = require('moonloader').download_status
local flag = require ('moonloader').font_flag
local vk = require 'vkeys'
local keys  = require 'game.keys'
local wm  = require 'lib.windows.message'
local fa = require 'fAwesome6'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local path = getWorkingDirectory() .. '\\config\\' 
local resourcepath = getWorkingDirectory() .. '/resource/'
local skinspath = resourcepath .. 'skins/' 
local audiopath =  resourcepath .. "audio/"
local audiofolder =  audiopath .. thisScript().name .. "/"
local autobind_cfg = path .. thisScript().name .. '.ini'
local script_path = thisScript().path
local script_url = "https://cdn.akacross.net/autobind/autobind.lua"
local update_url = "https://cdn.akacross.net/autobind/autobind.txt"
local skins_url = "https://cdn.akacross.net/autobind/resource/skins/"
local sounds_url = "https://cdn.akacross.net/autobind/resource/audio/Autobind/"

local autobind = {}
local _enabled = true
local _autovest = true
local isIniLoaded = false
local isGamePaused = false
local menu = new.bool(false)
local menu2 = new.bool(false)
local menuactive = false
local menu2active = false
local bmactive = false
local factionactive = false
local gangactive = false
local frisk_menu = new.bool(false)
local pointturf_menu = new.bool(false)
local streamedplayers_menu = new.bool(false)
local menuname = {
	"Commands",
	"Autovest",
	"Autobind"
}
local cursorposx = 1.9
local imguisettings = new.bool(false)
local _menu = 2
local _submenu = 1
local skinmenu = new.bool(false)
local bmmenu = new.bool(false)
local factionlockermenu = new.bool(false)
local ganglockermenu = new.bool(false)
local _you_are_not_bodyguard = true
local paths = {}
local sounds = nil
local autoaccepter = false
local autoacceptertoggle = false
local specstate = false
local updateskin = false
local faidtoggle = false
local timeset = {false, false}
local flashing = {false, false}
local point_capper_timer = 750
local turf_capper_timer = 1050
local faid_timer = 3
local _last_vest = 0
local _last_point_capper = 0
local _last_turf_capper = 0
local _last_point_capper_refresh = 0
local _last_turf_capper_refresh = 0
local _last_timer_faid = 0
local sampname = 'Nobody'
local playerid = -1
local sampname2 = 'Nobody'
local playerid2 = -1
local point_capper = 'Nobody'
local turf_capper = 'Nobody'
local point_capper_capturedby = 'Nobody'
local turf_capper_capturedby = 'Nobody'
local point_location = "No captured point" 
local turf_location = "No captured turf "
local cooldown = 0
local pointtime = 0
local turftime = 0
local pointspam = false
local turfspam = false
local disablepointspam = false
local disableturfspam = false
local hide = {false, false}
local capper_hide = false
local skins = {}
local factions = {61, 71, 73, 141, 163, 164, 165, 166, 191, 255, 265, 266, 267, 280, 281, 282, 283, 284, 285, 286, 287, 288, 294, 312, 300, 301, 306, 309, 310, 311, 120}
local factions_color = {-14269954, -7500289, -14911565}
local changekey = {}
local changekey2 = {}
local PressType = {KeyDown = isKeyDown, KeyPressed = wasKeyPressed}
local inuse_key = false
local bmbool = false
local bmstate = 0
local bmcmd = 0
local lockerbool = false
local lockerstate = 0
local lockercmd = 0
local gangbool = false
local gangstate = 0
local gangcmd = 0
local inuse_move = false
local temp = {
	{x = 0, y = 0},
	{x = 0, y = 0},
	{x = 0, y = 0},
	{x = 0, y = 0},
	{x = 0, y = 0}
}
local size = {
	{x = 0, y = 0},
	{x = 0, y = 0},
	{x = 0, y = 0}
}
local menusize = {190, 325}
local selectedbox = {false, false, false,false}
local skinTexture = {}
local selected = -1
local page = 1
local bike, moto = {[481] = true, [509] = true, [510] = true}, {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true}
local captog = false
local autofind, cooldown_bool = false, false
local streamedplayers = nil
local fid = nil
local selected2 = false
local inuse_move = false

local fa6fontlist = {
	"thin",
	"light",
	"regular",
	"solid",
	"duotone"
}

local pointnamelist = {
	"Fossil Fuel Company",
	"Materials Pickup 1",
	"Drug Factory",
	"Materials Factory 1",
	"Drug House",
	"Materials Pickup 2",
	"Crack Lab",
	"Materials Factory 2",
	"Auto Export Company",
	"Materials Pickup 3"
}

local turfnamelist = {
	"East Beach",
	"Las Colinas",
	"Playa del Seville",
	"Los Flores",
	"East Los Santos East",
	"East Los Santos West",
	"Jefferson",
	"Glen Park",
	"Ganton",
	"North Willowfield",
	"South Willowfield",
	"Idlewood",
	"El Corona",
	"Little Mexico",
	"Commerce",
	"Pershing Square",
	"Verdant Bluffs",
	"LSI Airport",
	"Ocean Docks",
	"Downtown Los Santos",
	"Mulholland Intersection",
	"Temple",
	"Mulholland",
	"Market",
	"Vinewood",
	"Marina",
	"Verona Beach",
	"Richman",
	"Rodeo",
	"Santa Maria Beach"
}

local pointzoneids = {
	30,
	31,
	38,
	32,
	36,
	37,
	34,
	35,
	39
}

local turfzoneids = {
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	21,
	22,
	23,
	24,
	25,
	26
}

imgui.OnInitialize(function()
	mainc = imgui.ImVec4(autobind.imcolor[1], autobind.imcolor[2], autobind.imcolor[3], autobind.imcolor[4])
	apply_custom_style() -- apply custom style
	
	local config = imgui.ImFontConfig()
	config.MergeMode = true
    config.PixelSnapH = true
    config.GlyphMinAdvanceX = 14
    local builder = imgui.ImFontGlyphRangesBuilder()
    local list = {
		"SHIELD_PLUS",
		"POWER_OFF",
		"FLOPPY_DISK",
		"REPEAT",
		"PERSON_BOOTH",
		"ERASER",
		"RETWEET",
		"GEAR",
		"CART_SHOPPING",
		"ARROWS_REPEAT"
	}
	for _, b in ipairs(list) do
		builder:AddText(fa(b))
	end
	defaultGlyphRanges1 = imgui.ImVector_ImWchar()
	builder:BuildRanges(defaultGlyphRanges1)
	imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85(autobind.fa6), 14, config, defaultGlyphRanges1[0].Data)
	
	imgui.GetIO().IniFilename = nil
end)

imgui.OnFrame(function() return isIniLoaded and (autobind.notification[1] or hide[1] or menu[0]) and not isGamePaused and not isPauseMenuActive() and not sampIsScoreboardOpen() and sampGetChatDisplayMode() > 0 and not isKeyDown(VK_F10) and _enabled and _autovest end,
function()
	if menu[0] then
		if mposX >= autobind.offeredpos[1] and 
		   mposX <= autobind.offeredpos[1] + size[1].x and 
		   mposY >= autobind.offeredpos[2] and 
		   mposY <= autobind.offeredpos[2] + size[1].y then
			if imgui.IsMouseClicked(0) and not inuse_move then
				inuse_move = true 
				selectedbox[1] = true
				temp[1].x = mposX - autobind.offeredpos[1]
				temp[1].y = mposY - autobind.offeredpos[2]
			end
		end
		if selectedbox[1] then
			if imgui.IsMouseReleased(0) then
				inuse_move = false 
				selectedbox[1] = false
			else
				autobind.offeredpos[1] = mposX - temp[1].x
				autobind.offeredpos[2] = mposY - temp[1].y
			end
		end
	end

	imgui.SetNextWindowPos(imgui.ImVec2(autobind.offeredpos[1], autobind.offeredpos[2]))
	imgui.Begin("offered", nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		if autobind.progressbar.toggle then
			imgui.AnimProgressBar('##Timer', autobind.timer - (localClock() - _last_vest), autobind.timer, 50, imgui.ImVec2(-1,15), 
				imgui.ImVec4(autobind.progressbar.colorfade[1], autobind.progressbar.colorfade[2], autobind.progressbar.colorfade[3], autobind.progressbar.colorfade[4]), 
				imgui.ImVec4(autobind.progressbar.color[1], autobind.progressbar.color[2], autobind.progressbar.color[3], autobind.progressbar.color[4])
			)
		end
		if autobind.timer - (localClock() - _last_vest) > 0 then
			imgui.Text(string.format("%sYou offered a vest to:\n%s[%s]\nVestmode: %s", autobind.timertext and string.format("Next vest in: %d\n", autobind.timer - (localClock() - _last_vest)) or '', sampname, playerid, vestmodename(autobind.vestmode)))
		else
			imgui.Text(string.format("%sYou offered a vest to:\n%s[%s]\nVestmode: %s", autobind.timertext and "Next vest in: 0\n" or "", sampname, playerid, vestmodename(autobind.vestmode)))
				
			if autobind.notification[1] and not autobind.showpreoffered then
				sampname = 'Nobody'
				playerid = -1
			end
				
			if autobind.notification_hide[1] then
				sampname = 'Nobody'
				playerid = -1
				hide[1] = false
			end
		end
		if menu[0] then
			size[1] = imgui.GetWindowSize()
		end
	imgui.End()
end).HideCursor = true

imgui.OnFrame(function() return isIniLoaded and (autobind.notification[2] or hide[2] or menu[0]) and not isGamePaused and not isPauseMenuActive() and not sampIsScoreboardOpen() and sampGetChatDisplayMode() > 0 and not isKeyDown(VK_F10) and _enabled and _autovest end,
function()
	if menu[0] then
		if mposX >= autobind.offerpos[1] and 
		   mposX <= autobind.offerpos[1] + size[2].x and 
		   mposY >= autobind.offerpos[2] and 
		   mposY <= autobind.offerpos[2] + size[2].y then
			if imgui.IsMouseClicked(0) and not inuse_move then
				inuse_move = true 
				selectedbox[2] = true
				temp[2].x = mposX - autobind.offerpos[1]
				temp[2].y = mposY - autobind.offerpos[2]
			end
		end
		if selectedbox[2] then
			if imgui.IsMouseReleased(0) then
				inuse_move = false 
				selectedbox[2] = false
			else
				autobind.offerpos[1] = mposX - temp[2].x
				autobind.offerpos[2] = mposY - temp[2].y
			end
		end
	end

	imgui.SetNextWindowPos(imgui.ImVec2(autobind.offerpos[1], autobind.offerpos[2]))
	imgui.Begin("offer", nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		imgui.Text(string.format("You got an offer from: \n%s[%s]\nAutoaccepter is %s", sampname2, playerid2, autoaccepter and 'enabled' or 'disabled'))
		if menu[0] then
			size[2] = imgui.GetWindowSize()
		end
	imgui.End()
end).HideCursor = true

imgui.OnFrame(function() return isIniLoaded and (autobind.notification_capper or capper_hide or menu[0]) and not isGamePaused and not isPauseMenuActive() and not sampIsScoreboardOpen() and sampGetChatDisplayMode() > 0 and not isKeyDown(VK_F10) and _enabled end,
function()
	if menu[0] then
		if mposX >= autobind.capperpos[1] and 
		   mposX <= autobind.capperpos[1] + size[3].x and 
		   mposY >= autobind.capperpos[2] and 
		   mposY <= autobind.capperpos[2] + size[3].y then
			if imgui.IsMouseClicked(0) and not inuse_move then
				inuse_move = true 
				selectedbox[3] = true
				temp[3].x = mposX - autobind.capperpos[1]
				temp[3].y = mposY - autobind.capperpos[2]
			end
		end
		if selectedbox[3] then
			if imgui.IsMouseReleased(0) then
				inuse_move = false 
				selectedbox[3] = false
			else
				autobind.capperpos[1] = mposX - temp[3].x
				autobind.capperpos[2] = mposY - temp[3].y
			end
		end
	end

	imgui.SetNextWindowPos(imgui.ImVec2(autobind.capperpos[1], autobind.capperpos[2]))
	imgui.Begin("point/turf", nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		local point_turf_timer = (autobind.point_turf_mode and point_capper_timer or turf_capper_timer) - (localClock() - (autobind.point_turf_mode and _last_point_capper or _last_turf_capper))
		local minutes, seconds = disp_time(point_turf_timer)
		if autobind.point_turf_mode then
			if timeset[1] then
				if point_turf_timer > 0 then
					imgui.Text(string.format("%s is attemping to capture the Point\nCaptured by %s\nLocation: %s\nMinutes: %d, Seconds: %d", point_capper, point_capper_capturedby, point_location, minutes, seconds))
				else
					imgui.Text(string.format("%s is attemping to capture the Point\nCaptured by %s\nLocation: %s\nMinutes: 0, Seconds: 0", point_capper, point_capper_capturedby, point_location))
				end
			else
				imgui.Text(string.format("%s is attemping to capture the Point\nCaptured by %s\nLocation: %s\nMinutes: %s", point_capper, point_capper_capturedby, point_location, pointtime))
			end
		else	
			if timeset[2] then
				if point_turf_timer > 0 then
					imgui.Text(string.format("%s is attemping to capture the Turf\nCaptured by %s\nLocation: %s\nMinutes: %d, Seconds: %d", turf_capper, turf_capper_capturedby, turf_location, minutes, seconds))
				else
					imgui.Text(string.format("%s is attemping to capture the Turf\nCaptured by %s\nLocation: %s\nMinutes: 0, Seconds: 0", turf_capper, turf_capper_capturedby, turf_location))
				end
			else
				imgui.Text(string.format("%s is attemping to capture the Turf\nCaptured by %s\nLocation: %s\nMinutes: %s", turf_capper, turf_capper_capturedby, turf_location, turftime))
			end
		end
		if menu[0] then
			size[3] = imgui.GetWindowSize()
		end
	imgui.End()
end).HideCursor = true


imgui.OnFrame(function() return isIniLoaded and menu[0] and not isGamePaused end,
function()
	if not menu2[0] then
		menu[0] = false
	end

	if menu[0] then
		if mposX >= autobind.menupos[1] - 190 and 
		   mposX <= autobind.menupos[1] + (455 - 190) + menusize[1] + ((bmmenu[0] and 165 or 0) + (factionlockermenu[0] and 129 or 0) + (ganglockermenu[0] and 113 or 0)) and 
		   mposY >= autobind.menupos[2] and 
		   mposY <= autobind.menupos[2] + 20 then
			if imgui.IsMouseClicked(0) and not inuse_move then
				inuse_move = true 
				selectedbox[4] = true
				temp[4].x = mposX - autobind.menupos[1]
				temp[4].y = mposY - autobind.menupos[2]
			end
		end
		if selectedbox[4] then
			if imgui.IsMouseReleased(0) then
				inuse_move = false 
				selectedbox[4] = false
			else
				autobind.menupos[1] = mposX - temp[4].x
				autobind.menupos[2] = mposY - temp[4].y
			end
		end
	end 
	imgui.SetNextWindowPos(imgui.ImVec2(autobind.menupos[1] - 190, autobind.menupos[2]))
	imgui.SetNextWindowSize(imgui.ImVec2(menusize[1], menusize[2]))
	imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
	
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
	else
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
	end
		imgui.Begin(fa.SHIELD_PLUS.." "..script.this.name.." - Version: " .. script_version_text, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
			if imgui.IsWindowFocused() then
				menuactive = true
			else
				menuactive = false
			end
			imgui.BeginChild("##1", imgui.ImVec2(85, 262), true)
				imgui.SetCursorPos(imgui.ImVec2(5, 5))
				if imgui.CustomButton(
					fa.POWER_OFF, 
					_enabled and imgui.ImVec4(0.15, 0.59, 0.18, 0.7) or imgui.ImVec4(1, 0.19, 0.19, 0.5), 
					_enabled and imgui.ImVec4(0.15, 0.59, 0.18, 0.5) or imgui.ImVec4(1, 0.19, 0.19, 0.3), 
					_enabled and imgui.ImVec4(0.15, 0.59, 0.18, 0.4) or imgui.ImVec4(1, 0.19, 0.19, 0.2), 
					imgui.ImVec2(75, 37.5)) then
					_enabled = not _enabled
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Toggles Notifications')
					imgui.PopStyleVar()
				end
			
				imgui.SetCursorPos(imgui.ImVec2(5, 43))
				
				if imgui.CustomButton(
					fa.FLOPPY_DISK,
					imgui.ImVec4(0.16, 0.16, 0.16, 0.9), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(75, 37.5)) then
					autobind_saveIni()
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Save the Script')
					imgui.PopStyleVar()
				end
		  
				imgui.SetCursorPos(imgui.ImVec2(5, 81))

				if imgui.CustomButton(
					fa.REPEAT, 
					imgui.ImVec4(0.16, 0.16, 0.16, 0.9), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(75, 37.5)) then
					autobind_loadIni()
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Reload the Script')
					imgui.PopStyleVar()
				end

				imgui.SetCursorPos(imgui.ImVec2(5, 119))

				if imgui.CustomButton(
					fa.ERASER, 
					imgui.ImVec4(0.16, 0.16, 0.16, 0.9), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(75, 37.5)) then
					autobind_blankIni()
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Reset the Script to default settings')
					imgui.PopStyleVar()
				end

				imgui.SetCursorPos(imgui.ImVec2(5, 157))

				if imgui.CustomButton(
					fa.RETWEET .. ' Update',
					imgui.ImVec4(0.16, 0.16, 0.16, 0.9), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1),  
					imgui.ImVec2(75, 37.5)) then
					update_script(true, true)
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Update the script')
					imgui.PopStyleVar()
				end
			imgui.EndChild()
			
			imgui.SetCursorPos(imgui.ImVec2(80, 20))
			
			imgui.BeginChild("##3", imgui.ImVec2(105, 392), true)
				imgui.SetCursorPos(imgui.ImVec2(5, 5))
				if imgui.CustomButton(
					"Commands",
					_menu == 1 and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(100, 37.5)) then
					_menu = 1
				end
			
				imgui.SetCursorPos(imgui.ImVec2(5, 43))
				
				if imgui.CustomButton(
					"Autovest",
					_menu == 2 and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(100, 37.5)) then
					_menu = 2
				end
		  
				imgui.SetCursorPos(imgui.ImVec2(5, 81))

				if imgui.CustomButton(
					"Autobind", 
					_menu == 3 and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(100, 37.5)) then
					_menu = 3
				end

				imgui.SetCursorPos(imgui.ImVec2(5, 119))

				if imgui.CustomButton(
					"Frisk",  
					frisk_menu[0] and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(100, 37.5)) then
					frisk_menu[0] = not frisk_menu[0]
				end

				imgui.SetCursorPos(imgui.ImVec2(5, 157))

				if imgui.CustomButton(
					"Point/Turf",
					pointturf_menu[0] and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1),  
					imgui.ImVec2(100, 37.5)) then
					pointturf_menu[0] = not pointturf_menu[0]
				end
			imgui.EndChild()
			
			imgui.SetCursorPos(imgui.ImVec2(0, 214))
			
			imgui.BeginChild("##4", imgui.ImVec2(185, 392), true)
				imgui.SetCursorPos(imgui.ImVec2(5, 5))
				if imgui.CustomButton(
					"Streamed Players",
					streamedplayers_menu[0] and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(180, 37.5)) then
					streamedplayers_menu[0] = not streamedplayers_menu[0]
				end
				
				imgui.SetCursorPos(imgui.ImVec2(5, 43))
				if imgui.CustomButton(
					"Autosave",
					autobind.autosave and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(89, 20)) then
					autobind.autosave = not autobind.autosave 
					autobind_saveIni() 
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Autosave')
					imgui.PopStyleVar()
				end
				
				imgui.SetCursorPos(imgui.ImVec2(95, 43))
				if imgui.CustomButton(
					"Autoupdate",
					autobind.autoupdate and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(89, 20)) then
					autobind.autoupdate = not autobind.autoupdate 
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Auto-Update')
					imgui.PopStyleVar()
				end
				
				imgui.SetCursorPos(imgui.ImVec2(5, 64))
				if imgui.CustomButton(
					vestmodename(autobind.vestmode),
					imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(89, 20)) then
					if autobind.vestmode == 4 then
						autobind.vestmode = 0
					else
						autobind.vestmode = autobind.vestmode + 1
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(95, 64))
				if imgui.CustomButton(
					autobind.point_turf_mode and 'Point' or 'Turf',
					imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(89, 20)) then
					autobind.point_turf_mode = not autobind.point_turf_mode
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('Toggles between point and turf mode')
					imgui.PopStyleVar()
				end
				
				imgui.SetCursorPos(imgui.ImVec2(5, 85))
				imgui.PushItemWidth(89)
				imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
				if imgui.BeginCombo("##1", "Lockers") then
					if imgui.Button(fa.CART_SHOPPING .. " BM Settings") then
						bmmenu[0] = not bmmenu[0]
						factionlockermenu[0] = false
						ganglockermenu[0] = false
					end
						
					if imgui.Button(fa.CART_SHOPPING .. " Faction Locker") then
						factionlockermenu[0] = not factionlockermenu[0]
						bmmenu[0] = false
						ganglockermenu[0] = false
					end
					
					if imgui.Button(fa.CART_SHOPPING .. " Gang Locker") then
						ganglockermenu[0] = not ganglockermenu[0]
						bmmenu[0] = false
						factionlockermenu[0] = false
					end
					imgui.EndCombo()
				end
				imgui.PopItemWidth()
				imgui.PopStyleVar()
				
				imgui.SetCursorPos(imgui.ImVec2(95, 85))
				if imgui.CustomButton(
					"ImGUI",
					imguisettings[0] and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
					imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
					imgui.ImVec2(89, 20)) then
					imguisettings[0] = not imguisettings[0]
				end
				if imgui.IsItemHovered() then
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						imgui.SetTooltip('ImGui Settings')
					imgui.PopStyleVar()
				end

			imgui.EndChild()
		imgui.End()
	imgui.PopStyleVar(1)
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PopStyleColor()
		imgui.PopStyleColor()
	end
end)

imgui.OnFrame(function() return isIniLoaded and menu2[0] and not isGamePaused end,
function()
	imgui.SetNextWindowPos(imgui.ImVec2(autobind.menupos[1], autobind.menupos[2]))
	imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
	else
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
	end
		imgui.Begin(menuname[_menu] .. (_menu == 3 and (frisk_menu[0] and " - Frisk" or "") or "") .. (_menu == 3 and (pointturf_menu[0] and " - Point/Turf" or "") or "").. (_menu == 3 and (streamedplayers_menu[0] and " - Streamed Players" or "") or ""), menu2, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
			
			if imgui.IsWindowFocused() then
				menu2active = true
			else
				menu2active = false
			end
			
			if _menu == 1 then
				imgui.SetWindowSizeVec2(imgui.ImVec2(455, 440))
			end
			
			if _menu == 2 then
				if autobind.advancedview then
					imgui.SetWindowSizeVec2(imgui.ImVec2(455, 350))
				else
					imgui.SetWindowSizeVec2(imgui.ImVec2(455, 185))
				end	
			end
			
			if _menu == 3 then
				if not pointturf_menu[0] and not streamedplayers_menu[0] and frisk_menu[0] then
					if frisk_menu[0] then
						imgui.SetWindowSizeVec2(imgui.ImVec2(455, 270))
					else
						imgui.SetWindowSizeVec2(imgui.ImVec2(455, 210))
					end
				end
				
				if not frisk_menu[0] and not streamedplayers_menu[0] and pointturf_menu[0] then
					if pointturf_menu[0] then
						imgui.SetWindowSizeVec2(imgui.ImVec2(455, 245))
					else
						imgui.SetWindowSizeVec2(imgui.ImVec2(455, 210))
					end
				end
				
				if not frisk_menu[0] and not pointturf_menu[0] and streamedplayers_menu[0] then
					if streamedplayers_menu[0] then
						imgui.SetWindowSizeVec2(imgui.ImVec2(455, 295))
					else
						imgui.SetWindowSizeVec2(imgui.ImVec2(455, 210))
					end
				end
				
				if pointturf_menu[0] and frisk_menu[0] and not streamedplayers_menu[0] then
					imgui.SetWindowSizeVec2(imgui.ImVec2(455, 310))
				end
				
				if pointturf_menu[0] and not frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetWindowSizeVec2(imgui.ImVec2(455, 335))
				end
				
				if not pointturf_menu[0] and frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetWindowSizeVec2(imgui.ImVec2(455, 360))
				end
				
				if pointturf_menu[0] and frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetWindowSizeVec2(imgui.ImVec2(455, 400))
				end
				
				if not pointturf_menu[0] and not frisk_menu[0] and not streamedplayers_menu[0] then
					imgui.SetWindowSizeVec2(imgui.ImVec2(455, 210))
				end
			end
			
			if _menu == 2 and autobind.advancedview then
				imgui.SetCursorPos(imgui.ImVec2(0, 25))

				imgui.BeginChild("##menuskins/names", imgui.ImVec2(455, 88), false)
			  
					imgui.SetCursorPos(imgui.ImVec2(0,0))
					if imgui.CustomButton(fa.GEAR .. '  Settings',
						_submenu == 1 and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
						imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
						imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
						imgui.ImVec2(149, 75)) then
						_submenu = 1
					end

					imgui.SetCursorPos(imgui.ImVec2(150, 0))
					  
					if imgui.CustomButton(fa.PERSON_BOOTH .. '  Skins',
						_submenu == 2 and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
						imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
						imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
						imgui.ImVec2(149, 75)) then
						_submenu = 2
					end
					
					imgui.SetCursorPos(imgui.ImVec2(300, 0))
					
					if imgui.CustomButton(fa.PERSON_BOOTH .. '  Names',
						_submenu == 3 and imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8) or imgui.ImVec4(0.16, 0.16, 0.16, 0.9),
						imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.5), 
						imgui.ImVec4(mainc.x, mainc.y, mainc.z, 1), 
						imgui.ImVec2(149, 75)) then
						_submenu = 3
					end
				imgui.EndChild()
			end
			
			if _submenu == 1 and (_menu == 1 or _menu == 2 or _menu == 3) then
				if _menu == 2 then
					if autobind.advancedview then
						if frisk_menu[0] then
							imgui.SetCursorPos(imgui.ImVec2(300, 105))
							imgui.BeginChild("##keybindsadv", imgui.ImVec2(151, 285), false)
						else
							imgui.SetCursorPos(imgui.ImVec2(300, 105))
							imgui.BeginChild("##keybindsadv", imgui.ImVec2(151, 245), false)
						end
					else
						if frisk_menu[0] then
							imgui.SetCursorPos(imgui.ImVec2(300, 25))
							imgui.BeginChild("##keybindsbasic", imgui.ImVec2(151, 195), false)
						else
							imgui.SetCursorPos(imgui.ImVec2(300, 25))
							imgui.BeginChild("##keybindsbasic", imgui.ImVec2(151, 155), false)
						end
					end
				else
					if _menu == 3 then
						if frisk_menu[0] then
							imgui.SetCursorPos(imgui.ImVec2(300, 25))
							imgui.BeginChild("##keybindsautobind1", imgui.ImVec2(151, 220), true)
						else
							imgui.SetCursorPos(imgui.ImVec2(300, 25))
							imgui.BeginChild("##keybindsautobind2", imgui.ImVec2(151, 180), true)
						end
					elseif _menu == 1 then
						imgui.SetCursorPos(imgui.ImVec2(300, 25))
						imgui.BeginChild("##keybindsautobind3", imgui.ImVec2(151, 400), true)
					end
				end

					dualswitch("Accept Bodyguard:", "Accept", true)
					keychange('Accept')
						
					dualswitch("Offer Bodyguard:", "Offer", true)
					keychange('Offer')
							
					dualswitch("Black Market:", "BlackMarket", true)
					keychange('BlackMarket')
							
					dualswitch("Faction Locker:", "FactionLocker", true)
					keychange('FactionLocker')
							
					dualswitch("Gang Locker:", "GangLocker", true)
					keychange('GangLocker')
							
					dualswitch("BikeBind:", "BikeBind", true)
					keychange('BikeBind')
							
					dualswitch("Sprintbind:", "SprintBind", true)
					imgui.PushItemWidth(40) 
					delay = new.int(autobind.SprintBind.delay)
					if imgui.DragInt('Speed', delay, 0.5, 0, 200) then 
						autobind.SprintBind.delay = delay[0] 
					end
					imgui.PopItemWidth()
					keychange('SprintBind')
							
					dualswitch("Frisk:", "Frisk", true)
					keychange('Frisk')
							
					dualswitch("TakePills:", "TakePills", true)
					keychange('TakePills')
							
					dualswitch("FAid:", "FAid", true)
					keychange('FAid')
							
					dualswitch("Accept Death:", "AcceptDeath", true)
					keychange('AcceptDeath')
				imgui.EndChild()
			end

			if _menu == 2 then
				if autobind.advancedview then
					imgui.SetCursorPos(imgui.ImVec2(0, 105))
				else
					imgui.SetCursorPos(imgui.ImVec2(0, 25))
				end
			else
				imgui.SetCursorPos(imgui.ImVec2(0, 25))
			end
			if _menu == 1 then
				imgui.BeginChild("##menu", imgui.ImVec2(435, 415), true)
					imgui.SetCursorPos(imgui.ImVec2(5, 5))
					imgui.BeginChild("##commands", imgui.ImVec2(435, 410), true)
							imgui.Text("Settings Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_autovestsettingscmd = new.char[25](autobind.autovestsettingscmd)
							if imgui.InputText('##Autobindsettings command', text_autovestsettingscmd, sizeof(text_autovestsettingscmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.autovestsettingscmd = u8:decode(str(text_autovestsettingscmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Vest Near Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_vestnearcmd = new.char[25](autobind.vestnearcmd)
							if imgui.InputText('##vestnearcmd', text_vestnearcmd, sizeof(text_vestnearcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.vestnearcmd = u8:decode(str(text_vestnearcmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Sex Near Command")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_sexnearcmd = new.char[25](autobind.sexnearcmd)
							if imgui.InputText('##sexnearcmd', text_sexnearcmd, sizeof(text_sexnearcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.sexnearcmd = u8:decode(str(text_sexnearcmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Repair Near Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_repairnearcmd = new.char[25](autobind.repairnearcmd)
							if imgui.InputText('##repairnearcmd', text_repairnearcmd, sizeof(text_repairnearcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.repairnearcmd = u8:decode(str(text_repairnearcmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("hFind Command: ")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_hfindcmd = new.char[25](autobind.hfindcmd)
							if imgui.InputText('##hfindcmd', text_hfindcmd, sizeof(text_hfindcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.hfindcmd = u8:decode(str(text_hfindcmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Spam Cap Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_tcapcmd = new.char[25](autobind.tcapcmd)
							if imgui.InputText('##tcapcmd', text_tcapcmd, sizeof(text_tcapcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.tcapcmd = u8:decode(str(text_tcapcmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Sprint Bind Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_sprintbindcmd = new.char[25](autobind.sprintbindcmd)
							if imgui.InputText('##sprintbindcmd', text_sprintbindcmd, sizeof(text_sprintbindcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.sprintbindcmd = u8:decode(str(text_sprintbindcmd))
							end
							imgui.PopItemWidth()
							imgui.Text("Bike Bind Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_bikebindcmd = new.char[25](autobind.bikebindcmd)
							if imgui.InputText('##bikebindcmd', text_bikebindcmd, sizeof(text_bikebindcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.bikebindcmd = u8:decode(str(text_bikebindcmd))
							end
							imgui.PopItemWidth()


							imgui.Text("Autovest Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_autovestcmd = new.char[25](autobind.autovestcmd)
							if imgui.InputText('##autovestcmd', text_autovestcmd, sizeof(text_autovestcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.autovestcmd = u8:decode(str(text_autovestcmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Autoaccepter Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							
							local text_autoacceptercmd = new.char[25](autobind.autoacceptercmd)
							if imgui.InputText('##autoacceptercmd', text_autoacceptercmd, sizeof(text_autoacceptercmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.autoacceptercmd = u8:decode(str(text_autoacceptercmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("DD-Mode Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_ddmodecmd = new.char[25](autobind.ddmodecmd)
							if imgui.InputText('##ddmodecmd', text_ddmodecmd, sizeof(text_ddmodecmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.ddmodecmd = u8:decode(str(text_ddmodecmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Vest Mode Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_vestmodecmd = new.char[25](autobind.vestmodecmd)
							if imgui.InputText('##vestmodecmd', text_vestmodecmd, sizeof(text_vestmodecmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.vestmodecmd = u8:decode(str(text_vestmodecmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Faction Both Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_factionbothcmd = new.char[25](autobind.factionbothcmd)
							if imgui.InputText('##factionbothcmd', text_factionbothcmd, sizeof(text_factionbothcmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.factionbothcmd = u8:decode(str(text_factionbothcmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Point Mode Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_pointmodecmd = new.char[25](autobind.pointmodecmd)
							if imgui.InputText('##pointmodecmd', text_pointmodecmd, sizeof(text_pointmodecmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.pointmodecmd = u8:decode(str(text_pointmodecmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Turf Mode Command:")
							imgui.SameLine()
							imgui.PushItemWidth(125)
							local text_turfmodecmd = new.char[25](autobind.turfmodecmd)
							if imgui.InputText('##turfmodecmd', text_turfmodecmd, sizeof(text_turfmodecmd), imgui.InputTextFlags.EnterReturnsTrue) then
								autobind.turfmodecmd = u8:decode(str(text_turfmodecmd))
							end
							imgui.PopItemWidth()
							
							imgui.Text("Changing this will require the script to restart")
							imgui.Spacing()
							imgui.SetCursorPosX(imgui.GetWindowWidth() / 5.7)
							if imgui.Button(fa.ARROWS_REPEAT .. " Save and restart the script") then
								autobind_saveIni()
								thisScript():reload()
							end
							
					imgui.EndChild()
				imgui.EndChild()
			end
			if _menu == 2 then
				if _submenu == 1 then
					imgui.BeginChild("##menu", imgui.ImVec2(280, 265), false)
						imgui.SetCursorPos(imgui.ImVec2(5, 5))
						imgui.BeginChild("##config", imgui.ImVec2(290, 255), false)
							if autobind.advancedview then
								imgui.PushItemWidth(290)
								local text_skinsurl = new.char[256](autobind.skinsurl)
								if imgui.InputText('##skinsurl', text_skinsurl, sizeof(text_skinsurl), imgui.InputTextFlags.EnterReturnsTrue) then
									autobind.skinsurl = u8:decode(str(text_skinsurl))
								end
								imgui.PopItemWidth()
								
								if imgui.Checkbox("Diamond Donator", new.bool(autobind.ddmode)) then
									autobind.ddmode = not autobind.ddmode
									autobind.timer = autobind.ddmode and 7 or 12
									
									if autobind.ddmode then
										_you_are_not_bodyguard = true
									end
								end
								
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('If you are Diamond Donator toggle this on.')
									imgui.PopStyleVar()
								end
								
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								
								
								if imgui.Checkbox("Timer fix", new.bool(autobind.timercorrection)) then
									autobind.timercorrection = not autobind.timercorrection
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Corrects the timer, if a vest is missed')
									imgui.PopStyleVar()
								end
								
								if imgui.Checkbox("Show Preoffered",  new.bool(autobind.showpreoffered)) then
									autobind.showpreoffered = not autobind.showpreoffered
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('If disabled it will erase the offered value to "Nobody", at the end of the timer')
									imgui.PopStyleVar()
								end
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								
								if imgui.Checkbox("Show Prevest",  new.bool(autobind.showprevest)) then
									autobind.showprevest = not autobind.showprevest
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('If vest is below 49 it will disable prevest show')
									imgui.PopStyleVar()
								end
								if imgui.Checkbox("Enabled by default", new.bool(autobind.enablebydefault)) then
									autobind.enablebydefault = not autobind.enablebydefault
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Enables autovester by default if enabled')
									imgui.PopStyleVar()
								end
								
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								if imgui.Checkbox("Compare Both", new.bool(autobind.factionboth)) then
									autobind.factionboth = not autobind.factionboth
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('Compare faction (ticked color and skin) or (unticked color or skin)')
									imgui.PopStyleVar()
								end
								
								if imgui.Checkbox("Always Offered",  new.bool(autobind.notification[1])) then
									autobind.notification[1] = not autobind.notification[1]
									if autobind.notification[1] then
										autobind.notification_hide[1] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('Always Display Offered')
									imgui.PopStyleVar()
								end
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								if imgui.Checkbox("Hide Offered",  new.bool(autobind.notification_hide[1])) then
									autobind.notification_hide[1] = not autobind.notification_hide[1]
									if autobind.notification_hide[1] then
										autobind.notification[1] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('Always Hide Offered')
									imgui.PopStyleVar()
								end

								if imgui.Checkbox("Always Offer",  new.bool(autobind.notification[2])) then
									autobind.notification[2] = not autobind.notification[2]
									if autobind.notification[2] then
										autobind.notification_hide[2] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Always Display Offer')
									imgui.PopStyleVar()
								end
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								
								if imgui.Checkbox("Hide Offer",  new.bool(autobind.notification_hide[2])) then
									autobind.notification_hide[2] = not autobind.notification_hide[2]
									if autobind.notification_hide[2] then
										autobind.notification[2] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Always Hide Offer')
									imgui.PopStyleVar()
								end
								
								if imgui.Checkbox("Progress Bar", new.bool(autobind.progressbar.toggle)) then
									autobind.progressbar.toggle = not autobind.progressbar.toggle
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Toggles progress bar from the menu')
									imgui.PopStyleVar()
								end
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								if imgui.Checkbox("Timer Text", new.bool(autobind.timertext)) then
									autobind.timertext = not autobind.timertext
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Toggles timer text from the menu')
									imgui.PopStyleVar()
								end
								
								imgui.PushItemWidth(120)
								imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								if imgui.BeginCombo("##Message Spam2", "Message Spam##2") then
									if imgui.Checkbox("Offered Vest", new.bool(autobind.messages.offered)) then
										autobind.messages.offered = not autobind.messages.offered
									end
									if imgui.Checkbox("Offer Vest", new.bool(autobind.messages.bodyguard)) then
										autobind.messages.bodyguard = not autobind.messages.bodyguard
									end
									if imgui.Checkbox("Accepted Your Vest", new.bool(autobind.messages.acceptedyour)) then
										autobind.messages.acceptedyour = not autobind.messages.acceptedyour
									end
									if imgui.Checkbox("Accepted There Vest", new.bool(autobind.messages.accepted)) then
										autobind.messages.accepted = not autobind.messages.accepted
									end
									
									if imgui.Checkbox("You Must Wait", new.bool(autobind.messages.youmustwait)) then
										autobind.messages.youmustwait = not autobind.messages.youmustwait
									end
									if imgui.Checkbox("Aiming", new.bool(autobind.messages.aiming)) then
										autobind.messages.aiming = not autobind.messages.aiming
									end
									if imgui.Checkbox("Player Not Near", new.bool(autobind.messages.playnotnear)) then
										autobind.messages.playnotnear = not autobind.messages.playnotnear
									end
									imgui.EndCombo()
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Disables messages sent by the server')
									imgui.PopStyleVar()
								end
								imgui.PopItemWidth()
								imgui.PopStyleVar()
						
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								imgui.PushItemWidth(120)
								imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								if imgui.BeginCombo("##ColorsProgressBar", "Progressbar") then
									local color2 = new.float[4](autobind.progressbar.color[1], autobind.progressbar.color[2], autobind.progressbar.color[3], autobind.progressbar.color[4])
									if imgui.ColorEdit4('##Color', color2, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel) then 
										autobind.progressbar.color[1] = color2[0]
										autobind.progressbar.color[2] = color2[1]
										autobind.progressbar.color[3] = color2[2]
										autobind.progressbar.color[4] = color2[3]
									end
									imgui.SameLine()
									imgui.Text("Color")
									local color1 = new.float[4](autobind.progressbar.colorfade[1], autobind.progressbar.colorfade[2], autobind.progressbar.colorfade[3], autobind.progressbar.colorfade[4])
									if imgui.ColorEdit4('##Fade Color', color1, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel) then 
										autobind.progressbar.colorfade[1] = color1[0]
										autobind.progressbar.colorfade[2] = color1[1]
										autobind.progressbar.colorfade[3] = color1[2]
										autobind.progressbar.colorfade[4] = color1[3]
									end
									imgui.SameLine()
									imgui.Text("Fade Color")
									imgui.EndCombo()
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Progress Bar Colors')
									imgui.PopStyleVar()
								end
								imgui.PopItemWidth()
								imgui.PopStyleVar()
								
								imgui.PushItemWidth(120)
								imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								if imgui.BeginCombo("##Offered Sound", "Offered Sound") then
									sound_dropdownmenu(1)
									imgui.EndCombo()
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Plays a sound if you offered a vest to someone')
									imgui.PopStyleVar()
								end
								imgui.PopItemWidth()
								imgui.PopStyleVar()
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								imgui.PushItemWidth(120)
								imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								if imgui.BeginCombo("##Offer Sound", "Offered Sound") then
									sound_dropdownmenu(2)
									imgui.EndCombo()
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Plays a sound if you get a offer from someone')
									imgui.PopStyleVar()
								end
								imgui.PopItemWidth()
								imgui.PopStyleVar()
							
								if imgui.Checkbox(autobind.advancedview and "Advanced View" or "Basic View", new.bool(autobind.advancedview)) then
									autobind.advancedview = not autobind.advancedview
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Switches between advanced view and basic view')
									imgui.PopStyleVar()
								end
							else				
								if imgui.Checkbox("Diamond Donator", new.bool(autobind.ddmode)) then
									autobind.ddmode = not autobind.ddmode
									autobind.timer = autobind.ddmode and 7 or 12
									
									if autobind.ddmode then
										_you_are_not_bodyguard = true
									end
								end
								
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('If you are Diamond Donator toggle this on.')
									imgui.PopStyleVar()
								end
								
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								
								
								if imgui.Checkbox("Timer fix", new.bool(autobind.timercorrection)) then
									autobind.timercorrection = not autobind.timercorrection
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Corrects the timer, if a vest is missed')
									imgui.PopStyleVar()
								end
								
								if imgui.Checkbox("Enabled by default", new.bool(autobind.enablebydefault)) then
									autobind.enablebydefault = not autobind.enablebydefault
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Enables autovester by default if enabled')
									imgui.PopStyleVar()
								end
								
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								if imgui.Checkbox("Compare Both", new.bool(autobind.factionboth)) then
									autobind.factionboth = not autobind.factionboth
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('Compare faction (ticked color and skin) or (unticked color or skin)')
									imgui.PopStyleVar()
								end
								
								if imgui.Checkbox("Always Offered",  new.bool(autobind.notification[1])) then
									autobind.notification[1] = not autobind.notification[1]
									if autobind.notification[1] then
										autobind.notification_hide[1] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('Always Display Offered')
									imgui.PopStyleVar()
								end
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								if imgui.Checkbox("Hide Offered",  new.bool(autobind.notification_hide[1])) then
									autobind.notification_hide[1] = not autobind.notification_hide[1]
									if autobind.notification_hide[1] then
										autobind.notification[1] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))	
										imgui.SetTooltip('Always Hide Offered')
									imgui.PopStyleVar()
								end

								if imgui.Checkbox("Always Offer",  new.bool(autobind.notification[2])) then
									autobind.notification[2] = not autobind.notification[2]
									if autobind.notification[2] then
										autobind.notification_hide[2] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Always Display Offer')
									imgui.PopStyleVar()
								end
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								
								if imgui.Checkbox("Hide Offer",  new.bool(autobind.notification_hide[2])) then
									autobind.notification_hide[2] = not autobind.notification_hide[2]
									if autobind.notification_hide[2] then
										autobind.notification[2] = false
									end
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Always Hide Offer')
									imgui.PopStyleVar()
								end
								
								imgui.PushItemWidth(120)
								imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								if imgui.BeginCombo("##Offered Sound", "Offered Sound") then
									sound_dropdownmenu(1)
									imgui.EndCombo()
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Plays a sound if you offered a vest to someone')
									imgui.PopStyleVar()
								end
								imgui.PopItemWidth()
								imgui.PopStyleVar()
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								imgui.PushItemWidth(120)
								imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								if imgui.BeginCombo("##Offer Sound", "Offered Sound") then
									sound_dropdownmenu(2)
									imgui.EndCombo()
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Plays a sound if you get a offer from someone')
									imgui.PopStyleVar()
								end
								imgui.PopItemWidth()
								imgui.PopStyleVar()
							
								if imgui.Checkbox(autobind.advancedview and "Advanced View" or "Basic View", new.bool(autobind.advancedview)) then
									autobind.advancedview = not autobind.advancedview
								end
								if imgui.IsItemHovered() then
									imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
										imgui.SetTooltip('Switches between advanced view and basic view')
									imgui.PopStyleVar()
								end
								imgui.SameLine()
								imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
								
								if imgui.Button("Update URL") then
									loadskinidsurl()
								end
							end
						imgui.EndChild()	
					imgui.EndChild()	
				end
				if _submenu == 2 then
					if autobind.customskins then
						if imgui.Checkbox("Skin Mode", new.bool(autobind.customskins)) then
							autobind.customskins = not autobind.customskins
						end
						imgui.SameLine()
						if imgui.Button(u8"Add Skin") then
							autobind.skins2[#autobind.skins2 + 1] = 0
						end
						for k, v in ipairs(autobind.skins2) do
							local skinid = new.int[1](v)
							if imgui.InputInt('##skinid'..k, skinid, 1, 1) then
								if skinid[0] <= 311 and skinid[0] >= 0 then
									autobind.skins2[k] = skinid[0]
								end
							end 
							imgui.SameLine()
							if imgui.Button(u8"Pick Skin##"..k) then
								skinmenu[0] = not skinmenu[0]
								selected = k
							end
							imgui.SameLine()
							if imgui.Button(u8"x##"..k) then
								table.remove(autobind.skins2, k)
							end
						end
					else
						if imgui.Checkbox("Gang Mode", new.bool(autobind.customskins)) then
							autobind.customskins = not autobind.customskins
						end
						imgui.SameLine()
						if imgui.Checkbox("Custom Gang Skins", new.bool(autobind.gangcustomskins)) then
							autobind.gangcustomskins = not autobind.gangcustomskins
							if not autobind.gangcustomskins then
								loadskinidsurl()
							end
						end
						imgui.SameLine()
						if imgui.Button(u8"Add Gang Skin") then
							autobind.skins[#autobind.skins + 1] = 0
						end
						imgui.SameLine()
						if imgui.Button("Update URL") then
							loadskinidsurl()
						end
						for k, v in ipairs(autobind.skins) do
							local skinid = new.int[1](v)
							if imgui.InputInt('##skinid'..k, skinid, 1, 1) then
								if skinid[0] <= 311 and skinid[0] >= 0 then
									autobind.skins[k] = skinid[0]
								end
							end 
							imgui.SameLine()
							if imgui.Button(u8"Pick Skin##"..k) then
								skinmenu[0] = not skinmenu[0]
								selected = k
							end
							imgui.SameLine()
							if imgui.Button(u8"x##"..k) then
								table.remove(autobind.skins, k)
							end
						end
					end
				end
					
				if _submenu == 3 then
					if imgui.Button(u8"Add Name") then
						autobind.names[#autobind.names + 1] = "Firstname_Lastname"
					end
					imgui.SameLine()
					if imgui.Checkbox("GetTarget",  new.bool(autobind.gettarget)) then
						autobind.gettarget = not autobind.gettarget
					end
					
					for key, value in pairs(autobind.names) do
						nick = new.char[128](value)
						if imgui.InputText('Nickname##'..key, nick, sizeof(nick), imgui.InputTextFlags.EnterReturnsTrue) then
							if autobind.gettarget then
								local res, playerid, playername = getTarget(u8:decode(str(nick)))
								if res then
									autobind.names[key] = playername
								end
							else
								autobind.names[key] = u8:decode(str(nick))
							end
						end
						imgui.SameLine()
						if imgui.Button(u8"x##"..key) then
							table.remove(autobind.names, key)
						end
					end
				end
			end
			if _menu == 3 then
				imgui.BeginChild("##menu", imgui.ImVec2(285, 180), false)
					imgui.SetCursorPos(imgui.ImVec2(5, 5))
					imgui.BeginChild("##config", imgui.ImVec2(290, 170), false)
						if imgui.Checkbox('Cap Spam (Turfs)', new.bool(captog)) then 
							captog = not captog 
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Spams /capturf every 1.5 seconds')
							imgui.PopStyleVar()
						end
						
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						
						if imgui.Checkbox('Capturf (Turfs)', new.bool(autobind.capturf)) then 
							autobind.capturf = not autobind.capturf
							if autobind.capturf then
								autobind.capture = false
							end
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Types /capturf when the message appears')
							imgui.PopStyleVar()
						end
						if imgui.Checkbox('Disable after capping', new.bool(autobind.disableaftercapping)) then 
							autobind.disableaftercapping = not autobind.disableaftercapping 
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Disables /capture and /capturf at the end of the them')
							imgui.PopStyleVar()
						end
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						
						
						if imgui.Checkbox('Capture (Points)', new.bool(autobind.capture)) then 
							autobind.capture = not autobind.capture 
							if autobind.capture then
								autobind.capturf = false
							end
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Types /capture when the message appears')
							imgui.PopStyleVar()
						end
						if imgui.Checkbox('Auto Accept Repair', new.bool(autobind.autoacceptrepair)) then 
							autobind.autoacceptrepair = not autobind.autoacceptrepair 
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Auto accepts repair at 1 dollar')
							imgui.PopStyleVar()
						end
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						
						if imgui.Checkbox('Auto Accept Sex', new.bool(autobind.autoacceptsex)) then 
							autobind.autoacceptsex = not autobind.autoacceptsex 
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Auto accepts sex at any value')
							imgui.PopStyleVar()
						end
						
						if imgui.Checkbox('Auto Accept Vest', new.bool(autoaccepter)) then 
							autoaccepter = not autoaccepter 
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Auto accepts vest')
							imgui.PopStyleVar()
						end
						
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						
						if imgui.Checkbox('Auto Badge', new.bool(autobind.badge)) then 
							autobind.badge = not autobind.badge 
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Automatically enables /badge when going to the hopsital.')
							imgui.PopStyleVar()
						end
						if imgui.Checkbox("Auto FAid", new.bool(autobind.faid)) then
							autobind.faid = not autobind.faid
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Automatically enables firstaid kit')
							imgui.PopStyleVar()
						end
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						imgui.PushItemWidth(40) 
						local faidnumber = new.int(autobind.faidnumber)
						if imgui.DragInt('Faid Number', faidnumber, 1, 15, 99) then 
							autobind.faidnumber = faidnumber[0] 
						end
						imgui.PopItemWidth()
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Specifies ammount of HP to use faid')
							imgui.PopStyleVar()
						end
						
						if imgui.Checkbox("Renew FAid", new.bool(autobind.renewfaid)) then
							autobind.renewfaid = not autobind.renewfaid
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Auto renews after wearing off')
							imgui.PopStyleVar()
						end
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						imgui.PushItemWidth(40)
						if imgui.Checkbox("FAid Only AV", new.bool(not autobind.faidautovestonly)) then
							autobind.faidautovestonly = not autobind.faidautovestonly
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('If enabled auto firstaid only works if autovester is enabled')
							imgui.PopStyleVar()
						end
						
						imgui.PushItemWidth(120)
						imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
						if imgui.BeginCombo("##Message Spam", "Message Spam") then
							if imgui.Checkbox("Wear off", new.bool(autobind.messages.noeffect)) then
								autobind.messages.noeffect = not autobind.messages.noeffect
							end
							if imgui.Checkbox("No Firstaid", new.bool(autobind.messages.nofaid)) then
								autobind.messages.nofaid = not autobind.messages.nofaid
							end
							imgui.EndCombo()
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Disables messages sent by the server')
							imgui.PopStyleVar()
						end
						imgui.PopItemWidth()
						imgui.PopStyleVar()
					imgui.EndChild()
				imgui.EndChild()
			end
			if _menu == 3 and frisk_menu[0] then
				if not pointturf_menu[0] and not streamedplayers_menu[0] and frisk_menu[0] then
					if frisk_menu[0] then
						imgui.SetCursorPos(imgui.ImVec2(6, 200))
					else
						imgui.SetCursorPos(imgui.ImVec2(6, 200))
					end
				end
				
				if pointturf_menu[0] and frisk_menu[0] and not streamedplayers_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 200))
				end
				
				if not pointturf_menu[0] and frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 200))
				end
				
				if pointturf_menu[0] and frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 200))
				end
				
				imgui.BeginChild("##config1", imgui.ImVec2(290, 150), false)
					imgui.Text("Frisk:")
					if imgui.Checkbox("Player Target", new.bool(autobind.Frisk[1])) then
						autobind.Frisk[1] = not autobind.Frisk[1]
					end
					if imgui.IsItemHovered() then
						imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
							imgui.SetTooltip('Checks if you are targeting a player')
						imgui.PopStyleVar()
					end
					imgui.SameLine()
					imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
					if imgui.Checkbox("Player Aim", new.bool(autobind.Frisk[2])) then
						autobind.Frisk[2] = not autobind.Frisk[2]
						end
					if imgui.IsItemHovered() then
						imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
							imgui.SetTooltip('Checks if you are only aiming')
						imgui.PopStyleVar()
					end
					
					imgui.PushItemWidth(120)
					imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
					if imgui.BeginCombo("##Sniper Sound", "Sniper Sound") then
						sound_dropdownmenu(3)
						imgui.EndCombo()
					end
					if imgui.IsItemHovered() then
						imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
							imgui.SetTooltip('Plays a sound the player has a sniper rifle')
						imgui.PopStyleVar()
					end
					imgui.PopItemWidth()
					imgui.PopStyleVar()
				imgui.EndChild()
			end
			
			if _menu == 3 and pointturf_menu[0] then
				if not frisk_menu[0] and not streamedplayers_menu[0] and pointturf_menu[0] then
					if pointturf_menu[0] then
						imgui.SetCursorPos(imgui.ImVec2(6, 200))
					else
						imgui.SetCursorPos(imgui.ImVec2(6, 200))
					end
				end
				
				if pointturf_menu[0] and streamedplayers_menu[0] and not frisk_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 200))
				end
				
				if pointturf_menu[0] and frisk_menu[0] and not streamedplayers_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 265))
				end
				
				if pointturf_menu[0] and frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 265))
				end
				
				imgui.BeginChild("##config2", imgui.ImVec2(290, 150), false)
					imgui.Text('Point/Turf Menu:')
					if imgui.Checkbox("Always Point/Turf",  new.bool(autobind.notification_capper)) then
						autobind.notification_capper = not autobind.notification_capper
						if autobind.notification_capper then
							autobind.notification_capper_hide = false
						end
					end
					if imgui.IsItemHovered() then
						imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
							imgui.SetTooltip('Always Display Turf/Point')
						imgui.PopStyleVar()
					end
					imgui.SameLine()
					imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
					if imgui.Checkbox("Hide Point/Turf",  new.bool(autobind.notification_capper_hide)) then
						autobind.notification_capper_hide = not autobind.notification_capper_hide
						if autobind.notification_capper_hide then
							autobind.notification_capper = false
						end
					end
					if imgui.IsItemHovered() then
						imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
							imgui.SetTooltip('Always Hide Turf/Point')
						imgui.PopStyleVar()
					end
				imgui.EndChild()
			end
			
			if _menu == 3 and streamedplayers_menu[0] then	
				if not frisk_menu[0] and not pointturf_menu[0] and streamedplayers_menu[0] then
					if streamedplayers_menu[0] then
						imgui.SetCursorPos(imgui.ImVec2(6, 200))
					end
				end
				
				if not pointturf_menu[0] and frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 265))
				end
				
				if pointturf_menu[0] and streamedplayers_menu[0] and not frisk_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 240))
				end
				
				if pointturf_menu[0] and frisk_menu[0] and streamedplayers_menu[0] then
					imgui.SetCursorPos(imgui.ImVec2(6, 305))
				end
				
				imgui.BeginChild("##config3", imgui.ImVec2(290, 150), false)
					if streamedplayers_menu[0] and _menu ~= 1 then
						imgui.Text('Streamed Players:')
						
						local choices = {'Left', 'Center', 'Right'}
						imgui.PushItemWidth(120)
						if imgui.BeginCombo("##align", choices[autobind.streamedplayers.alignfont]) then
							for i = 1, #choices do
								if imgui.Selectable(choices[i]..'##'..i, autobind.streamedplayers.alignfont == i) then
									autobind.streamedplayers.alignfont = i
								end
							end
							imgui.EndCombo()
						end
						imgui.PopItemWidth()
						
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						
						local choices2 = {'Bold', 'Italics', 'Border', 'Shadow'}
						imgui.PushItemWidth(120)
						if imgui.BeginCombo("##flags", 'Flags') then
							for i = 1, #choices2 do
								if imgui.Checkbox(choices2[i], new.bool(autobind.streamedplayers.fontflag[i])) then
									autobind.streamedplayers.fontflag[i] = not autobind.streamedplayers.fontflag[i] 
									createfont() 
								end
							end
							imgui.EndCombo()
						end
						imgui.PopItemWidth()
						
						imgui.PushItemWidth(120) 
						local text = new.char[30](autobind.streamedplayers.font)
						if imgui.InputText('##font', text, sizeof(text), imgui.InputTextFlags.EnterReturnsTrue) then
							autobind.streamedplayers.font = u8:decode(str(text))
							createfont() 
						end
						imgui.PopItemWidth()
						
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						
						imgui.BeginGroup()
							if imgui.Button('+##1') and autobind.streamedplayers.fontsize < 72 then 
								autobind.streamedplayers.fontsize = autobind.streamedplayers.fontsize + 1 
								createfont()
							end
							
							imgui.SameLine()
							imgui.Text(tostring(autobind.streamedplayers.fontsize))
							imgui.SameLine()
							
							if imgui.Button('-##1') and autobind.streamedplayers.fontsize > 4 then 
								autobind.streamedplayers.fontsize = autobind.streamedplayers.fontsize - 1 
								createfont()
							end
							imgui.SameLine()
							imgui.Text('FontSize')
						imgui.EndGroup()
						
						
						imgui.PushItemWidth(95) 
						tcolor = new.float[4](hex2rgba(autobind.streamedplayers.color))
						if imgui.ColorEdit4('##color', tcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel) then 
							autobind.streamedplayers.color = join_argb(tcolor[3] * 255, tcolor[0] * 255, tcolor[1] * 255, tcolor[2] * 255) 
						end 
						imgui.PopItemWidth()
						imgui.SameLine()
						imgui.Text('Color')
						imgui.SameLine()
						imgui.SetCursorPosX(imgui.GetWindowWidth() / cursorposx)
						
						if imgui.Checkbox("Toggle",  new.bool(autobind.streamedplayers.toggle)) then
							autobind.streamedplayers.toggle = not autobind.streamedplayers.toggle
							if autobind.streamedplayers.toggle then
								autobind.notification_capper_hide = false
							end
						end
						if imgui.IsItemHovered() then
							imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
								imgui.SetTooltip('Toggles streamed players')
							imgui.PopStyleVar()
						end
					end
				imgui.EndChild()
			end
		imgui.End()
	imgui.PopStyleVar(1)
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PopStyleColor()
		imgui.PopStyleColor()
	end
end)

local frameDrawer = imgui.OnFrame(function() return isIniLoaded and skinmenu[0] and not isGamePaused end,
function()
	for i = 0, 311 do
		if skinTexture[i] == nil then
			skinTexture[i] = imgui.CreateTextureFromFile("moonloader/resource/skins/Skin_"..i..".png")
		end
	end
end,
function(self)
	if not menu[0] then
		skinmenu[0] = false
	end
	imgui.SetNextWindowPos(imgui.ImVec2(autobind.menupos[1] + (menusize[1] / 13), autobind.menupos[2]))
	imgui.SetNextWindowSize(imgui.ImVec2(505, 390), imgui.Cond.FirstUseEver)
	imgui.Begin(u8("Skin Menu"), skinmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		imgui.SetWindowFocus()
		if page == 15 then max = 299 else max = 41+(21*(page-2)) end
		for i = 21+(21*(page-2)), max do
			if i <= 27+(21*(page-2)) and i ~= 21+(21*(page-2)) then
				imgui.SameLine()
			elseif i <= 34+(21*(page-2)) and i > 28+(21*(page-2)) then
				imgui.SameLine()
			elseif i <= 41+(21*(page-2)) and i > 35+(21*(page-2)) then
				imgui.SameLine()
			end
			if imgui.ImageButton(skinTexture[i], imgui.ImVec2(55, 100)) then
				if autobind.customskins then
					autobind.skins2[selected] = i
				else
					autobind.skins[selected] = i
				end
				skinmenu[0] = false
			end
			if imgui.IsItemHovered() then imgui.SetTooltip("Skin "..i.."") end
		end
	
		imgui.SetCursorPos(imgui.ImVec2(555, 360))
		
		imgui.Indent(210)
		
		if imgui.Button(u8"Previous", new.bool) and page > 0 then
			if page == 1 then
				page = 15
			else
				page = page - 1
			end
		end
		imgui.SameLine()
		if imgui.Button(u8"Next", new.bool) and page < 16 then
			if page == 15 then
				page = 1
			else
				page = page + 1
			end
		end
		imgui.SameLine()
		imgui.Text("Page "..page.."/15")
	imgui.End()
end)

imgui.OnFrame(function() return isIniLoaded and bmmenu[0] and not isGamePaused end,
function()
	if not menu[0] then
		bmmenu[0] = false
	end
	imgui.SetNextWindowPos(imgui.ImVec2(autobind.menupos[1] + 455, autobind.menupos[2]))
	imgui.SetNextWindowSize(imgui.ImVec2(165, 362), imgui.Cond.FirstUseEver)
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
	else
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
	end
		imgui.Begin(string.format("BM Settings", script.this.name, script.this.version), bmmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar) 
		
			if imgui.IsWindowFocused() then
				bmactive = true
			else
				bmactive = false
			end
		
			imgui.Text('Black-Market Equipment:')
			
			if imgui.Checkbox('Full Health and Armor', new.bool(autobind.BlackMarket[1])) then 
				autobind.BlackMarket[1] = not autobind.BlackMarket[1] 
			end
			
			if imgui.Checkbox('Silenced Pistol', new.bool(autobind.BlackMarket[2])) then 
				autobind.BlackMarket[2] = not autobind.BlackMarket[2]
				if autobind.BlackMarket[2] then
					autobind.BlackMarket[3] = false
					autobind.BlackMarket[9] = false
				end
			end
			
			if imgui.Checkbox('9mm Pistol', new.bool(autobind.BlackMarket[3])) then 
				autobind.BlackMarket[3] = not autobind.BlackMarket[3] 
				if autobind.BlackMarket[3] then
					autobind.BlackMarket[2] = false
					autobind.BlackMarket[9] = false
				end
			end
			
			if imgui.Checkbox('Shotgun', new.bool(autobind.BlackMarket[4])) then 
				autobind.BlackMarket[4] = not autobind.BlackMarket[4] 
				if autobind.BlackMarket[4] then
					autobind.BlackMarket[12] = false
				end
			end
			if imgui.Checkbox('MP5', new.bool(autobind.BlackMarket[5])) then 
				autobind.BlackMarket[5] = not autobind.BlackMarket[5]
				if autobind.BlackMarket[5] then
					autobind.BlackMarket[6] = false
					autobind.BlackMarket[7] = false
				end
			end
			
			if imgui.Checkbox('UZI', new.bool(autobind.BlackMarket[6])) then 
				autobind.BlackMarket[6] = not autobind.BlackMarket[6]
				if autobind.BlackMarket[6] then
					autobind.BlackMarket[5] = false
					autobind.BlackMarket[7] = false
				end
			end
			
			if imgui.Checkbox('Tec-9', new.bool(autobind.BlackMarket[7])) then 
				autobind.BlackMarket[7] = not autobind.BlackMarket[7] 
				if autobind.BlackMarket[7] then
					autobind.BlackMarket[5] = false
					autobind.BlackMarket[6] = false
				end
			end
			
			if imgui.Checkbox('Country Rifle', new.bool(autobind.BlackMarket[8])) then 
				autobind.BlackMarket[8] = not autobind.BlackMarket[8] 
				if autobind.BlackMarket[8] then
					autobind.BlackMarket[13] = false
				end
			end
			
			if imgui.Checkbox('Deagle', new.bool(autobind.BlackMarket[9])) then 
				autobind.BlackMarket[9] = not autobind.BlackMarket[9]
				if autobind.BlackMarket[9] then
					autobind.BlackMarket[2] = false
					autobind.BlackMarket[3] = false
				end
			end
			
			if imgui.Checkbox('AK-47', new.bool(autobind.BlackMarket[10])) then 
				autobind.BlackMarket[10] = not autobind.BlackMarket[10]
				if autobind.BlackMarket[10] then
					autobind.BlackMarket[11] = false
				end
			end
			if imgui.Checkbox('M4', new.bool(autobind.BlackMarket[11])) then 
				autobind.BlackMarket[11] = not autobind.BlackMarket[11]
				if autobind.BlackMarket[11] then
					autobind.BlackMarket[10] = false
				end
			end
			
			if imgui.Checkbox('Spas-12', new.bool(autobind.BlackMarket[12])) then 
				autobind.BlackMarket[12] = not autobind.BlackMarket[12]
				if autobind.BlackMarket[12] then
					autobind.BlackMarket[4] = false
				end
			end
			
			if imgui.Checkbox('Sniper Rifle', new.bool(autobind.BlackMarket[13])) then 
				autobind.BlackMarket[13] = not autobind.BlackMarket[13] 
				if autobind.BlackMarket[13] then
					autobind.BlackMarket[8] = false
				end
			end
		imgui.End()
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PopStyleColor()
		imgui.PopStyleColor()
	end
end)

imgui.OnFrame(function() return isIniLoaded and factionlockermenu[0] and not isGamePaused end,
function()
	if not menu[0] then
		factionlockermenu[0] = false
	end
	imgui.SetNextWindowPos(imgui.ImVec2(autobind.menupos[1] + 455, autobind.menupos[2]))
	imgui.SetNextWindowSize(imgui.ImVec2(129, 314), imgui.Cond.FirstUseEver)
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
	else
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
	end
		imgui.Begin("Faction Locker", factionlockermenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar) 
			if imgui.IsWindowFocused() then
				factionactive = true
			else
				factionactive = false
			end
			imgui.Text('Locker Equipment:')
			if imgui.Checkbox('Deagle', new.bool(autobind.FactionLocker[1])) then 
				autobind.FactionLocker[1] = not autobind.FactionLocker[1] 
			end
			if imgui.Checkbox('Shotgun', new.bool(autobind.FactionLocker[2])) then 
				autobind.FactionLocker[2] = not autobind.FactionLocker[2] 
				if autobind.FactionLocker[2] then
					autobind.FactionLocker[3] = false
				end
			end 
			if imgui.Checkbox('SPAS-12', new.bool(autobind.FactionLocker[3])) then 
				autobind.FactionLocker[3] = not autobind.FactionLocker[3] 
				if autobind.FactionLocker[3] then
					autobind.FactionLocker[2] = false
				end
			end 
			if imgui.Checkbox('MP5', new.bool(autobind.FactionLocker[4])) then 
				autobind.FactionLocker[4] = not autobind.FactionLocker[4] 
			end 
			if imgui.Checkbox('M4', new.bool(autobind.FactionLocker[5])) then 
				autobind.FactionLocker[5] = not autobind.FactionLocker[5] 
				if autobind.FactionLocker[5] then
					autobind.FactionLocker[6] = false
				end
			end
			if imgui.Checkbox('AK-47', new.bool(autobind.FactionLocker[6])) then 
				autobind.FactionLocker[6] = not autobind.FactionLocker[6] 
				if autobind.FactionLocker[6] then
					autobind.FactionLocker[5] = false
				end
			end
			if imgui.Checkbox('Smoke Grenade', new.bool(autobind.FactionLocker[7])) then 
				autobind.FactionLocker[7] = not autobind.FactionLocker[7] 
			end
			if imgui.Checkbox('Camera', new.bool(autobind.FactionLocker[8])) then 
				autobind.FactionLocker[8] = not autobind.FactionLocker[8] 
			end
			if imgui.Checkbox('Sniper', new.bool(autobind.FactionLocker[9])) then 
				autobind.FactionLocker[9] = not autobind.FactionLocker[9]
			end
			if imgui.Checkbox('Vest', new.bool(autobind.FactionLocker[10])) then 
				autobind.FactionLocker[10] = not autobind.FactionLocker[10] 
			end
			if imgui.Checkbox('First Aid Kit', new.bool(autobind.FactionLocker[11])) then 
				autobind.FactionLocker[11] = not autobind.FactionLocker[11] 
			end
		imgui.End()
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PopStyleColor()
		imgui.PopStyleColor()
	end
end)

imgui.OnFrame(function() return isIniLoaded and ganglockermenu[0] and not isGamePaused end,
function()
	if not menu[0] then
		ganglockermenu[0] = false
	end
	imgui.SetNextWindowPos(imgui.ImVec2(autobind.menupos[1] + 455, autobind.menupos[2]))
	imgui.SetNextWindowSize(imgui.ImVec2(113, 218), imgui.Cond.FirstUseEver)
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.8))
	else
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(mainc.x, mainc.y, mainc.z, 0.6))
	end
		imgui.Begin("Gang Locker", ganglockermenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar) 
			if imgui.IsWindowFocused() then
				gangactive = true
			else
				gangactive = false
			end
			imgui.Text('Gang Equipment:')
			if imgui.Checkbox('Shotgun', new.bool(autobind.GangLocker[1])) then 
				autobind.GangLocker[1] = not autobind.GangLocker[1] 
			end
			if imgui.Checkbox('MP5', new.bool(autobind.GangLocker[2])) then 
				autobind.GangLocker[2] = not autobind.GangLocker[2] 
			end 
			if imgui.Checkbox('Deagle', new.bool(autobind.GangLocker[3])) then 
				autobind.GangLocker[3] = not autobind.GangLocker[3] 
			end 
			if imgui.Checkbox('AK-47', new.bool(autobind.GangLocker[4])) then 
				autobind.GangLocker[4] = not autobind.GangLocker[4] 
			end 
			if imgui.Checkbox('M4', new.bool(autobind.GangLocker[5])) then 
				autobind.GangLocker[5] = not autobind.GangLocker[5] 
			end
			if imgui.Checkbox('Spas-12', new.bool(autobind.GangLocker[6])) then 
				autobind.GangLocker[6] = not autobind.GangLocker[6] 
			end
			if imgui.Checkbox('Sniper', new.bool(autobind.GangLocker[7])) then 
				autobind.GangLocker[7] = not autobind.GangLocker[7] 
			end
		imgui.End()
	if menuactive or menu2active or bmactive or factionactive or gangactive then
		imgui.PopStyleColor()
		imgui.PopStyleColor()
	end
end)

imgui.OnFrame(function() return isIniLoaded and imguisettings[0] and not isGamePaused end,
function()
	if not menu[0] then
		imguisettings[0] = false
	end
	imgui.SetNextWindowPos(imgui.ImVec2(autobind.menupos[1] + (menusize[1] / 5), autobind.menupos[2]))
    imgui.Begin(fa.GEAR.." ImGUI Settings", imguisettings, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) 
		--imgui.SetWindowFocus()
		local colormenu = new.float[3](autobind.imcolor[1], autobind.imcolor[2], autobind.imcolor[3])
		if imgui.ColorEdit3('##Menu Color', colormenu, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel) then 
			autobind.imcolor[1] = colormenu[0]
			autobind.imcolor[2] = colormenu[1]
			autobind.imcolor[3] = colormenu[2]
		end
		imgui.SameLine()
		imgui.Text("Menu Color")
		
		imgui.SameLine()
		imgui.PushItemWidth(95)
		if imgui.BeginCombo("fAwesome 6 Icons##1", autobind.fa6) then
			for k, v in pairs(fa6fontlist) do
				if imgui.Selectable(v, v == autobind.fa6) then
					autobind.fa6 = v
				end
			end
			imgui.EndCombo()
		end
		imgui.PopItemWidth()
		
		imgui.BeginChild("##saveandreset", imgui.ImVec2(330, 45), false)
			imgui.Text("Changing this will require the script to restart")
			imgui.Spacing()	
			imgui.SetCursorPosX(imgui.GetWindowWidth() / 5.7)
			if imgui.Button(fa.ARROWS_REPEAT .. " Save and restart the script") then
				autobind_saveIni()
				thisScript():reload()
			end
		imgui.EndChild()
	imgui.End()
end)

function onD3DPresent()	
	if not isPauseMenuActive() and not sampIsScoreboardOpen() and sampGetChatDisplayMode() > 0 and not isKeyDown(VK_F10) and autobind.streamedplayers.toggle and _enabled then
		if fid and streamedplayers then
			renderfont(
				autobind.streamedplayers.pos[1], 
				autobind.streamedplayers.pos[2], 
				fid, 
				streamedplayers, 
				autobind.streamedplayers.alignfont, 
				autobind.streamedplayers.color
			)
		end
	end
end

function renderfont(x, y, fontid, value, align, color)
	renderFontDrawText(fontid, value, x - aligntext(fontid, value, align), y, color)
end

function main()
	if not doesDirectoryExist(path) then createDirectory(path) end
	if not doesDirectoryExist(resourcepath) then createDirectory(resourcepath) end
	if not doesDirectoryExist(skinspath) then createDirectory(skinspath) end
	if not doesDirectoryExist(audiopath) then createDirectory(audiopath) end
	if not doesDirectoryExist(audiofolder) then createDirectory(audiofolder) end
	if doesFileExist(autobind_cfg) then autobind_loadIni() else autobind_blankIni() end
	while not isSampAvailable() do wait(100) end
	
	createfont()
	skins_script()
	sounds_script()
	
	paths = scanGameFolder(audiofolder, paths)
	
	local res_aduty, aduty = getSampfuncsGlobalVar("aduty")
	if res_aduty then
		if aduty == 0 then
			setSampfuncsGlobalVar('aduty', 0)
		end
	else
		setSampfuncsGlobalVar('aduty', 0)
	end
	
	local res_hideme, hideme = getSampfuncsGlobalVar("HideMe_check")
	if res_hideme then
		if hideme == 0 then
			setSampfuncsGlobalVar('HideMe_check', 0)
		end
	else
		setSampfuncsGlobalVar('HideMe_check', 0)
	end
	
	autobind.timer = autobind.ddmode and 7 or 12

	if not autobind.enablebydefault then
		_enabled = false
		_autovest = false
	end
	
	if autobind.autoupdate then
		update_script(false, false)
	end
	
	if not autobind.gangcustomskins then
		loadskinidsurl()
	end

	sampRegisterChatCommand(autobind.autovestsettingscmd, function() 
		_menu = 2
		menu[0] = not menu[0]
		menu2[0] = not menu2[0]
	end)

	sampRegisterChatCommand(autobind.vestnearcmd, function() 
		if _enabled and _autovest then
			for PlayerID = 0, sampGetMaxPlayerId(false) do
				local result, playerped = sampGetCharHandleBySampPlayerId(PlayerID)
				if result and not sampIsPlayerPaused(PlayerID) and sampGetPlayerArmor(PlayerID) < 49 then
					local myX, myY, myZ = getCharCoordinates(ped)
					local playerX, playerY, playerZ = getCharCoordinates(playerped)
					if getDistanceBetweenCoords3d(myX, myY, myZ, playerX, playerY, playerZ) < 6 then
						local pAnimId = sampGetPlayerAnimationId(select(2, sampGetPlayerIdByCharHandle(ped)))
						local pAnimId2 = sampGetPlayerAnimationId(playerid)
						local aim, _ = getCharPlayerIsTargeting(h)
						if pAnimId ~= 1158 and pAnimId ~= 1159 and pAnimId ~= 1160 and pAnimId ~= 1161 and pAnimId ~= 1162 and pAnimId ~= 1163 and pAnimId ~= 1164 and pAnimId ~= 1165 and pAnimId ~= 1166 and pAnimId ~= 1167 and pAnimId ~= 1069 and pAnimId ~= 1070 and pAnimId2 ~= 746 and not aim then
							sendGuard(PlayerID)
						end
					end
				end
			end
		end
	end)
	sampRegisterChatCommand(autobind.sexnearcmd, function() 
		if _enabled then
			local result, id = getClosestPlayerId(5, 2)
			if result and isCharInAnyCar(ped) then
				sampSendChat(string.format("/sex %d 1", id))
			end
		end
	end)
	sampRegisterChatCommand(autobind.repairnearcmd, function()
		if _enabled then
			local result, id = getClosestPlayerId(5, 2)
			if result then
				sampSendChat(string.format("/repair %d 1", id))
			end
		end
	end)
	
	sampRegisterChatCommand(autobind.hfindcmd, function(params) -- Scumbag Locator
		if _enabled then
			lua_thread.create(function()
				if string.len(params) > 0 then
					local result, playerid, name = getTarget(params)
					if result then
						if not autofind then
							target = playerid
							autofind = true
							sampAddChatMessage("FINDING: {00a2ff}"..name.."{ffffff}. /hfind again to toggle.", -1)
							while autofind and not cooldown_bool do
								wait(10)
								if sampIsPlayerConnected(target) then
									cooldown_bool = true
									sampSendChat("/find "..target)
									wait(19000)
									cooldown_bool = false
								else
									autofind = false
									sampAddChatMessage("The player you were finding has disconnected, you are no longer finding anyone.", -1)
								end
							end
						elseif autofind then
							target = playerid
							sampAddChatMessage("NOW FINDING: {00a2ff}"..name.."{ffffff}.", -1)
						end
					else
						sampAddChatMessage("Invalid player specified.", 11645361)
					end
				elseif autofind and string.len(params) == 0 then
					autofind = false
					sampAddChatMessage("You are no longer finding anyone.", -1)
				else
					sampAddChatMessage('USAGE: /hfind [playerid/partofname]', -1)
				end
			end)
		end
	end)
	
	sampRegisterChatCommand(autobind.tcapcmd, function() 
		if _enabled then
			captog = not captog 
		end
	end)
	
	sampRegisterChatCommand(autobind.sprintbindcmd, function() 
		if _enabled then
			autobind.Keybinds.SprintBind.Toggle = not autobind.Keybinds.SprintBind.Toggle 
			sampAddChatMessage('[Autobind]{ffff00} Sprintbind: '..(autobind.Keybinds.SprintBind.Toggle and '{008000}on' or '{FF0000}off'), -1) 
		end
	end)
	
	sampRegisterChatCommand(autobind.bikebindcmd, function() 
		if _enabled then
			autobind.Keybinds.BikeBind.Toggle = not autobind.Keybinds.BikeBind.Toggle
			sampAddChatMessage('[Autobind]{ffff00} Bikebind: '..(autobind.Keybinds.BikeBind.Toggle and '{008000}on' or '{FF0000}off'), -1) 
		end
	end)
	
	sampRegisterChatCommand(autobind.autovestcmd, function() 
		_autovest = not _autovest
		sampAddChatMessage(string.format("[Autobind]{ffff00} Automatic vest %s.", _autovest and 'enabled' or 'disabled'), 1999280)
	end)
	
	sampRegisterChatCommand(autobind.autoacceptercmd, function() 
		if _enabled then
			autoaccepter = not autoaccepter
			sampAddChatMessage(string.format("[Autobind]{ffff00} Autoaccepter is now %s.", autoaccepter and 'enabled' or 'disabled'), 1999280)
		end
	end)
	
	sampRegisterChatCommand(autobind.ddmodecmd, function() 
		if _enabled then
			autobind.ddmode = not autobind.ddmode
			sampAddChatMessage(string.format("[Autobind]{ffff00} ddmode is now %s.", autobind.ddmode and 'enabled' or 'disabled'), 1999280)
			
			autobind.timer = autobind.ddmode and 7 or 12
			
			if autobind.ddmode then
				_you_are_not_bodyguard = true
			end
		end
	end)
	
	sampRegisterChatCommand(autobind.factionbothcmd, function()
		if _enabled then
			autobind.factionboth  = not autobind.factionboth
			sampAddChatMessage(string.format("[Autobind]{ffff00} factionbothcmd is now %s.", autobind.factionboth and 'enabled' or 'disabled'), 1999280)
		end
	end)
	
	sampRegisterChatCommand(autobind.vestmodecmd, function(params)
		if _enabled then
			if string.len(params) > 0 then
				if params:match('families') then
					autobind.vestmode = 0
					sampAddChatMessage("[Autobind]{ffff00} vestmode is now set to Families.", 1999280)
				elseif params:match('factions') then
					autobind.vestmode = 1
					sampAddChatMessage("[Autobind]{ffff00} vestmode is now set to Factions.", 1999280)
				elseif params:match('everyone') then
					autobind.vestmode = 2
					sampAddChatMessage("[Autobind]{ffff00} vestmode is now set to Everyone.", 1999280)
				elseif params:match('names') then
					autobind.vestmode = 3
					sampAddChatMessage("[Autobind]{ffff00} vestmode is now set to Names.", 1999280)
				elseif params:match('skins') then
					autobind.vestmode = 4
					sampAddChatMessage("[Autobind]{ffff00} vestmode is now set to Skins.", 1999280)
				else
					sampAddChatMessage("[Autobind]{ffff00} vestmode is currently set to "..vestmodename(autobind.vestmode)..".", 1999280)
					sampAddChatMessage('USAGE: /'..autobind.vestmodecmd..' [families/factions/everyone/names/skins]', -1)
				end
			else
				sampAddChatMessage("[Autobind]{ffff00} vestmode is currently set to "..vestmodename(autobind.vestmode)..".", 1999280)
				sampAddChatMessage('USAGE: /'..autobind.vestmodecmd..' [families/factions/everyone/names/skins]', -1)
			end
		end
	end)
	
	sampRegisterChatCommand(autobind.pointmodecmd, function(params) 
		if _enabled then
			sampAddChatMessage("[Autobind]{ffff00} pointmode enabled.", 1999280)
			autobind.point_turf_mode = true
		end
	end)
	
	sampRegisterChatCommand(autobind.turfmodecmd, function(params) 
		if _enabled then
			sampAddChatMessage("[Autobind]{ffff00} turfmode enabled.", 1999280)
			autobind.point_turf_mode = false
		end
	end)
	
	lua_thread.create(function() 
		while true do wait(15)
			mposX, mposY = getCursorPos()
			fontmove()
			streamedplayers = "Streamed Players: " ..sampGetPlayerCount(true) - 1
		end
	end)
	
	lua_thread.create(function() 
		while true do wait(15)
			listenToKeybinds()
		end
	end)
	
	lua_thread.create(function() 
		while true do wait(0)
			if _enabled and captog then 
				sampAddChatMessage("{FFFF00}Starting capture spam... (type /tcap to toggle)",-1)
				while captog do
					sampSendChat("/capturf")
					wait(1500) 
				end
				sampAddChatMessage("{FFFF00}Capture spam ended.",-1)
			end
		end
	end)
	
	lua_thread.create(function() 
		while true do wait(0)
			if _enabled and autobind.Keybinds.SprintBind.Toggle and getPadState(h, keys.player.SPRINT) == 255 and (isCharOnFoot(ped) or isCharInWater(ped)) then
				setGameKeyUpDown(keys.player.SPRINT, 255, autobind.SprintBind.delay) 
			end
		end
	end)
	
	sampAddChatMessage("["..script.this.name..'] '.. "{FF1A74}(/autobind) Authors: " .. table.concat(thisScript().authors, ", ")..", Testers: ".. table.concat(script_tester, ", "), -1)
	
	while true do wait(0)
		if _enabled then
			if getCharArmour(ped) > 49 and not autobind.showprevest then
				sampname2 = 'Nobody'
				playerid2 = -1
				
				if autobind.notification_hide[2] then
					hide[2] = false
				end
			end
		end
	
		local _, aduty = getSampfuncsGlobalVar("aduty")
		local _, HideMe = getSampfuncsGlobalVar("HideMe_check")
		if _enabled and _autovest and autobind.timer <= localClock() - _last_vest and not specstate and HideMe == 0 and aduty == 0 then
			if _you_are_not_bodyguard then
				autobind.timer = autobind.ddmode and 7 or 12
				for PlayerID = 0, sampGetMaxPlayerId(false) do
					local result, playerped = sampGetCharHandleBySampPlayerId(PlayerID)
					if result and not sampIsPlayerPaused(PlayerID) then
						local myX, myY, myZ = getCharCoordinates(ped)
						local playerX, playerY, playerZ = getCharCoordinates(playerped)
						local dist = getDistanceBetweenCoords3d(myX, myY, myZ, playerX, playerY, playerZ)
						if (autobind.ddmode and tostring(dist) or dist) < (autobind.ddmode and tostring(0.9) or 6) then
							if sampGetPlayerArmor(PlayerID) < 49 then
								local pAnimId = sampGetPlayerAnimationId(select(2, sampGetPlayerIdByCharHandle(ped)))
								local pAnimId2 = sampGetPlayerAnimationId(playerid)
								local aim, _ = getCharPlayerIsTargeting(h)
								if pAnimId ~= 1158 and pAnimId ~= 1159 and pAnimId ~= 1160 and pAnimId ~= 1161 and pAnimId ~= 1162 and pAnimId ~= 1163 and pAnimId ~= 1164 and pAnimId ~= 1165 and pAnimId ~= 1166 and pAnimId ~= 1167 and pAnimId ~= 1069 and pAnimId ~= 1070 and pAnimId2 ~= 746 and not aim then
									if autobind.vestmode == 0 then
										if autobind.gangcustomskins then
											if has_number(autobind.skins, getCharModel(playerped)) then
												sendGuard(PlayerID)
											end
										else
											if has_number(skins, getCharModel(playerped)) then
												sendGuard(PlayerID)
											end
										end
									end
									if autobind.vestmode == 1 then
										local color = sampGetPlayerColor(PlayerID)
										local r, g, b = hex2rgb(color)
										color = join_argb_int(255, r, g, b)
										if (autobind.factionboth and has_number(factions, getCharModel(playerped)) and has_number(factions_color, color)) or (not autobind.factionboth and has_number(factions, getCharModel(playerped)) or has_number(factions_color, color)) then
											sendGuard(PlayerID)
										end
									end
									if autobind.vestmode == 2 then
										sendGuard(PlayerID)
									end
									if autobind.vestmode == 3 then
										for k, v in pairs(autobind.names) do
											if v == sampGetPlayerNickname(PlayerID) then
												sendGuard(PlayerID)
											end
										end
									end
									if autobind.vestmode == 4 then
										if autobind.customskins then
											if has_number(autobind.skins2, getCharModel(playerped)) then
												sendGuard(PlayerID)
											end
										end
									end
								end
							end
						end
					end
				end
			end
			if autoaccepter and autoacceptertoggle then
				local _, playerped = storeClosestEntities(ped)
				local result, PlayerID = sampGetPlayerIdByCharHandle(playerped)
				if result and playerped ~= ped then
					if getCharArmour(ped) < 49 and sampGetPlayerAnimationId(ped) ~= 746 then
						autoaccepternickname = sampGetPlayerNickname(PlayerID)
						
						local playerx, playery, playerz = getCharCoordinates(ped)
						local pedx, pedy, pedz = getCharCoordinates(playerped)

						if getDistanceBetweenCoords3d(playerx, playery, playerz, pedx, pedy, pedz) < 4 then
							if autoaccepternickname == autoaccepternick then
								sampSendChat("/accept bodyguard")
								
								autoacceptertoggle = false
							end
						end
					end
				end
			end
		end
			

function listenToKeybinds()
	if _enabled and not menu[0] and not inuse_key then
		if autobind.Keybinds.Accept.Toggle then
			local key, key2 = nil
			if autobind.Keybinds.Accept.Dual then 
				key, key2 = autobind.Keybinds.Accept.Keybind:match("(.+),(.+)") 
			end
			if (key and key2 and autobind.Keybinds.Accept.Dual and keycheck({k  = {key, key2}, t = {'KeyDown', 'KeyPressed'}}) or keycheck({k  = {autobind.Keybinds.Accept.Keybind}, t = {'KeyPressed'}})) then
				sampSendChat("/accept bodyguard")
				wait(1000)
			end
		end
		if autobind.Keybinds.Offer.Toggle then
			local key, key2 = nil
			if autobind.Keybinds.Offer.Dual then 
				key, key2 = autobind.Keybinds.Offer.Keybind:match("(.+),(.+)") 
			end
			if (key and key2 and autobind.Keybinds.Offer.Dual and keycheck({k  = {key, key2}, t = {'KeyDown', 'KeyPressed'}}) or keycheck({k  = {autobind.Keybinds.Offer.Keybind}, t = {'KeyPressed'}})) then
				for PlayerID = 0, sampGetMaxPlayerId(false) do
					local result, playerped = sampGetCharHandleBySampPlayerId(PlayerID)
					if result and not sampIsPlayerPaused(PlayerID) and sampGetPlayerArmor(PlayerID) < 49 then
						local myX, myY, myZ = getCharCoordinates(ped)
						local playerX, playerY, playerZ = getCharCoordinates(playerped)
						if getDistanceBetweenCoords3d(myX, myY, myZ, playerX, playerY, playerZ) < 6 then
							local pAnimId = sampGetPlayerAnimationId(select(2, sampGetPlayerIdByCharHandle(ped)))
							local pAnimId2 = sampGetPlayerAnimationId(playerid)
							local aim, _ = getCharPlayerIsTargeting(h)
							if pAnimId ~= 1158 and pAnimId ~= 1159 and pAnimId ~= 1160 and pAnimId ~= 1161 and pAnimId ~= 1162 and pAnimId ~= 1163 and pAnimId ~= 1164 and pAnimId ~= 1165 and pAnimId ~= 1166 and pAnimId ~= 1167 and pAnimId ~= 1069 and pAnimId ~= 1070 and pAnimId2 ~= 746 and not aim then
								sendGuard(PlayerID)
								wait(1000)
							end
						end
					end
				end
			end
		end
	end
end

function sendGuard(id)
	if autobind.ddmode then
		sampSendChat('/guardnear')
	else
		sampSendChat(string.format("/guard %d 200", id))
	end
	
	if autobind.notification_hide[1] then
		hide[1] = true
	end
	
	sampname = sampGetPlayerNickname(id)
	playerid = id

	playsound(1)

	_last_vest = localClock()
end

function onScriptTerminate(scr, quitGame) 
	if scr == script.this then 
		if autobind.autosave then 
			autobind_saveIni() 
		end 
	end
end

function onWindowMessage(msg, wparam, lparam)
	if msg == wm.WM_KILLFOCUS then
		isGamePaused = true
	elseif msg == wm.WM_SETFOCUS then
		isGamePaused = false
	end

	if wparam == VK_ESCAPE and (menu[0] or skinmenu[0] or bmmenu[0] or factionlockermenu[0]) then
        if msg == wm.WM_KEYDOWN then
            consumeWindowMessage(true, false)
        end
        if msg == wm.WM_KEYUP then
            menu[0] = false
			menu2[0] = false
			skinmenu[0] = false
			bmmenu[0] = false
			factionlockermenu[0] = false
        end
    end
end

if text:find("That player isn't near you.") and color == -1347440726 then
			lua_thread.create(function()
				wait(0)
				if autobind.ddmode then
					_last_vest = localClock() - 6.8
				else
					_last_vest = localClock() - 11.8
				end
			end)
			
			if autobind.messages.playnotnear then
				return false
			end
		end

		if text:find("You can't /guard while aiming.") and color == -1347440726 then
			lua_thread.create(function()
				wait(0)
				if autobind.ddmode then
					_last_vest = localClock() - 6.8
				else
					_last_vest = localClock() - 11.8
				end
			end)
			
			if autobind.messages.aiming then
				return false
			end
		end

		if text:find("You must wait") and text:find("seconds before selling another vest.") and autobind.timercorrection then
			lua_thread.create(function()
				wait(0)
				cooldown = text:find("wait %d+ seconds")
				autobind.timer = cooldown + 0.5
			end)
			
			if autobind.messages.youmustwait then
				return false
			end
		end

		if text:find("* You offered protection to ") and text:find(" for $200.") and color == 869072810 then
			if autobind.messages.offered then
				return false
			end
		end
		
		if text:find("You accepted the protection for $200 from") and color == 869072810 then
			lua_thread.create(function()
				wait(0)
				sampname2 = 'Nobody'
				playerid2 = -1
			
				if autobind.notification_hide[2] then
					hide[2] = false
				end
			end)
			
			if autobind.messages.accepted then
				return false
			end
		end
			
		if text:find("You are not a bodyguard.") and color ==  -1347440726 then
			lua_thread.create(function()
				wait(0)
				sampname = 'Nobody'
				playerid = -1
			
				_you_are_not_bodyguard = false
			
				if autobind.notification_hide[1] then
					hide[1] = false
				end
			end)
		end
		
		if text:find("accepted your protection, and the $200 was added to your money.") and color == 869072810 then
			lua_thread.create(function()
				wait(0)
				sampname = 'Nobody'
				playerid = -1
				
				if autobind.notification_hide[1] then
					hide[1] = false
				end
			end)
			
			if autobind.messages.acceptedyour then
				return false
			end
		end
		
		if text:match("* You are now a Bodyguard, type /help to see your new commands.") then
			lua_thread.create(function()
				wait(0)
				_you_are_not_bodyguard = true
			end)
		end
		
		if text:find("* Bodyguard ") and text:find(" wants to protect you for $200, type /accept bodyguard to accept.") and color == 869072810 then
			lua_thread.create(function()
				wait(0)
				if autobind.notification_hide[2] then
					hide[2] = true
				end

				if color >= 40 and text ~= 746 then
					autoaccepternick = text:match("%* Bodyguard (.+) wants to protect you for %$200, type %/accept bodyguard to accept%.")
					autoaccepternick = autoaccepternick:gsub("%s+", "_")
					
					sampname2 = autoaccepternick
					playerid2 = sampGetPlayerIdByNickname(autoaccepternick)
					autoacceptertoggle = true
				end
				
				playsound(2)
				
				if getCharArmour(ped) < 49 and sampGetPlayerAnimationId(ped) ~= 746 and autoaccepter and not specstate then
					sampSendChat("/accept bodyguard")

					autoacceptertoggle = false
				end
			end)
			
			if autobind.messages.bodyguard then
				return false
			end
		end
	end
end

function autobind_repairmissing()
	if autobind.ddmode == nil then
		autobind.ddmode = false
	end
	if autobind.disableaftercapping == nil then
		autobind.disableaftercapping = false
	end
	if autobind.factionboth == nil then 
		autobind.factionboth = false
	end
	if autobind.enablebydefault == nil then 
		autobind.enablebydefault = true
	end
	if autobind.timercorrection == nil then 
		autobind.timercorrection = true
	end
	if autobind.customskins == nil then 
		autobind.customskins = false
	end
	if autobind.gangcustomskins == nil then 
		autobind.gangcustomskins = false
	end
	if autobind.gettarget == nil then
		autobind.gettarget = false
	end
	if autobind.notification == nil then
		autobind.notification = {}
	end
	if autobind.notification[1] == nil then 
		autobind.notification[1] = false
	end
	if autobind.notification[2] == nil then 
		autobind.notification[2] = false
	end
	if autobind.notification_hide == nil then
		autobind.notification_hide = {}
	end
	if autobind.notification_hide[1] == nil then 
		autobind.notification_hide[1] = false
	end
	if autobind.notification_hide[2] == nil then 
		autobind.notification_hide[2] = false
	end
	if autobind.showprevest == nil then 
		autobind.showprevest = true
	end
	if autobind.notification_capper == nil then 
		autobind.notification_capper = false
	end
	if autobind.notification_capper_hide == nil then 
		autobind.notification_capper_hide = false
	end
	if autobind.point_turf_mode == nil then 
		autobind.point_turf_mode = false
	end
	
	if autobind.badge == nil then
		autobind.badge = true
	end
	
	if autobind.faid == nil then
		autobind.faid = false
	end
	
	if autobind.faidnumber == nil then
		autobind.faidnumber = 49
	end
	
	if autobind.renewfaid == nil then
		autobind.renewfaid = false
	end
	
	if autobind.faidautovestonly == nil then
		autobind.faidautovestonly = false
	end
	
	if autobind.showpreoffered == nil then
		autobind.showpreoffered = true
	end
	
	if autobind.vestmode == nil then 
		autobind.vestmode = 0
	end
	if autobind.timer == nil then 
		autobind.timer = 12
	end
	if autobind.point_capper_timer == nil then 
		autobind.point_capper_timer = 14
	end
	if autobind.turf_capper_timer == nil then 
		autobind.turf_capper_timer = 17
	end
	if autobind.skinsurl == nil then
		autobind.skinsurl = "https://cdn.akacross.net/autobind/skins.html"
	end
	if autobind.skins == nil then
		autobind.skins = {}
	end
	if autobind.skins2 == nil then
		autobind.skins2 = {}
	end
	if autobind.customskins == nil then
		autobind.customskins = false
	end
	if autobind.advancedview == nil then
		autobind.advancedview = false
	end
	if autobind.autovestsettingscmd == nil then 
		autobind.autovestsettingscmd = "autobind"
	end
	if autobind.vestnearcmd == nil then 
		autobind.vestnearcmd = "vestnear"
	end
	if autobind.sexnearcmd == nil then 
		autobind.sexnearcmd = "sexnear"
	end
	if autobind.repairnearcmd == nil then 
		autobind.repairnearcmd = "repairnear"
	end
	if autobind.hfindcmd == nil then 
		autobind.hfindcmd = "hfind"
	end
	if autobind.tcapcmd == nil then 
		autobind.tcapcmd = "tcap"
	end
	if autobind.sprintbindcmd == nil then 
		autobind.sprintbindcmd = "sprintbind"
	end
	if autobind.bikebindcmd == nil then 
		autobind.bikebindcmd = "bikebind"
	end
	if autobind.autoacceptercmd == nil then 
		autobind.autoacceptercmd = "av"
	end
	if autobind.ddmodecmd == nil then 
		autobind.ddmodecmd = "ddmode"
	end
	if autobind.vestmodecmd == nil then 
		autobind.vestmodecmd = "vestmode"
	end
	if autobind.factionbothcmd == nil then 
		autobind.factionbothcmd = "factionboth"
	end
	if autobind.autovestcmd == nil then 
		autobind.autovestcmd = "autovest"
	end
	if autobind.turfmodecmd == nil then 
		autobind.turfmodecmd = 'turfmode'
	end
	if autobind.pointmodecmd == nil then 
		autobind.pointmodecmd = 'pointmode'
	end
	if autobind.offerpos == nil then 
		autobind.offerpos = {10, 273}
	end
	if autobind.offeredpos == nil then 
		autobind.offeredpos = {10, 348}
	end
	if autobind.capperpos == nil then 
		autobind.capperpos = {10, 435}
	end
	local resX, resY = getScreenResolution()
	if autobind.menupos == nil then 
		autobind.menupos = {
			string.format("%d", (resX / 2) - 455 / 2), 
			string.format("%d", (resY / 2) - 185 / 2)
		}
		autobind.menupos = {
			tonumber(autobind.menupos[1]), 
			tonumber(autobind.menupos[2])
		}
	end
	
	if autobind.names == nil then 
		autobind.names = {}
	end
	if autobind.Keybinds == nil then
		autobind.Keybinds = {}
	end
	if autobind.Keybinds.Accept == nil then
		autobind.Keybinds.Accept = {}
	end
	if autobind.Keybinds.Accept.Toggle == nil then 
		autobind.Keybinds.Accept.Toggle = true
	end
	if autobind.Keybinds.Accept.Keybind == nil then 
		autobind.Keybinds.Accept.Keybind = tostring(VK_MENU)..','..tostring(VK_V)
	end
	if autobind.Keybinds.Accept.Dual == nil then 
		autobind.Keybinds.Accept.Dual = true
	end
	if autobind.Keybinds.Accept.Dual == nil then 
		autobind.Keybinds.Accept.Dual = true
	end
	if autobind.Keybinds.Offer == nil then
		autobind.Keybinds.Offer = {}
	end
	if autobind.Keybinds.Offer.Toggle == nil then 
		autobind.Keybinds.Offer.Toggle = true
	end
	if autobind.Keybinds.Offer.Keybind == nil then 
		autobind.Keybinds.Offer.Keybind = tostring(VK_MENU)..','..tostring(VK_O)
	end
	if autobind.Keybinds.Offer.Dual == nil then 
		autobind.Keybinds.Offer.Dual = true
	end
	if autobind.Keybinds.BlackMarket == nil then
		autobind.Keybinds.BlackMarket = {}
	end
	if autobind.Keybinds.BlackMarket.Toggle == nil then 
		autobind.Keybinds.BlackMarket.Toggle = false
	end
	if autobind.Keybinds.BlackMarket.Keybind == nil then 
		autobind.Keybinds.BlackMarket.Keybind = tostring(VK_MENU)..','..tostring(VK_X)
	end
	if autobind.Keybinds.BlackMarket.Dual == nil then 
		autobind.Keybinds.BlackMarket.Dual = true
	end
	if autobind.Keybinds.FactionLocker == nil then
		autobind.Keybinds.FactionLocker = {}
	end
	if autobind.Keybinds.FactionLocker.Toggle == nil then 
		autobind.Keybinds.FactionLocker.Toggle = false
	end
	if autobind.Keybinds.FactionLocker.Keybind == nil then 
		autobind.Keybinds.FactionLocker.Keybind = tostring(VK_MENU)..','..tostring(VK_X)
	end
	if autobind.Keybinds.FactionLocker.Dual == nil then 
		autobind.Keybinds.FactionLocker.Dual = true
	end
	
	if autobind.Keybinds.GangLocker == nil then
		autobind.Keybinds.GangLocker = {}
	end
	if autobind.Keybinds.GangLocker.Toggle == nil then 
		autobind.Keybinds.GangLocker.Toggle = false
	end
	if autobind.Keybinds.GangLocker.Keybind == nil then 
		autobind.Keybinds.GangLocker.Keybind = tostring(VK_MENU)..','..tostring(VK_X)
	end
	if autobind.Keybinds.GangLocker.Dual == nil then 
		autobind.Keybinds.GangLocker.Dual = true
	end
	
	if autobind.Keybinds.BikeBind == nil then
		autobind.Keybinds.BikeBind = {}
	end
	if autobind.Keybinds.BikeBind.Toggle == nil then 
		autobind.Keybinds.BikeBind.Toggle = false
	end
	if autobind.Keybinds.BikeBind.Keybind == nil then 
		autobind.Keybinds.BikeBind.Keybind = tostring(VK_SHIFT)
	end
	if autobind.Keybinds.BikeBind.Dual == nil then 
		autobind.Keybinds.BikeBind.Dual = false
	end
	if autobind.Keybinds.SprintBind == nil then
		autobind.Keybinds.SprintBind = {}
	end
	if autobind.Keybinds.SprintBind.Toggle == nil then 
		autobind.Keybinds.SprintBind.Toggle = true
	end
	if autobind.Keybinds.SprintBind.Keybind == nil then 
		autobind.Keybinds.SprintBind.Keybind = tostring(VK_F11)
	end
	if autobind.Keybinds.SprintBind.Dual == nil then 
		autobind.Keybinds.SprintBind.Dual = false
	end
	if autobind.Keybinds.Frisk == nil then
		autobind.Keybinds.Frisk = {}
	end
	if autobind.Keybinds.Frisk.Toggle == nil then 
		autobind.Keybinds.Frisk.Toggle = false
	end
	if autobind.Keybinds.Frisk.Keybind == nil then 
		autobind.Keybinds.Frisk.Keybind = tostring(VK_MENU)..','..tostring(VK_F)
	end
	if autobind.Keybinds.Frisk.Dual == nil then 
		autobind.Keybinds.Frisk.Dual = true
	end
	if autobind.Keybinds.TakePills == nil then
		autobind.Keybinds.TakePills = {}
	end
	if autobind.Keybinds.TakePills.Toggle == nil then 
		autobind.Keybinds.TakePills.Toggle = false
	end
	if autobind.Keybinds.TakePills.Keybind == nil then 
		autobind.Keybinds.TakePills.Keybind = tostring(VK_F3)
	end
	if autobind.Keybinds.TakePills.Dual == nil then 
		autobind.Keybinds.TakePills.Dual = false
	end
	
	if autobind.Keybinds.AcceptDeath == nil then
		autobind.Keybinds.AcceptDeath = {}
	end
	if autobind.Keybinds.AcceptDeath.Toggle == nil then 
		autobind.Keybinds.AcceptDeath.Toggle = true
	end
	if autobind.Keybinds.AcceptDeath.Keybind == nil then 
		autobind.Keybinds.AcceptDeath.Keybind = tostring(VK_OEM_MINUS)
	end
	if autobind.Keybinds.AcceptDeath.Dual == nil then 
		autobind.Keybinds.AcceptDeath.Dual = false
	end
	
	if autobind.Keybinds.FAid == nil then
		autobind.Keybinds.FAid = {}
	end
	if autobind.Keybinds.FAid.Toggle == nil then 
		autobind.Keybinds.FAid.Toggle = false
	end
	if autobind.Keybinds.FAid.Keybind == nil then 
		autobind.Keybinds.FAid.Keybind = tostring(VK_MENU)..','..tostring(VK_N)
	end
	if autobind.Keybinds.FAid.Dual == nil then 
		autobind.Keybinds.FAid.Dual = true
	end
	
	if autobind.BlackMarket == nil then
		autobind.BlackMarket = {}
	end
	if autobind.BlackMarket[1] == nil then 
		autobind.BlackMarket[1] = true
	end
	if autobind.BlackMarket[2] == nil then 
		autobind.BlackMarket[2] = false
	end
	if autobind.BlackMarket[3] == nil then 
		autobind.BlackMarket[3] = false
	end
	if autobind.BlackMarket[4] == nil then 
		autobind.BlackMarket[4] = false
	end
	if autobind.BlackMarket[5] == nil then 
		autobind.BlackMarket[5] = false
	end
	if autobind.BlackMarket[6] == nil then 
		autobind.BlackMarket[6] = false
	end
	if autobind.BlackMarket[7] == nil then 
		autobind.BlackMarket[7] = false
	end
	if autobind.BlackMarket[8] == nil then 
		autobind.BlackMarket[8] = false
	end
	if autobind.BlackMarket[9] == nil then 
		autobind.BlackMarket[9] = true
	end
	if autobind.BlackMarket[10] == nil then 
		autobind.BlackMarket[10] = false
	end
	if autobind.BlackMarket[11] == nil then 
		autobind.BlackMarket[11] = false
	end
	if autobind.BlackMarket[12] == nil then 
		autobind.BlackMarket[12] = false
	end
	if autobind.BlackMarket[13] == nil then 
		autobind.BlackMarket[13] = false
	end
	
	if autobind.FactionLocker == nil then
		autobind.FactionLocker = {}
	end
	if autobind.FactionLocker[1] == nil then 
		autobind.FactionLocker[1] = true
	end
	if autobind.FactionLocker[2] == nil then 
		autobind.FactionLocker[2] = true
	end
	if autobind.FactionLocker[3] == nil then 
		autobind.FactionLocker[3] = false
	end
	if autobind.FactionLocker[4] == nil then 
		autobind.FactionLocker[4] = true
	end
	if autobind.FactionLocker[5] == nil then 
		autobind.FactionLocker[5] = false
	end
	if autobind.FactionLocker[6] == nil then 
		autobind.FactionLocker[6] = false
	end
	if autobind.FactionLocker[7] == nil then 
		autobind.FactionLocker[7] = false
	end
	if autobind.FactionLocker[8] == nil then 
		autobind.FactionLocker[8] = false
	end
	if autobind.FactionLocker[9] == nil then 
		autobind.FactionLocker[9] = false
	end
	if autobind.FactionLocker[10] == nil then 
		autobind.FactionLocker[10] = true
	end
	if autobind.FactionLocker[11] == nil then 
		autobind.FactionLocker[11] = true
	end
	
	if autobind.GangLocker == nil then
		autobind.GangLocker = {}
	end
	if autobind.GangLocker[1] == nil then 
		autobind.GangLocker[1] = true
	end
	if autobind.GangLocker[2] == nil then 
		autobind.GangLocker[2] = false
	end
	if autobind.GangLocker[3] == nil then 
		autobind.GangLocker[3] = false
	end
	if autobind.GangLocker[4] == nil then 
		autobind.GangLocker[4] = false
	end
	if autobind.GangLocker[5] == nil then 
		autobind.GangLocker[5] = false
	end
	if autobind.GangLocker[6] == nil then 
		autobind.GangLocker[6] = false
	end
	if autobind.GangLocker[7] == nil then 
		autobind.GangLocker[7] = false
	end
	
	if autobind.SprintBind == nil then
		autobind.SprintBind = {}
	end
	if autobind.SprintBind.delay == nil then 
		autobind.SprintBind.delay = 10
	end
	
	if autobind.Frisk == nil then
		autobind.Frisk = {}
	end
	if autobind.Frisk[1] == nil then 
		autobind.Frisk[1] = false
	end
	if autobind.Frisk[2] == nil then 
		autobind.Frisk[2] = false
	end
	
	if autobind.imcolor == nil then
		autobind.imcolor = {}
	end
	if autobind.imcolor[1] == nil then 
		autobind.imcolor[1] = 0.98
	end
	
	if autobind.imcolor[2] == nil then 
		autobind.imcolor[2] = 0.26
	end
	
	if autobind.imcolor[3] == nil then 
		autobind.imcolor[3] = 0.26
	end
	
	if autobind.imcolor[4] == nil then 
		autobind.imcolor[4] = 1.00
	end
	
	if autobind.fa6 == nil then 
		autobind.fa6 = 'regular'
	end
	
	if autobind.progressbar == nil then 
		autobind.progressbar = {}
	end
	if autobind.progressbar.toggle == nil then
		autobind.progressbar.toggle = false
	end
	if autobind.progressbar.color == nil then 
		autobind.progressbar.color = {}
	end
	if autobind.progressbar.color[1] == nil then 
		autobind.progressbar.color[1] = 0.98
	end
	
	if autobind.progressbar.color[2] == nil then 
		autobind.progressbar.color[2] = 0.26
	end
	
	if autobind.progressbar.color[3] == nil then 
		autobind.progressbar.color[3] = 0.26
	end
	
	if autobind.progressbar.color[4] == nil then 
		autobind.progressbar.color[4] = 1.00
	end
	
	if autobind.progressbar.colorfade == nil then 
		autobind.progressbar.colorfade = {}
	end
	if autobind.progressbar.colorfade[1] == nil then 
		autobind.progressbar.colorfade[1] = 0.98
	end
	
	if autobind.progressbar.colorfade[2] == nil then 
		autobind.progressbar.colorfade[2] = 0.26
	end
	
	if autobind.progressbar.colorfade[3] == nil then 
		autobind.progressbar.colorfade[3] = 0.26
	end
	
	if autobind.progressbar.colorfade[4] == nil then 
		autobind.progressbar.colorfade[4] = 0.50
	end
	if autobind.timertext == nil then 
		autobind.timertext = true
	end
	
	if autobind.audio == nil then 
		autobind.audio = {}
	end
	
	if autobind.audio.toggle == nil then 
		autobind.audio.toggle = {}
	end
	if autobind.audio.toggle[1] == nil then 
		autobind.audio.toggle[1] = false
	end
	if autobind.audio.toggle[2] == nil then 
		autobind.audio.toggle[2] = false
	end
	if autobind.audio.toggle[3] == nil then 
		autobind.audio.toggle[3] = false
	end
	
	if autobind.audio.sounds == nil then 
		autobind.audio.sounds = {}
	end
	if autobind.audio.sounds[1] == nil then 
		autobind.audio.sounds[1] = "sound1.mp3"
	end
	if autobind.audio.sounds[2] == nil then 
		autobind.audio.sounds[2] = "sound2.mp3"
	end
	if autobind.audio.sounds[3] == nil then 
		autobind.audio.sounds[3] = "sound3.mp3"
	end
	
	if autobind.audio.paths == nil then 
		autobind.audio.paths = {}
	end
	if autobind.audio.paths[1] == nil then 
		autobind.audio.paths[1] = audiofolder .. "sound1.mp3"
	end
	if autobind.audio.paths[2] == nil then 
		autobind.audio.paths[2] = audiofolder .. "sound2.mp3"
	end
	if autobind.audio.paths[3] == nil then 
		autobind.audio.paths[3] = audiofolder .. "sound3.mp3"
	end
	
	if autobind.audio.volumes == nil then 
		autobind.audio.volumes = {}
	end
	if autobind.audio.volumes[1] == nil then 
		autobind.audio.volumes[1] = 0.10
	end
	if autobind.audio.volumes[2] == nil then 
		autobind.audio.volumes[2] = 0.10
	end
	if autobind.audio.volumes[3] == nil then 
		autobind.audio.volumes[3] = 0.10
	end
	
	if autobind.streamedplayers == nil then 
		autobind.streamedplayers = {}
	end
	
	if autobind.streamedplayers.toggle == nil then 
		autobind.streamedplayers.toggle = false
	end
	
	if autobind.streamedplayers.pos == nil then 
		autobind.streamedplayers.pos = {}
	end
	if autobind.streamedplayers.pos[1] == nil then 
		autobind.streamedplayers.pos[1] = 244
	end
	if autobind.streamedplayers.pos[2] == nil then 
		autobind.streamedplayers.pos[2] = 401
	end
	
	if autobind.streamedplayers.color == nil then 
		autobind.streamedplayers.color = -1
	end
	
	if autobind.streamedplayers.color == nil then 
		autobind.streamedplayers.color = -1
	end
	
	if autobind.streamedplayers.font == nil then 
		autobind.streamedplayers.font = "Arial"
	end
	
	if autobind.streamedplayers.fontsize == nil then 
		autobind.streamedplayers.fontsize = 12
	end
	
	if autobind.streamedplayers.fontflag == nil then 
		autobind.streamedplayers.fontflag = {}
	end
	if autobind.streamedplayers.fontflag[1] == nil then 
		autobind.streamedplayers.fontflag[1] = true
	end
	if autobind.streamedplayers.fontflag[2] == nil then 
		autobind.streamedplayers.fontflag[2] = true
	end
	if autobind.streamedplayers.fontflag[3] == nil then 
		autobind.streamedplayers.fontflag[3] = true
	end
	if autobind.streamedplayers.fontflag[4] == nil then 
		autobind.streamedplayers.fontflag[4] = true
	end
	
	if autobind.streamedplayers.alignfont == nil then 
		autobind.streamedplayers.alignfont = 2
	end
	
	if autobind.messages == false or autobind.messages == true then 
		autobind.messages = {}
	end
	if autobind.messages == nil then 
		autobind.messages = {}
	end
	if autobind.messages.bodyguard == nil then
		autobind.messages.bodyguard = false
	end
	if autobind.messages.acceptedyour == nil then
		autobind.messages.acceptedyour = false
	end
	if autobind.messages.accepted == nil then
		autobind.messages.accepted = false
	end
	if autobind.messages.offered == nil then
		autobind.messages.offered = false
	end
	if autobind.messages.youmustwait == nil then
		autobind.messages.youmustwait = false
	end
	if autobind.messages.aiming == nil then
		autobind.messages.aiming = false
	end
	if autobind.messages.playnotnear == nil then
		autobind.messages.playnotnear = false
	end
	if autobind.messages.noeffect == nil then
		autobind.messages.noeffect = false
	end
	if autobind.messages.nofaid == nil then
		autobind.messages.nofaid = false
	end
end


function string.contains(str, matchstr, matchorfind)
	if matchorfind then
		if str:match(matchstr) then
			return true
		end
		return false
	else
		if str:find(matchstr) then
			return true
		end
		return false
	end
end

function scanGameFolder(path, tables)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            --local f = path..'\\'..file
			local f = path..file
			local file_extension = string.match(file, "([^\\%.]+)$") -- Avoids double "extension" file names from being included and seen as "audiofile"
            if file_extension:match("mp3") or file_extension:match("mp4") or file_extension:match("wav") or file_extension:match("m4a") or file_extension:match("flac") or file_extension:match("m4r") or file_extension:match("ogg")
			or file_extension:match("mp2") or file_extension:match("amr") or file_extension:match("wma") or file_extension:match("aac") or file_extension:match("aiff") then
				table.insert(tables, file)
                tables[file] = f
            end 
            if lfs.attributes(f, "mode") == "directory" then
                tables = scanGameFolder(f, tables)
            end 
        end
    end
    return tables
end

function getClosestPlayerId(maxdist, type)
	for i = 0, sampGetMaxPlayerId(false) do
        local result, remotePlayer = sampGetCharHandleBySampPlayerId(i)
        if result and not sampIsPlayerPaused(i) then
			local remotePlayerX, remotePlayerY, remotePlayerZ = getCharCoordinates(remotePlayer);
            local myPosX, myPosY, myPosZ = getCharCoordinates(playerPed)
            local dist = getDistanceBetweenCoords3d(remotePlayerX, remotePlayerY, remotePlayerZ, myPosX, myPosY, myPosZ)
            if dist <= maxdist then
				if type == 1 then
					return result, i 
				elseif type == 2 and not isCharInAnyCar(ped) and isCharInAnyCar(remotePlayer) then 
					return result, i
				end
			end
		end
    end
	return false, -1
end

function isPlayerAiming(thirdperson, firstperson)
	local id = mem.read(11989416, 2, false)
	if thirdperson and (id == 5 or id == 53 or id == 55 or id == 65) then return true end
	if firstperson and (id == 7 or id == 8 or id == 16 or id == 34 or id == 39 or id == 40 or id == 41 or id == 42 or id == 45 or id == 46 or id == 51 or id == 52) then return true end
end

function getDownKeys()
    local keyslist = nil
    local bool = false
    for k, v in pairs(vk) do
        if isKeyDown(v) then
            keyslist = v
            bool = true
        end
    end
    return keyslist, bool
end

function keycheck(k)
    local r = true
    for i = 1, #k.k do r = r and PressType[k.t[i]](k.k[i]) end
    return r
end

function has_number(tab, val)
    for index, value in ipairs(tab) do
        if tonumber(value) == val then
            return true
        end
    end

    return false
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
