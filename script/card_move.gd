extends Area2D

var global = Game
@onready var lbl_bid = $"../../lbl_bid"

func _on_mouse_entered():
	
	if global.card_disabled:
		if int(global.player_turn) == int(global.player_active):
			match global.player_turn:
				1:
					global.can_select = true
					self.scale = Vector2(1.1,1.1)
				2:
					if check_card(global.player1_card_selected,global.player2_cards):
						global.can_select = true
				3:
					if check_card(global.player2_card_selected,global.player3_cards):
						global.can_select = true
				4:
					if check_card(global.player3_card_selected,global.player4_cards):
						global.can_select = true

func check_card(prev_player_card_selected,current_hover_card):
	if prev_player_card_selected == "":
		self.scale = Vector2(1.1,1.1)
		return true
	elif prev_player_card_selected.substr(0,1) == current_hover_card[int(self.name.substr(4)) - 1].substr(0,1):
		self.scale = Vector2(1.1,1.1)
		return true
	else:
		global.can_select = false				
		

func _on_mouse_exited():
	self.scale = Vector2(1.0, 1.0)

func _on_input_event(viewport, event, shape_idx):
	if global.card_disabled:
		if int(global.player_turn) == int(global.player_active):
				if event is InputEventMouseButton:
					if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
						if global.can_select:
							self.position = Vector2(-350,600)
							print(int(self.name.substr(4)) - 1)
							global.player_turn = global.player_turn + 1 if global.player_turn < 4 else 1
							match int(global.player_active):
								1:
									global.player1_card_selected = global.player1_cards[int(self.name.substr(4)) - 1]
									global.player1_card_index = int(self.name.substr(4)) - 1
									select_card(global.player1_cards)		
								2:
									global.player2_card_selected = global.player2_cards[int(self.name.substr(4)) - 1]
									global.player2_card_index = int(self.name.substr(4)) - 1
									select_card(global.player2_cards)
								3: 
									global.player3_card_selected = global.player3_cards[int(self.name.substr(4)) - 1]
									global.player3_card_index = int(self.name.substr(4)) - 1
									select_card(global.player3_cards)
								4: 
									global.player4_card_selected = global.player4_cards[int(self.name.substr(4)) - 1]
									global.player4_card_index = int(self.name.substr(4)) - 1
									select_card(global.player4_cards)
									var new_position = global.calculate_score()
									
func select_card(player_cards):
	player_cards.erase(int(self.name.substr(4)) - 1)

	
