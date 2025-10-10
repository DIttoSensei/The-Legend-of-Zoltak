extends Node

signal show_item_info_board
signal show_selected_item_board
signal show_action_info
signal shop_exit
signal add_item_to_inventory

# for item shop
signal notification_purchase
signal notification_cant_purchase
signal player_inv_full

# for action shop
signal action_purchase
signal action_not_purchased
signal add_action_to_slot

# for battle
signal enemy_attack_data (enemy_name: String, move_name : String, damage : int, anim_name : String)
signal player_attack_data
signal player_damaged (damage : int)
signal enemy_damaged (damage : int)
signal player_attack (action_data)
signal battle_won 
