local Core = exports.vorp_core:GetCore()
local inForm = false


function HealPlayer() -- heals player 
    SetEntityMaxHealth(PlayerPedId(), 600)
    SetEntityHealth(PlayerPedId(), 600)
end

RegisterNetEvent('byte:werewolf_form')
AddEventHandler('byte:werewolf_form', function(model, scale,outfit)
    local SelectedModel = model

    SetMonModel(model)
    inForm = true
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4,PlayerPedId(),outfit,0)
    Citizen.CreateThread(function()
        SpawnFX()
        while inForm do
            local ped = PlayerPedId()
    
            Citizen.Wait(0)
           SetPedScale(PlayerPedId(), scale)
            if IsPedDeadOrDying(PlayerPedId()) then
            HealPlayer()
            ExecuteCommand('rc')
            SpawnFX()
            break
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local playerModel = GetEntityModel(PlayerPedId())
            if (playerModel == GetHashKey('mp_male') or playerModel == GetHashKey('mp_female') or playerModel ~= GetHashKey(model)) and inForm then
                inForm = false
                print("ISNT RIGHT")
                break
            end
        end
    end)


end)



Citizen.CreateThread(function() -- Activates Passive effects on werewolf // Super Strength, Night Vision,
    local Notified = false
    local NotifiedOff = true
   
    while true do 
        Citizen.Wait(1000)
        if LocalPlayer.state.IsInSession then
               while true do
                   Citizen.Wait(1000)
                   local Group = LocalPlayer.state.Character.Group
                   local Player = PlayerId()
                   local Hours = GetClockHours()
                   if Group == Config.GroupName then
                       if Hours >= 20 or Hours < 6 then                                                      -- enables vision at night
                           Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, PlayerId(), true)                        -- Eagle Eye: True
                           Citizen.InvokeNative(0x7146CF430965927C, 'PERSONA_CONT_EAGLEEYE_ON_SPRINT', true) -- Eagle Eye Run
                           Citizen.InvokeNative(0xE4CB5A3F18170381, PlayerId(), 2000.0)                      -- SetPlayerMeleeWeaponDamageModifier
   
                           if not Notified then                                                              -- Verifies werewolf on notification
                               Core.NotifyLeftRank(Config.NotificationTitle, Config.NightMessage,
                                   "inventory_items_mp",
                                   "mp_animal_wolf_legendary_02", 4000, "COLOR_YELLOW")
                               Notified = true
                               NotifiedOff = false
                           end
                       elseif Hours >= 6 then
                           Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, PlayerId(), false) -- Eagle Eye: False
                           Citizen.InvokeNative(0xE4CB5A3F18170381, PlayerId(), 1.0)   -- SetPlayerMeleeWeaponDamageModifier
                           Notified = false
   
                           if not NotifiedOff then
                               Core.NotifyLeftRank(Config.NotificationTitle, Config.DayMessage,
                                   "inventory_items_mp",
                                   "mp_animal_wolf_legendary_02", 4000, "COLOR_PURE_WHITE")
                               NotifiedOff = true
                           end

                       end

                   end
               end
        end

    end
end)

function SpawnFX(dict, name)
    local Player = PlayerId()
    local new_ptfx_dictionary = dict or "scr_net_target_races"
    local new_ptfx_name = name or "scr_net_target_fire_ring_burst_mp"
    local is_particle_effect_active = false
    local current_ptfx_dictionary = new_ptfx_dictionary
    local current_ptfx_name = new_ptfx_name
    local current_ptfx_handle_id = false
    local ptfx_offcet_x = 0.0
    local ptfx_offcet_y = 0.0
    local ptfx_offcet_z = 0.0
    local ptfx_rot_x = -90.0
    local ptfx_rot_y = 0.0
    local ptfx_rot_z = 0.0
    local ptfx_scale = 1.0
    local ptfx_axis_x = 0
    local ptfx_axis_y = 0
    local ptfx_axis_z = 0


    if not is_particle_effect_active then
        current_ptfx_dictionary = new_ptfx_dictionary
        current_ptfx_name = new_ptfx_name
        if not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then                         -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xF2B2353BBC0D4E8F, GetHashKey(current_ptfx_dictionary))                                 -- RequestNamedPtfxAsset
            local counter = 0
            while not Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) and counter <= 300 do -- while not HasNamedPtfxAssetLoaded
                Citizen.Wait(0)
            end
        end
        if Citizen.InvokeNative(0x65BB72F29138F5D6, GetHashKey(current_ptfx_dictionary)) then -- HasNamedPtfxAssetLoaded
            Citizen.InvokeNative(0xA10DB07FC234DD12, current_ptfx_dictionary)                 -- UseParticleFxAsset


            current_ptfx_handle_id = Citizen.InvokeNative(0xE6CFE43937061143, current_ptfx_name,
                PlayerPedId(), ptfx_offcet_x, ptfx_offcet_y, ptfx_offcet_z, ptfx_rot_x, ptfx_rot_y,
                ptfx_rot_z, ptfx_scale, ptfx_axis_x, ptfx_axis_y, ptfx_axis_z) -- StartNetworkedParticleFxNonLoopedOnEntity
            is_particle_effect_active = true
        else
            print("cant load ptfx dictionary!")
        end
    else
        if current_ptfx_handle_id then
            if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then    -- DoesParticleFxLoopedExist
                Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false) -- RemoveParticleFx
            end
        end
        current_ptfx_handle_id = false
        is_particle_effect_active = false

        Wait(2000)
    end
end

function SetMonModel(name)
    local model = joaat(name)
    local player = PlayerId()



    if not IsModelValid(model) then return end
    PerformRequest(model)

    if HasModelLoaded(model) then
        Citizen.InvokeNative(0xED40380076A31506, player, model, false) -- SetPlayerModel
        Citizen.InvokeNative(0x283978A15512B2FE, PlayerPedId(), false)  -- SetRandomOutfitVariation
        SetModelAsNoLongerNeeded(model)



        HealPlayer()
    end
end

function PerformRequest(modelHash)
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end
end

function TaskAnim(animDict, animName, flags, duration)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end

    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 3.0, duration, flags, 0, 0, 0, 0)
    RemoveAnimDict(animDict)
end
