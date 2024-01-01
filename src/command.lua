-- In your mod's global scope, register the detached inventories table
inventory_admin.detached_inventories = {}

-- command.lua
function inventory_admin.command_inventory(name, param)
    local player = minetest.get_player_by_name(name)
    if not player then
        return false, "You need to be online to use this command."
    end

    local target_player_name = param:trim()
    if target_player_name == "" then
        return false, "Please specify a player name."
    end

    local target_player = minetest.get_player_by_name(target_player_name)
    if not target_player then
        return false, "Target player not found."
    end

    -- Set up the detached inventory and sync the player's current inventory to it
    inventory_admin.setup_detached_inventory(target_player_name)
    inventory_admin.sync_player_to_detached_inventory(target_player_name)  -- Sync the player inventory to the detached inventory

    -- Show the formspec to the player who issued the command
    minetest.show_formspec(name, "inventory_admin:player_inventory", 
        inventory_admin.get_player_inventory_formspec(name, target_player_name))

    return true, "Showing inventory of " .. target_player_name
end

