-- Get the formspec for the inventory based on the game
function inventory_admin.get_player_inventory_formspec(target_player_name, admin_name)
    if inventory_admin.utils.is_mineclone2() then
        -- MineClone2 formspec
        local formspec = {
            "formspec_version[4]",
            "size[11.75,13]",  -- Adjust the height to accommodate the spacing
    
            -- Title for the target player's inventory
            "label[0.375,0.375;", minetest.formspec_escape(target_player_name .. "'s Inventory"), "]",
    
            -- Slot backgrounds for the target player's main inventory excluding the hotbar
            mcl_formspec.get_itemslot_bg_v4(0.375, 1, 9, 3),
    
            -- Slot list for the target player's main inventory excluding the hotbar
            "list[detached:" .. target_player_name .. "_inventory;main;0.375,1;9,3;9]",
    
            -- Slot background for the target player's hotbar, placed at the bottom
            mcl_formspec.get_itemslot_bg_v4(0.375, 5, 9, 1),
    
            -- Slot list for the target player's hotbar
            "list[detached:" .. target_player_name .. "_inventory;main;0.375,5;9,1;0]",
    
            -- Title for the admin's inventory, moved further down to create space
            "label[0.375,6.5;Your Inventory]",
    
            -- Slot backgrounds for the admin player's main inventory excluding the hotbar
            mcl_formspec.get_itemslot_bg_v4(0.375, 7, 9, 3),
    
            -- Slot list for the admin player's main inventory excluding the hotbar
            "list[current_player;main;0.375,7;9,3;9]",
    
            -- Slot background for the admin player's hotbar, placed further down with spacing similar to the singleplayer's hotbar
            mcl_formspec.get_itemslot_bg_v4(0.375, 11, 9, 1),
    
            -- Slot list for the admin player's hotbar, with adjusted Y-coordinate for correct spacing
            "list[current_player;main;0.375,11;9,1;0]",
    
            -- Listrings to allow moving items between the target's and admin's inventories
            "listring[detached:" .. target_player_name .. "_inventory;main]",
            "listring[current_player;main]",
        }
    
        return table.concat(formspec)
    else
        -- minetest_game formspec
        local formspec = {
            "size[8,10]", -- Width and Height of the formspec
            "label[0.5,0.0;", minetest.formspec_escape(target_player_name .. "'s Inventory"), "]", -- Title label for the singleplayer's inventory
            
            -- Singleplayer's hotbar at the top, with index starting at 1
            "list[detached:" .. target_player_name .. "_inventory;main;0,0.5;8,1;0]",
            
            -- Empty row to visually separate the hotbar from the main inventory
            
            -- The singleplayer's main inventory
            "list[detached:" .. target_player_name .. "_inventory;main;0,2;8,3;9]", -- Starting index is 9 assuming the hotbar is 8 slots and the first row in the main inventory starts after the hotbar
            
            -- Title label for the admin's inventory
            "label[0.5,5;Your Inventory]", -- Adjust the Y position to 5
            
            -- The admin's main inventory
            "list[current_player;main;0,5.5;8,3;9]", -- Starting index is 9 to skip the admin's hotbar
            
            -- The admin's hotbar, visually separated
            "list[current_player;main;0,9;8,1;0]", -- Ensure all slots are included
            
            -- Listrings for item movement between the inventories
            "listring[detached:" .. target_player_name .. "_inventory;main]",
            "listring[current_player;main]",
        }
        
        return table.concat(formspec)
    end
end
