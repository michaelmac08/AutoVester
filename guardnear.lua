require "lib.moonloader"
require "lib.sampfuncs"
local q = require 'lib.samp.events'

local ActivateServerMsg = false
local ActivateAvest = false
local lastGuardTime = 0

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(250)
    end
    sampAddChatMessage("{33CCFF}[AutoVest] {FFFFFF}Loading the script... {33CCFF}[/avhelp]", -1)
    sampRegisterChatCommand("av", cmdServerMsg)
    sampRegisterChatCommand("avest", cmdAvest)
    sampRegisterChatCommand("avhelp", cmdAvHelp)
    ActivateAvest = true
    while true do
        wait(100)
        playerid = getClosestPlayerId(7, true)
        if sampIsPlayerConnected(playerid) and ActivateAvest then
            local currentTime = os.clock()
            if currentTime - lastGuardTime >= 11.2 then
                sampSendChat(string.format("/guard %d 200", playerid))
                lastGuardTime = currentTime
            end
        end
    end
end

function getClosestPlayerId(maxdist, ArmorCheck)
    local GangSkins = {49, 193, 210, 228, 263, 122, 186, 123, 0, 270, 269, 271, 106, 195, 190, 19, 144, 170, 180, 160, 67, 219, 3, 93, 147, 98, 305, 150, 295, 234, 107, 119, 293}
    local i = -1
    local maxplayerid = sampGetMaxPlayerId(false)
    for i = 0, maxplayerid do
        if sampIsPlayerConnected(i) then
            local result, ped = sampGetCharHandleBySampPlayerId(i)
            if result and not sampIsPlayerPaused(i) then
                local dist = get_distance_to_player(i)
                if dist < maxdist then
                    if ArmorCheck then
                        if sampGetPlayerArmor(i) < 48 and has_value(GangSkins, getCharModel(ped)) then
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
        sampAddChatMessage("{33CCFF}[AutoVest]: {FFFFFF}has been Activated.")
    else
        sampAddChatMessage("{33CCFF}[AutoVest]: {FFFFFF}has been Disabled.")
    end
end

function cmdAvHelp()
    sampShowDialog(69, "{33CCFF}AutoVest", "{FFFFFF}AutoVest is a mod that automatically offers the player a vest when their current armor falls below a certain threshold.\n/av - Toggle Auto Accept Vest.\n/avest - Toggle AutoVest.", "Close")
end

function q.onServerMessage(c, s)
    if string.find(s, "wants to protect you for $200, type /accept bodyguard to accept.") and ActivateServerMsg then
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
