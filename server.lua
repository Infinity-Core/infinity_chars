RegisterServerEvent('infinity_chars:SetSkinFromChars')
AddEventHandler('infinity_chars:SetSkinFromChars', function(PedID)
    local _source       = source
    local SourceSteamID = exports.infinity_core:GetPlayerSource(source)
    Wait(1000)
    local SkinPed       = MySQL.prepare.await('SELECT skin, clothes FROM skins_players WHERE steam_identifier = ? AND charid = ?', {SourceSteamID, PedID})
    local loadSkin      = json.decode(SkinPed.skin)
    local loadOutfit    = json.decode(SkinPed.clothes)
    TriggerClientEvent("infinity_chars:ApplySkinPed", _source, loadSkin, loadOutfit) 
end)

RegisterServerEvent('infinity_chars:selectmychars')
AddEventHandler('infinity_chars:selectmychars', function(PedID)
    local _source       = source
    local SourceSteamID = exports.infinity_core:GetPlayerSource(_source)
    exports.oxmysql:prepare('SELECT * FROM players WHERE steam_identifier = ?', {SourceSteamID}, function(result)
        exports.oxmysql:scalar('SELECT charid FROM players WHERE steam_identifier = ?', {SourceSteamID}, function(totalchars)
            TriggerClientEvent("infinity_chars:openmenu", _source, result, totalchars) 
        end)
    end)
end)

-----
-- [CHANGE CURRENT CARACTER FROM INGAME LIVE]
-----
RegisterServerEvent('infinity_chars:allchars')
AddEventHandler('infinity_chars:allchars', function(source)
    local _source       = source
    local SourceSteamID = exports.infinity_core:GetPlayerSource(tonumber(_source))
    if SourceSteamID then
        exports.oxmysql:prepare('SELECT * FROM players WHERE steam_identifier = ?', {SourceSteamID}, function(result)
            exports.oxmysql:prepare('SELECT charid FROM players WHERE steam_identifier = ?', {SourceSteamID}, function(totalchars)
                TriggerClientEvent("infinity_chars:openmenu", _source, result, totalchars) 
            end)
        end)
    end
end)

-----
-- [CHANGE SESSION (( CURRENT IN PROGRESS ))]
-----
RegisterCommand("changesession", function(source, args, rawCommand)
    local _source       = source
    local SourceSteamID = exports.infinity_core:GetPlayerSource(_source)
    TriggerClientEvent('infinity_core:stopSession', _source)
    if SourceSteamID then
        exports.oxmysql:prepare('SELECT * FROM players WHERE steam_identifier = ?', {SourceSteamID}, function(result)
            exports.oxmysql:prepare('SELECT charid FROM players WHERE steam_identifier = ?', {SourceSteamID}, function(totalchars)
                TriggerClientEvent("infinity_chars:openmenu", _source, result, #totalchars) 
            end)
        end)
    end
end)