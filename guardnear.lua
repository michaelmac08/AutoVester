script_name("guardnear")
script_author("Random")
script_version("2.1.9")

local prefix = "{990000}Yakuza {FFFFFF}| {FF0000}LFC {FFFFFF}| {460C09}Bloods {FFFFFF}| {006400}GSF {FFFFFF}| {1E90FF}[Autovest]: "
require "lib.moonloader"
require "lib.sampfuncs"
local inicfg = require "inicfg"
local q = require 'lib.samp.events'

local configPath = getWorkingDirectory() .. "\\config\\Autovester.ini"
local config

function doesFileExist(file)
    local f = io.open(file, "r")
    if f then
        io.close(f)
        return true
    else
        return false
    end
end

local function loadConfig()
    if doesFileExist(configPath) then
        config = inicfg.load(nil, configPath)
    else
        config = {
            General = {
                Av = false,
                Avest = false
            }
        }
        inicfg.save(config, configPath)
    end
end

local function saveConfig()
    inicfg.save(config, configPath)
end

local ActivateServerMsg = false
local ActivateAvest = false

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end
    if isSampAvailable() then
        wait(0)
    end
    sampAddChatMessage(prefix .. "{FFFFFF}Successfully loaded!", -1)
    loadConfig()
    sampRegisterChatCommand("av", cmdAv)
    sampRegisterChatCommand("avest", cmdAvest)
    sampRegisterChatCommand("avhelp", cmdAvHelp)
    while true do
        wait(100)
        playerid = getClosestPlayerId(7, true)
        if sampIsPlayerConnected(playerid) and config.General.Avest then
            sampSendChat(string.format("/guard %d 200", playerid))
            wait(11200)
        end
    end
end

function getClosestPlayerId(maxdist, ArmorCheck)
    local GangSkins = {60, 49, 193, 210, 263, 122, 186, 123, 0, 270, 269, 271, 106, 195, 190, 19, 144, 170, 180, 160, 67, 219, 3, 93, 147, 98, 305, 150, 295, 234, 107, 119, 293}
    local i = -1
    local maxplayerid = sampGetMaxPlayerId(false)
    for i = 0, maxplayerid do
        if sampIsPlayerConnected(i) then
            local result, ped = sampGetCharHandleBySampPlayerId(i)
            if result and not sampIsPlayerPaused(i) then
                local dist = get_distance_to_player(i)
                if (dist < maxdist and sampGetPlayerArmor(i) < 48) then
                    if has_value(GangSkins, getCharModel(ped)) then
                        return i
                    end
                end
            end
        end
    end
    return i
end

function get_distance_to_player(playerId)
    local dist = -1
    if sampIsPlayerConnected(playerId) then
        local result, ped = sampGetCharHandleBySampPlayerId(playerId)
        if result then
            local myX, myY, myZ = getCharCoordinates(playerPed)
            local playerX, playerY, playerZ = getCharCoordinates(ped)
            dist = getDistanceBetweenCoords3d(myX, myY, myZ, playerX, playerY, playerZ)
            return dist
        end
    end
    return dist
end

function cmdAv()
    config.General.Av = not config.General.Av
    saveConfig()
    if config.General.Av then
        sampAddChatMessage("{1E90FF}[Autovest]:{FFFFFF}Auto accept vest has been enabled.")
    else
        sampAddChatMessage("{1E90FF}[Autovest]:{FFFFFF}Auto accept vest has been disabled.")
    end
    if config.General.Av then
        q.onServerMessage = function(c, s)
            if string.find(s, "wants to protect you for $200, type /accept bodyguard to accept.") then
                sampSendChat("/accept bodyguard")
            end
        end
    else
        q.onServerMessage = nil
    end
end


function cmdAvest()
    config.General.Avest = not config.General.Avest
    saveConfig()
    if config.General.Avest then
        sampAddChatMessage(prefix .. "{FFFFFF}has been enabled.")
    else
        sampAddChatMessage(prefix .. "{FFFFFF}has been disabled.")
    end
end

function cmdAvHelp()
    sampShowDialog(69, "{1E90FF}Autovest", "{FFFFFF}/Avest - Autovest\n/Av - Auto accept vest", "Close")
end

function q.onServerMessage(c, s)
    if string.find(s, "wants to protect you for $200, type /accept bodyguard to accept.") and config.General.Av then
        sampSendChat("/accept bodyguard")
    end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
