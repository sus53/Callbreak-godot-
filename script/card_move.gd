extends Area2D

var global = Game
var card_names = ["clubs","diamond","spade","hearts"]
@onready var player_area = $"../.."
@onready var turn_over_timer = $"../turn_over"
@onready var render_time = $"../../render_time"

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
	
func _process(delta):
	match global.start_turn:
		1:
			global.start_turn_card = global.player1_card_selected
		2:
			global.start_turn_card = global.player2_card_selected
		3:
			global.start_turn_card = global.player3_card_selected
		4:
			global.start_turn_card = global.player4_card_selected
			
	match global.player_turn:
		2:
			
			global.player2_card_selected = check_cards_available_ai(global.start_turn_card,global.player2_cards)
			global.player_turn = global.player_turn + 1 if global.player_turn < 4 else 1
			move_card_ai(global.player2_card_selected,global.player2_cards)
		3:
			global.player3_card_selected = check_cards_available_ai(global.start_turn_card,global.player3_cards)
			global.player_turn = global.player_turn + 1 if global.player_turn < 4 else 1
			move_card_ai(global.player3_card_selected,global.player3_cards)
		4:
			global.player4_card_selected = check_cards_available_ai(global.start_turn_card,global.player4_cards)
			global.player_turn = global.player_turn + 1 if global.player_turn < 4 else 1
			move_card_ai(global.player4_card_selected,global.player4_cards)

func move_card_ai(card,player_cards):
	var card_move_tween = create_tween()
	var card_index = get_index_card(card,player_cards)
	var card_node = get_node("../card" + str(card_index))
	card_move_tween.tween_property(card_node, "position", Vector2(30,680), 0.25)

func get_index_card(card,player_cards):
	for i in range(1,14):
		if player_cards[i-1] == card:
			return i
			
func _on_input_event(viewport, event, shape_idx):
	if global.card_disabled:
		if int(global.player_turn) == int(global.player_active):
				if event is InputEventMouseButton:
					if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
						if global.can_select:
							var card_move_tween = create_tween()
							card_move_tween.tween_property(self, "position", Vector2(30,680), 0.25)
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
			return check_high_card_sub(player_cards)
		2:
			return check_high_card_sub(player_cards)
		3:
			return check_high_card_sub(player_cards)
		4:
			return check_high_card_sub(player_cards)

func check_high_card_sub(player_cards):
	match global.start_turn:
		1:
			return check_high_card_loop(global.player1_card_selected,player_cards)
		2:
			return check_high_card_loop(global.player2_card_selected,player_cards)
		3:
			return check_high_card_loop(global.player3_card_selected,player_cards)
		4:
			return check_high_card_loop(global.player4_card_selected,player_cards)
	
func check_high_card_loop(player_selected_card,player_cards):
	var player1_selected = 0 if global.player1_card_selected == "" else int(global.player1_card_selected.substr(1,-1))
	var player2_selected = 0 if global.player2_card_selected == "" else int(global.player2_card_selected.substr(1,-1))
	var player3_selected = 0 if global.player3_card_selected == "" else int(global.player3_card_selected.substr(1,-1))
	var player4_selected = 0 if global.player4_card_selected == "" else int(global.player4_card_selected.substr(1,-1))
	
	for i in player_cards.values():
		if i.substr(0,1) == player_selected_card.substr(0,1):
			if int(str(i).substr(1,-1)) > player1_selected && int(str(i).substr(1,-1)) > player2_selected && int(str(i).substr(1,-1)) > player3_selected && int(str(i).substr(1,-1)) > player4_selected:
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
	var player1_selected = 0 if global.player1_card_selected == "" else global.player1_card_selected
	var player2_selected = 0 if global.player2_card_selected == "" else global.player2_card_selected
	var player3_selected = 0 if global.player3_card_selected == "" else global.player3_card_selected
	var player4_selected = 0 if global.player4_card_selected == "" else global.player4_card_selected
	var player_selected_cards = [player1_selected,player2_selected,player3_selected,player4_selected]
	var isHigh = false
	if player_selected_card == "":
		self.scale = Vector2(1.1,1.1)
		return true
	elif player_selected_card.substr(0,1) == player_cards[int(self.name.substr(4,5)) - 1].substr(0,1):
		if check_high_card(player_cards):
			for i in player_selected_cards:
				if typeof(i) == TYPE_STRING:
					if player_cards[int(self.name.substr(4,5)) - 1].substr(0,1) == i.substr(0,1):
						if int(i.substr(1,-1)) < int( player_cards[int(self.name.substr(4,5)) - 1].substr(1,-1)):
							isHigh = true
							break
						else:
							isHigh = false 
					else:
						isHigh = false
			if isHigh:
				self.scale = Vector2(1.1,1.1)
				return true
			else:     
				global.can_select = false
		else:
			self.scale = Vector2(1.1,1.1)
			return true
	else:
		global.can_select = false

func select_card(player_cards):
	player_cards.erase(int(self.name.substr(4)) - 1)
	
func reset_turn():
	if global.reset_turn == 4:
		global.reset_turn = 0
		turn_over_timer.start()
	
	if global.player1_cards.size() == 0 && global.player2_cards.size() == 0 && global.player3_cards.size() == 0 && global.player4_cards.size() == 0:
		global.round += 1
		render_time.start()
		
func turn_over(position):
	var tween1 = create_tween()
	var tween2 = create_tween()
	var tween3 = create_tween()
	var tween4 = create_tween()
	tween1.tween_property(global.player1_card_node, "position", position, 1)
	tween2.tween_property(global.player2_card_node, "position", position.rotated(PI/2), 1)
	tween3.tween_property(global.player3_card_node, "position", position.rotated(-PI), 1)
	tween4.tween_property(global.player4_card_node, "position", position.rotated(PI*3/2), 1)

func _on_turn_over_timeout():
	turn_over(global.calculate_score())        

func _on_render_time_timeout():
	get_tree().reload_current_scene()
	
func check_cards_available_ai(start_card,player_cards):
	randomize()
	var random_index_card = randi() % card_names.size() 
	var random_index_number = randi() % 13 + 2
	var random_card = card_names[random_index_card] + str("%02d" % random_index_number)
	if global.player_turn == global.start_turn:
		return random_card
		
	var highest = ""
	var lowest = ""
	var spade = ""
	for i in player_cards.values():
		if i.substr(0,1) ==  start_card.substr(0,1):
			highest = i if i.substr(i.length() - 2, 2) > start_card.substr(i.length() - 2,2) else highest
			lowest = i if i.substr(i.length() - 2, 2) < start_card.substr(i.length() - 2,2) else lowest
			
		spade = i if i.substr(i.length() - 2, 2) == "s" else spade
	
	if highest != "":
		return highest
	elif lowest != "":
		return lowest
	elif spade != "":
		return spade
	else:
		return random_card
		


func _on_ai_move_timeout():
	pass # Replace with function body.
