local display = false
local firstCall = true

function SetGuarmaWorldhorizonActive(toggle)
    Citizen.InvokeNative(0x74E2261D2A66849A , toggle)
end
function SetWorldWaterType(waterType)
    Citizen.InvokeNative(0xE8770EE02AEE45C2, waterType)
end
function SetWorldMapType(mapType)
    Citizen.InvokeNative(0xA657EC9DBC6CC900, mapType)
end
function IsInGuarma()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    return x >= 0 and y <= -4096
end

RegisterNetEvent('infinity_chars:openmenu')
AddEventHandler('infinity_chars:openmenu', function(CharsPlayer, totalchars)
    Wait(6500)
    DisplayHud(false)
    DisplayRadar(false)
    StartCamera()
    SetDisplayChars(not display, CharsPlayer, totalchars)
end)

function SetDisplayChars(bool, CharsPlayer, totalchars)
    display    = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type        = "ui",
        CharsPlayer = CharsPlayer,
        totalchars  = totalchars,
        status      = bool
    })
end

local list_f        = {}
local list          = {}
local BODY_TYPES    = {
    32611963,
    -20262001,
    -369348190,
    -1241887289,
    61606861,
    61606861,
}
Citizen.CreateThread(function()
    for i,v in pairs(cloth_hash_names) do
        if v.category_hashname == "BODIES_LOWER"
            or v.category_hashname == "BODIES_UPPER"
            or  v.category_hashname == "heads"
            or  v.category_hashname == "hair"
            or  v.category_hashname == "teeth"
            or  v.category_hashname == "eyes"
            or  v.category_hashname == "beards_chin"
            or  v.category_hashname == "beards_chops"
            or  v.category_hashname == "beard"  then
            if v.ped_type == "female" and v.is_multiplayer and v.hashname ~= "" then
                if list_f[v.category_hashname] == nil then
                    list_f[v.category_hashname] = {}
                end
                table.insert(list_f[v.category_hashname], v.hash)
            elseif v.ped_type == "male" and v.is_multiplayer and v.hashname ~= ""  then
                if  list[v.category_hashname] == nil then
                    list[v.category_hashname] = {}
                end
                table.insert(list[v.category_hashname], v.hash)
            end
        end
    end
end)

---- CAMERA TRANSITION ---
local transition_time    = 1000
local cam_location       = {x= -245.40518188477, y= 672.02960205078, z= 115.03829193115, h= 229.01280212402}
local cam                = false
anim                     = "coffee"

function StartCamera()
    Citizen.Wait(100)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1420.03 , -7317.05 , 81.24, 0.00, 0.00, 100.00, 30.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true,true,transition_time,true)
end

RegisterNUICallback("PedID", function(data)
    if not ENTITY_DELETED then 
        ENTITY_DELETED = true
        TriggerServerEvent('infinity_chars:SetSkinFromChars', data.PedID)
    end
end)

--- SELECTOR FOR INIT SESSION CORE
RegisterNUICallback("SelectPedID", function(data)
    CharSelected = data.PedID
end)

---- CAMERA TRANSITION ---
RegisterNUICallback("exit", function(data)
    SetDisplayChars(false)
    DoScreenFadeOut(6500)
    ClearPedTasksImmediately(pedDemo)
    Citizen.InvokeNative(0xB31A277C1AC7B7FF,pedDemo,3,2,GetHashKey("KIT_EMOTE_TAUNT_COUGAR_SNARL_1"),0,0,0,0,0)
    Wait(6500)
    DestroyCam(cam, true)
    cam = false
    Citizen.Wait(transition_time)
    Citizen.InvokeNative(0x5D1EB123EAC5D071, 0.0, 1065353216)
    _InfinitySource        = GetPlayerServerId(PlayerId())
    TriggerServerEvent('infinity_core:LoadDatasPlayerSelected', _InfinitySource, CharSelected)
    DeleteEntity(pedDemo)
    RenderScriptCams(false,true,transition_time,true,true)
    Wait(6500)
    DoScreenFadeIn(6500)
end)

