extends Node

# Card related Events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested
signal draw_card

# Player related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

# Enemy related events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died(enemy: Enemy)

# Battle related events
signal battle_over_screen_requested(text1: String, text2: String, type: BattleOverPanel.Type)
signal battle_won
signal status_tooltip_requested(stati: Array[Status])

# Relic related events
signal relic_tooltip_requested(relic: Relic)

# Map related events
signal map_exited(room: Room)

# Shop related events
signal shop_entered(shop: Shop)
signal shop_relic_bought(relic: Relic, gold_cost: int)
signal shop_card_bought(card: Card, gold_cost: int)
signal shop_exited

# Campfire related events
signal campfire_exited

# Battle reward related events
signal battle_reward_exited

# Tresure room related events
signal treasure_room_exited(relic: Relic)
