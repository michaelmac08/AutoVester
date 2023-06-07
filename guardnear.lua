require "lib.moonloader"
require "lib.sampfuncs"
local inicfg = require "inicfg"
local q = require 'lib.samp.events'

local ActivateServerMsg = false -- Initialize ActivateServerMsg variable
local ActivateAvest = false -- Initialize ActivateAvest variable
local lastGuardTime = 0 -- Variable to store the last time "/guard" command was sent

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end
    sampRegisterChatCommand("av", cmdServerMsg)
    sampRegisterChatCommand("avest", cmdAvest)
    while true do
        wait(100)
        playerid = getClosestPlayerId(7, true)
        if sampIsPlayerConnected(playerid) and ActivateAvest then
            local currentTime = os.clock()
            if currentTime - lastGuardTime >= 11.2 then
                if GangSkins(playerid) then
                    sampSendChat(string.format("/guard %d 200", playerid))
                    lastGuardTime = currentTime
                end
            end
        end
    end
end

function isKeyControlAvailable()
    if not isSampLoaded() then
        return true
    end
    if not isSampfuncsLoaded() then
        return not sampIsChatInputActive() and not sampIsDialogActive()
    end
    return not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive()
end

function getClosestPlayerId(maxdist, ArmorCheck)
    local i = -1
    local maxplayerid = sampGetMaxPlayerId(false)
    for i = 0, maxplayerid do
        if sampIsPlayerConnected(i) then
            local result, ped = sampGetCharHandleBySampPlayerId(i)
            if result and not sampIsPlayerPaused(i) then
                local dist = get_distance_to_player(i)
                if dist < maxdist then
                    if ArmorCheck then
                        if sampGetPlayerArmor(i) < 48 then
                            return i
                        end
                    else
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

function GangSkins(playerId)
    local gangSkins = {49, 193, 210, 228, 263, 122, 186, 123, 0, 270, 269, 271, 106, 195}
    local result, ped = sampGetCharHandleBySampPlayerId(playerId)
    if result then
        local playerModel = getCharModel(ped)
        for i = 1, #gangSkins do
            if playerModel == gangSkins[i] then
                return true
            end
        end
    end
    return false
end

function cmdServerMsg()
    ActivateServerMsg = not ActivateServerMsg
    if ActivateServerMsg then
        sampAddChatMessage("{33CCFF}Auto Accept Vest {FFFFFF}has been activated.")
    else
        sampAddChatMessage("{33CCFF}Auto Accept Vest {FFFFFF}has been disabled.")
    end
    if ActivateServerMsg then
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
    ActivateAvest = not ActivateAvest
    if ActivateAvest then
        sampAddChatMessage("{33CCFF}AutoVest {FFFFFF}has been Activated.")
    else
        sampAddChatMessage("{33CCFF}AutoVest {FFFFFF}has been Disabled.")
    end
end

function q.onServerMessage(c, s)
    if string.find(s, "wants to protect you for $200, type /accept bodyguard to accept.") and ActivateServerMsg then
        sampSendChat("/accept bodyguard")
    end
end