RegisterNUICallback("Previous", function(data)
    TaskGoToCoordAnyMeans(target, 1415.02 , -7321.0 , 81.46 -1, 1.0, 0, 0, 0, 0.5)
    DeletePed(target)
    ENTITY_DELETED = false
end)

---- LOAD THE SELECT PED ---
function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

-- Function to preload models at script start
function PreloadModels()
    local maleHash = GetHashKey("mp_male")
    local femaleHash = GetHashKey("mp_female")

    RequestModel(maleHash)
    RequestModel(femaleHash)

    local timer = 0
    while not HasModelLoaded(maleHash) or not HasModelLoaded(femaleHash) do
        Wait(100)
        timer = timer + 100
        if timer > 1000 then
            print("Error: Models not preloaded after 5 seconds.")
            break
        end
    end
end
-- Preload models when the script starts
CreateThread(function()
    PreloadModels()
end)

RegisterNetEvent('infinity_chars:ApplySkinPed')
AddEventHandler('infinity_chars:ApplySkinPed', function(data, OutfitPlayer)
    -- Reload resources on the first call
    if firstCall then
        PreloadModels()
        RequestCollisionAtCoord(1415.02, -7321.0, 81.46 - 1)
        Wait(1000) -- Wait to ensure everything is ready
        firstCall = false
    end

    local modelHash
    local x, y, z = 1415.02, -7321.0, 81.46 - 1
    local timer = 0

    -- Check data
    if not data or not data.sex then
        print("Error: Missing or invalid data.")
        return
    end

    -- Detect model based on gender
    if tonumber(data.sex) == 1 then
        modelHash = GetHashKey("mp_male")
    elseif tonumber(data.sex) == 2 then
        modelHash = GetHashKey("mp_female")
    else
        print("Error: Invalid or undefined gender", data.sex)
        return
    end

    -- Load the model if not already loaded
    RequestModel(modelHash)
    RequestCollisionAtCoord(x, y, z)
    print("Collision requested.")

    -- Create the ped
    pedDemo = CreatePed(modelHash, x, y, z, 2.86, true, true)
    if not DoesEntityExist(pedDemo) then
        print("Error: Ped was not created.")
        return
    end

    -- Configure ped properties
    SetEntityAsMissionEntity(pedDemo, true, true)
    SetEntityInvincible(pedDemo, true)
    SetEntityCanBeDamagedByRelationshipGroup(pedDemo, false, GetHashKey("PLAYER"))
    Citizen.InvokeNative(0x283978A15512B2FE, pedDemo, false)

    -- Clear existing tasks and assign a new task
    ClearPedTasksImmediately(pedDemo)
    TaskGoToCoordAnyMeans(pedDemo, 1416.47, -7317.47, 81.23 - 1, 1.0, 0, 0, 786603, 0xbf800000)
    target = pedDemo

    if IsPedMale(target) then
        local face = list["heads"][tonumber(data.face)]
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(face), false, true, true)
    else
        local face = list_f["heads"][tonumber(data.face)]
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(face), false, true, true)
    end
    if IsPedMale(target) == 1 then
        local eyes = list["eyes"][tonumber(data.eyecolor)]
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(eyes), false, true, true)
    else
        local eyes = list_f["eyes"][tonumber(data.eyecolor)]
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(eyes), false, true, true)
    end

    -- Hair and beard
    if tonumber(data.hair) > 1 then
        if IsPedMale(target) then
            local hair =  list["hair"][tonumber(data.hair)]
            Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(hair), false, true, true)
        else
            local hair =  list_f["hair"][tonumber(data.hair)]
            Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(hair), false, true, true)
        end
    end
    if IsPedMale(target) then
       if tonumber(data.beard) > 1 then
        local beard = list["beard"][tonumber(data.beard)]
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,  tonumber(beard), false, true, true)
       end
   end
   -- Body Size
   if IsPedMale(target) == 1 then
        Citizen.InvokeNative(0x1902C4CFCC5BE57C, target, BODY_TYPES[tonumber(data.bodysize)])
    else
        Citizen.InvokeNative(0x1902C4CFCC5BE57C, target, BODY_TYPES[tonumber(data.bodysize)] )
    end
    -- Height Size 
    if data.height ~= nil then
        if IsPedMale(target) == 1 then
            SetPedScale(target, tonumber(data.height/100))
        else
            SetPedScale(target, tonumber(data.height/100))	
        end
    end
    -- Textures
    if IsPedMale(ped) then
        current_texture_settings = texture_types["male"]
    else
        current_texture_settings = texture_types["female"]
    end
    -- BODY TYPES
    if IsPedMale(target) then
        if tonumber(data.skincolor) == 1 then
            torso = list["BODIES_UPPER"][1]
            legs =  list["BODIES_LOWER"][1]
            texture_types["male"].albedo = GetHashKey("mp_head_mr1_sc08_c0_000_ab")
        elseif tonumber(data.skincolor) == 2 then
            torso = list["BODIES_UPPER"][10]
            legs = list["BODIES_LOWER"][10]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc03_c0_000_ab")
        elseif tonumber(data.skincolor) == 3 then
            torso = list["BODIES_UPPER"][3]
            legs = list["BODIES_LOWER"][3]
            texture_types["male"].albedo = GetHashKey("head_mr1_sc02_rough_c0_002_ab")
        elseif tonumber(data.skincolor) == 4 then
            torso = list["BODIES_UPPER"][11]
            legs = list["BODIES_LOWER"][11]
            texture_types["male"].albedo = GetHashKey("head_mr1_sc04_rough_c0_002_ab")
        elseif tonumber(data.skincolor) == 5 then
            torso = list["BODIES_UPPER"][8]
            legs = list["BODIES_LOWER"][8]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc01_c0_000_ab")
        elseif tonumber(data.skincolor) == 6 then
            torso = list["BODIES_UPPER"][30]
            legs = list["BODIES_LOWER"][30]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc05_c0_000_ab")
        end
    else
        if tonumber(data.skincolor) == 1 then
            torso = list_f["BODIES_UPPER"][1]
            legs = list_f["BODIES_LOWER"][1]
            texture_types["female"].albedo = GetHashKey("mp_head_fr1_sc08_c0_000_ab")
        elseif tonumber(data.skincolor) == 2 then
            torso = list_f["BODIES_UPPER"][10]
            legs = list_f["BODIES_LOWER"][10]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
        elseif tonumber(data.skincolor) == 3 then
            torso = list_f["BODIES_UPPER"][3]
            legs = list_f["BODIES_LOWER"][3]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
        elseif tonumber(data.skincolor) == 4 then
            torso = list_f["BODIES_UPPER"][11]
            legs = list_f["BODIES_LOWER"][11]
            texture_types["female"].albedo = GetHashKey("head_fr1_sc04_rough_c0_002_ab")
        elseif tonumber(data.skincolor) == 5 then
            torso = list_f["BODIES_UPPER"][8]
            legs = list_f["BODIES_LOWER"][8]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc01_c0_000_ab")
        elseif tonumber(data.skincolor) == 6 then
            torso = list_f["BODIES_UPPER"][30]
            legs = list_f["BODIES_LOWER"][30]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc05_c0_000_ab")
        end
    end

    Citizen.InvokeNative(0xD3A7B003ED343FD9 , target, tonumber(torso), false, true, true)
    Wait(10)
    Citizen.InvokeNative(0xD3A7B003ED343FD9 , target, tonumber(legs), false, true, true)
    Wait(10)
    if not update then
        Wait(100)
    end
    -- Finalize the ped

    Citizen.InvokeNative(0x704C908E9C405136, target)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, target, 0, 1, 1, 1, 0)

    if OutfitPlayer ~= nil then
        for i, key in ipairs(OutfitPlayer) do
            if key.loadouts then
                loadouts = key.loadouts
            end
            if key.hats then
                hats = key.hats
            end
            if key.cloaks then
                cloaks = key.cloaks
            end
            if key.shirts_full then
                shirts_full = key.shirts_full
            end
            if key.boot_accessories then
                boot_accessories = key.boot_accessories
            end
            if key.boots then
                boots = key.boots
            end
            if key.pants then
                pants = key.pants
            end
            if key.hats then
                hats = key.hats
            end
            if key.coats_closed then
                coats_closed = key.coats_closed
            end
            if key.badges then
                badges = key.badges
            end
            if key.skirts then
                skirts = key.skirts
            end
            if key.suspenders then
                suspenders = key.suspenders
            end
            if key.holsters_left then
                holsters_left = key.holsters_left
            end
            if key.belt_buckles then
                belt_buckles = key.belt_buckles
            end
            if key.belts then
                belts = key.belts
            end
            if key.gunbelts then
                gunbelts = key.gunbelts
            end
            if key.neckties then
                neckties = key.neckties
            end
            if key.coats then
                coats = key.coats
            end
            if key.ponchos then
                ponchos = key.ponchos
            end
            if key.satchels then
                satchels = key.satchels
            end
            if key.armor then
                armor = key.armor
            end
            if key.eyewear then
                eyewear = key.eyewear
            end
            if key.gloves then
                gloves = key.gloves
            end
            if key.gauntlets then
                gauntlets = key.gauntlets
            end
            if key.chaps then
                chaps = key.chaps
            end
            if key.vests then
                vests = key.vests
            end
            if key.masks then
                masks = key.masks
            end
            if key.spats then
                spats = key.spats
            end
            if key.neckwear then
                neckwear = key.neckwear
            end
            if key.accessories then
                accessories = key.accessories
            end
            if key.jewelry_bracelets then
                jewelry_bracelets = key.jewelry_bracelets
            end
        end
        Wait(355)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(loadouts), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(hats), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(cloaks), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(shirts_full), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(boot_accessories), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(boots), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(pants), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(coats_closed), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(badges), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(skirts), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(suspenders), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(holsters_left), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(belt_buckles), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(belts), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(gunbelts), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(neckties), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(coats), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(ponchos), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(satchels), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(armor), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(eyewear), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(gloves), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(gauntlets), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(chaps), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(vests), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(masks), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(spats), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(neckwear), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(accessories), false,true,true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, target, tonumber(jewelry_bracelets), false,true,true)
        Citizen.InvokeNative(0x704C908E9C405136, target)
        Citizen.InvokeNative(0xAAB86462966168CE, target, 1)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, target, 0, 1, 1, 1, 0)

        Wait(5000)
        TaskAchieveHeading(pedDemo, 267.74, 0)
        Wait(1500)
      
        if anim == "coffee" then 
            if tonumber(data.sex) == 2 then
                TaskStartScenarioInPlace(
                    target --[[ Ped ]], 
                    GetHashKey('WORLD_HUMAN_COFFEE_DRINK') --[[ Hash ]], 
                    -1 --[[ integer ]], 
                    true --[[ boolean ]], 
                    GetHashKey('WORLD_HUMAN_COFFEE_DRINK_FEMALE_C') --[[ Hash ]], 
                    -1.0 --[[ number ]], 
                    false --[[ boolean ]]
                )
            else
                TaskStartScenarioInPlace(
                    target --[[ Ped ]], 
                    GetHashKey('WORLD_HUMAN_COFFEE_DRINK') --[[ Hash ]], 
                    -1 --[[ integer ]], 
                    true --[[ boolean ]], 
                    GetHashKey('WORLD_HUMAN_COFFEE_DRINK_MALE_A') --[[ Hash ]], 
                    -1.0 --[[ number ]], 
                    false --[[ boolean ]]
                )
            end
        end
    end
end)

--- REBOOT SCRIPT --
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetEntityAsNoLongerNeeded(pedDemo)
        DeleteEntity(pedDemo)
        DeletePed(pedDemo)
    end
end)