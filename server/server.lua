local Core = exports.vorp_core:GetCore()


for _, v in pairs(Config.Potions) do 
    exports.vorp_inventory:registerUsableItem(tostring(v.itemName), function(data)
    local _source = data.source
    local item = data.item
    local label = data.label
    local Character = Core.getUser(_source).getUsedCharacter 

    if Character.group ~= Config.GroupName then  return end --> If not witch then return else proceed

    exports.vorp_inventory:subItem(_source, tostring(v.itemName), 1, nil)
    TriggerClientEvent('byte:werewolf_form',_source,v.model,v.scale)
        
     end)

end
