extends Area2D

var global = Game
@onready var player_area = $"../.."

func _on_mouse_entered():
	if global.card_disabled:
		if int(global.player_turn) == int(global.player_active):
			match global.player_turn:
				1:
					check_cards_logic(global.player1_cards)
				2:
					check_cards_logic(global.player2_cards)
				3:
					check_cards_logic(global.player3_cards)
				4:
					check_cards_logic(global.player4_cards)

func _on_mouse_exited():
	self.scale = Vector2(1.0, 1.0)

func _on_input_event(viewport, event, shape_idx):
	if global.card_disabled:
		if int(global.player_turn) == int(global.player_active):
				if event is InputEventMouseButton:
					if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
						if global.can_select:
							var card_move_tween = create_tween()
							card_move_tween.tween_property(self, "position", Vector2(-350,600), 0.1)
							global.player_turn = global.player_turn + 1 if global.player_turn < 4 else 1
							global.reset_turn += 1
							match int(global.player_active):
								1:
									global.player1_card_selected = global.player1_cards[int(self.name.substr(4)) - 1]
									global.player1_card_node = self
									select_card(global.player1_cards)
									reset_turn()
								2:
									global.player2_card_selected = global.player2_cards[int(self.name.substr(4)) - 1]
									global.player2_card_node = self
									select_card(global.player2_cards)
									reset_turn()
								3: 
									global.player3_card_selected = global.player3_cards[int(self.name.substr(4)) - 1]
									global.player3_card_node = self
									select_card(global.player3_cards)
									reset_turn()
								4: 
									global.player4_card_selected = global.player4_cards[int(self.name.substr(4)) - 1]
									global.player4_card_node = self
									select_card(global.player4_cards)
									reset_turn()

func check_cards_logic(player_cards):
	if global.player_turn == global.start_turn:
		self.scale = Vector2(1.1,1.1)
		global.can_select = true
	elif check_cards_available(player_cards):
		if check_hover_card(player_cards):
			self.scale = Vector2(1.1,1.1)
			global.can_select = true
	elif check_spade(player_cards):
		if check_hover_spade(player_cards):
			global.can_select = true
	else:
		self.scale = Vector2(1.1,1.1)
		global.can_select = true 

func check_cards_available(player_cards):
	match global.start_turn:
		1:
			return check_cards_available_part(global.player1_card_selected,player_cards)
		2:
			return check_cards_available_part(global.player2_card_selected,player_cards)
		3:
			return check_cards_available_part(global.player3_card_selected,player_cards)
		4:
			return check_cards_available_part(global.player4_card_selected,player_cards)
			
func check_cards_available_part(player_card_selected,player_cards):
	for i in player_cards.values():
		if str(i).substr(0,1) == player_card_selected.substr(0,1):
			return true
	return false

func check_high_card(player_cards):
	match global.player_turn:
		1:
			for i in player_cards.values():
				if str(i).substr(0,1) > global.player4_card_selected:
					return true
			return false
		2:
			for i in player_cards.values():
				if str(i).substr(0,1) > global.player4_card_selected:
					return true
			return false
		3:
			for i in player_cards.values():
				if str(i).substr(0,1) > global.player4_card_selected:
					return true
			return false
		4:
			for i in player_cards.values():
				if str(i).substr(0,1) > global.player4_card_selected:
					return true
			return false

func check_high_card_sub(player_card_selected,player_cards):
	for i in player_cards.values():
		if str(i).substr(0,1) > player_card_selected:
			return true
	return false

func check_spade(player_cards):
	for i in player_cards.values():
		if str(i).substr(0,1) == "s":
			return true
			break
	return false
	
func check_hover_spade(player_cards):
	if "s" == player_cards[int(self.name.substr(4)) - 1].substr(0,1):
		self.scale = Vector2(1.1,1.1)
		return true
	else:
		global.can_select = false

func check_hover_card(player_cards):
	match global.start_turn:
		1:
			return check_hover_card_sub(global.player1_card_selected,player_cards)
		2:
			return check_hover_card_sub(global.player2_card_selected,player_cards)
		3:
			return check_hover_card_sub(global.player3_card_selected,player_cards)
		4:
			return check_hover_card_sub(global.player4_card_selected,player_cards)
						
func check_hover_card_sub(player_selected_card,player_cards):
	if player_selected_card == "":
		self.scale = Vector2(1.1,1.1)
		return true
	elif player_selected_card.substr(0,1) == player_cards[int(self.name.substr(4)) - 1].substr(0,1):
		self.scale = Vector2(1.1,1.1)
		return true
	else:
		global.can_select = false

func select_card(player_cards):
	player_cards.erase(int(self.name.substr(4)) - 1)
	
func reset_turn():
	if global.reset_turn == 4:
		round_over(global.calculate_score())		
		global.reset_turn = 0
		
func round_over(position):
	var tween1 = create_tween()
	var tween2 = create_tween()
	var tween3 = create_tween()
	var tween4 = create_tween()
	tween1.tween_property(global.player1_card_node, "position", position, 0.5)
	tween2.tween_property(global.player2_card_node, "position", position.rotated(PI/2), 0.5)
	tween3.tween_property(global.player3_card_node, "position", position.rotated(-PI), 0.5)
	tween4.tween_property(global.player4_card_node, "position", position.rotated(PI*3/2), 0.5)

	
