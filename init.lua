local modpath = minetest.get_modpath("inventory_admin")
local srcpath = modpath .. "/src/"
inventory_admin = {}

dofile(srcpath .. "formspecs.lua")
dofile(srcpath .. "sync.lua")
dofile(srcpath .. "command.lua")

-- Register the invmanage priv
minetest.register_privilege("invmanage", {
    description = "Allows viewing and manageing of the inventory of other players",
    give_to_singleplayer = false,
})

-- Register the /inventory command
minetest.register_chatcommand("invmanage", {
    params = "<playername>",
    description = "View the inventory of another player",
    privs = {invmanage = true},
    func = inventory_admin.command_inventory,
})

-- On join player setup detached inventory
minetest.register_on_joinplayer(function(player)
    inventory_admin.setup_detached_inventory(player:get_player_name())
end)

-- Override the player inventory callbacks
for item_name, def in pairs(minetest.registered_items) do
    -- Store the original functions if they are defined
    local original_on_metadata_inventory_move = def.on_metadata_inventory_move
    local original_on_metadata_inventory_put = def.on_metadata_inventory_put
    local original_on_metadata_inventory_take = def.on_metadata_inventory_take
    
    -- Override the functions
    minetest.override_item(item_name, {
        on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
            local result = nil
            minetest.log("action", "on_metadata_inventory_move: " .. item_name)
            -- Call the original function if it exists
            if original_on_metadata_inventory_move then
                result = original_on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
            end
            -- Sync the inventory after the move action
            inventory_admin.sync_player_to_detached_inventory(player:get_player_name())
            return result
        end,
        on_metadata_inventory_put = function(pos, listname, index, stack, player)
            local result = nil
            minetest.log("action", "on_metadata_inventory_put: " .. item_name)
            -- Call the original function if it exists
            if original_on_metadata_inventory_put then
                result = original_on_metadata_inventory_put(pos, listname, index, stack, player)
            end
            -- Sync the inventory after the put action
            inventory_admin.sync_player_to_detached_inventory(player:get_player_name())
            return result
        end,
        on_metadata_inventory_take = function(pos, listname, index, stack, player)
            local result = nil
            minetest.log("action", "on_metadata_inventory_take: " .. item_name)
            -- Call the original function if it exists
            if original_on_metadata_inventory_take then
                result = original_on_metadata_inventory_take(pos, listname, index, stack, player)
            end
            -- Sync the inventory after the take action
            inventory_admin.sync_player_to_detached_inventory(player:get_player_name())
            return result
        end,
    })
end