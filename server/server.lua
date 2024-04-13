local Core = exports.vorp_core:GetCore()
---> Poções de transformação
for _, v in pairs(Config.Potions) do 
    exports.vorp_inventory:registerUsableItem(tostring(v.itemName), function(data)
    local _source = data.source
    local item = data.item
    local label = data.label
    local Character = Core.getUser(_source).getUsedCharacter 

    Core.NotifyLeftRank(_source, "VOZ INTERIOR","O que é isso?","pm_collectors_bag_mp ","collector_fossil_sea_lily",5000,"red")
    if Character.group ~= 'werewolf' then print("Not bruxinha/Lobisomem") return end --> If not witch then return else proceed
    
    exports.vorp_inventory:subItem(_source, tostring(v.itemName), 1, nil)
    TriggerClientEvent('byte:werewolf_form',_source,v.model,v.scale)
    Core.NotifyLeftRank(_source, "VOZ INTERIOR","O veu molda sua forma","pm_collectors_bag_mp ","collector_fossil_sea_lily",5000,"red")
        
     end)

end
