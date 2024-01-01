function inventory_admin.get_player_inventory_formspec(admin_name, target_player_name)
    -- Make sure that a detached inventory for the target player exists
    inventory_admin.setup_detached_inventory(target_player_name)

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
end
