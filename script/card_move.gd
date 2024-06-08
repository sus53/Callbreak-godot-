extends Area2D

var global = Game
var card_names = ["clubs", "diamond", "spade", "hearts"]
@onready var player_area = $"../.."
@onready var turn_over_timer = $"../turn_over"
@onready var render_time = $"../../render_time"
@onready var ai_move = $"../../ai_move"
@onready var player_move = $"../../player_move"

func _ready():
	randomize()
	

func _on_mouse_entered():
	if global.card_disabled:
		if int(global.player_turn) == int(global.player_active):
			match global.player_turn:
				1:
					check_cards_logic(global.player1_cards)

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
			if player_area.name == "player_area2" && global.can_select_ai:
				ai_move_func()
		3:
			if player_area.name == "player_area3" && global.can_select_ai:
				ai_move_func()
		4:
			if player_area.name == "player_area4"  && global.can_select_ai:
				ai_move_func()
				

func _on_input_event(viewport, event, shape_idx):
	if global.card_disabled:
		if int(global.player_turn) == int(global.player_active):
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
					if global.can_select && global.can_player_move:
						var card_move_tween = create_tween()
						print("start_card = " + global.start_turn_card)
						print("reset_turn = " + str(global.reset_turn))
						card_move_tween.tween_property(self, "position", Vector2(30, 680), 0.25)
						global.player1_card_selected = global.player1_cards[int(self.name.substr(4)) - 1]
						print("selected_card =  " + str(global.player1_card_selected))
						global.player1_card_node = self
						print(global.player1_cards.values())
						global.player1_cards.erase(int(self.name.substr(4)) - 1)
						print(global.player1_cards.values())
						global.player_turn = global.player_turn + 1 if global.player_turn < 4 else 1
						global.reset_turn += 1
						global.can_select_ai = false
						global.can_player_move = false
						print("---------------------------" + str(global.can_player_move))
						reset_turn()

func check_cards_logic(player_cards):
	if global.player_turn == global.start_turn:
		self.scale = Vector2(1.1, 1.1)
		global.can_select = true
	elif check_cards_available(player_cards):
		if check_hover_card(player_cards):
			self.scale = Vector2(1.1, 1.1)
			global.can_select = true
	elif check_spade(player_cards):
		if check_hover_spade(player_cards):
			global.can_select = true
	else:
		self.scale = Vector2(1.1, 1.1)
		global.can_select = true

func check_cards_available(player_cards):
	return check_cards_available_part(player_cards)
	
func check_cards_available_part(player_cards):
	#print(player_cards)
	for i in player_cards.values():
		if str(i).substr(0, 1) == global.start_turn_card.substr(0, 1):
			#print(i)
			#print(global.start_turn_card)
			return true
	return false

func check_high_card(player_cards):
	return check_high_card_sub(player_cards)

func check_high_card_sub(player_cards):
	return check_high_card_loop(global.start_turn_card, player_cards)

func check_high_card_loop(player_selected_card, player_cards):
	var player1_selected = 0 if global.player1_card_selected == "" else int(global.player1_card_selected.substr(1, -1))
	var player2_selected = 0 if global.player2_card_selected == "" else int(global.player2_card_selected.substr(1, -1))
	var player3_selected = 0 if global.player3_card_selected == "" else int(global.player3_card_selected.substr(1, -1))
	var player4_selected = 0 if global.player4_card_selected == "" else int(global.player4_card_selected.substr(1, -1))
	
	for i in player_cards.values():
		if i.substr(0, 1) == player_selected_card.substr(0, 1):
			if int(i.substr(1, -1)) > player1_selected and int(i.substr(1, -1)) > player2_selected and int(i.substr(1, -1)) > player3_selected and int(i.substr(1, -1)) > player4_selected:
				return true
	return false

func check_spade(player_cards):
	for i in player_cards.values():        
		if str(i).substr(0, 1) == "s":
			return true
	return false

func check_hover_spade(player_cards):
	if "s" == player_cards[int(self.name.substr(4)) - 1].substr(0, 1):
		self.scale = Vector2(1.1, 1.1)
		return true
	else:
		global.can_select = false

func check_hover_card(player_cards):
	match global.start_turn:
		1:
			return check_hover_card_sub(global.player1_card_selected, player_cards)
		2:
			return check_hover_card_sub(global.player2_card_selected, player_cards)
		3:
			return check_hover_card_sub(global.player3_card_selected, player_cards)
		4:
			return check_hover_card_sub(global.player4_card_selected, player_cards)

func check_hover_card_sub(player_selected_card, player_cards):
	var player1_selected = 0 if global.player1_card_selected == "" else global.player1_card_selected
	var player2_selected = 0 if global.player2_card_selected == "" else global.player2_card_selected
	var player3_selected = 0 if global.player3_card_selected == "" else global.player3_card_selected
	var player4_selected = 0 if global.player4_card_selected == "" else global.player4_card_selected
	var player_selected_cards = [player1_selected, player2_selected, player3_selected, player4_selected]
	var isHigh = false
	if player_selected_card == "":
		self.scale = Vector2(1.1, 1.1)
		return true
	elif player_selected_card.substr(0, 1) == player_cards[int(self.name.substr(4)) - 1].substr(0, 1):
		if check_high_card(player_cards):
			for i in player_selected_cards:
				if typeof(i) == TYPE_STRING:
					if player_cards[int(self.name.substr(4)) - 1].substr(0, 1) == i.substr(0, 1):
						if int(i.substr(1, -1)) < int(player_cards[int(self.name.substr(4)) - 1].substr(1, -1)):
							isHigh = true
							break
						else:
							isHigh = false 
					else:
						isHigh = false
			if isHigh:
				self.scale = Vector2(1.1, 1.1)
				return true
			else:     
				global.can_select = false
		else:
			self.scale = Vector2(1.1, 1.1)
			return true
	else:
		global.can_select = false

func reset_turn():
	print("Reset_turn = " + str(global.reset_turn))
	if global.player1_cards.size() == 0 and global.player2_cards.size() == 0 and global.player3_cards.size() == 0 and global.player4_cards.size() == 0:
		global.round += 1
		global.reset_turn = 0
		render_time.start(1)
		ai_move.start(5)
		global.start_turn = 0
		return 
	if global.reset_turn == 4:
		global.reset_turn = 0
		turn_over_timer.start()
		ai_move.start(2.2)
	else:
		ai_move.start(1.2)
	
		
	

func turn_over(position):
	var tween1 = create_tween()
	var tween2 = create_tween()
	var tween3 = create_tween()
	var tween4 = create_tween()
	print("////////////////////////////////")
	print(global.player1_card_node.name)
	print(global.player2_card_node.name)
	print(global.player3_card_node.name)
	print(global.player4_card_node.name)
	tween1.tween_property(global.player1_card_node, "position", position, 1)
	tween2.tween_property(global.player2_card_node, "position", position.rotated(PI / 2), 1)
	tween3.tween_property(global.player3_card_node, "position", position.rotated(-PI), 1)
	tween4.tween_property(global.player4_card_node, "position", position.rotated(PI * 3 / 2), 1)
	player_move.start(2.0)

func _on_turn_over_timeout():
	turn_over(global.calculate_score())

func _on_render_time_timeout():
	get_tree().reload_current_scene()

func check_cards_available_ai(player_cards):
	print("start_card = " + global.start_turn_card)
	print("reset_turn = " + str(global.reset_turn))
	var start_card = global.start_turn_card
	var player_card_list = player_cards.values()
	if player_card_list.size() == 0:
		return
	var random_index_number = randi() % player_card_list.size()
	var random_card = player_card_list[random_index_number - 1]
	if global.player_turn == global.start_turn:
		print("random = " + random_card)
		return random_card
		
	var highest = ""
	var lowest = ""
	var spade = ""
	for i in player_cards.values():
		if i.substr(0, 1) == start_card.substr(0, 1):
			highest = i if i.substr(i.length() - 2, 2) > start_card.substr(i.length() - 2, 2) else highest
			lowest = i if i.substr(i.length() - 2, 2) < start_card.substr(i.length() - 2, 2) else lowest
			
		spade = i if i.substr(0, 1) == "s" else spade
	if highest != "":
		print("higest = " + highest)
		return highest
	elif lowest != "":
		print("lowest = " + lowest)
		return lowest
	elif spade != "":
		print("spade = " + spade)
		return spade
	else:
		print("random = " + random_card)
		return random_card

func ai_move_func():
			
			var player_cards 
			var selected_card_index
			
			if global.player_turn == 2:
				player_cards = global.player2_cards
			elif global.player_turn == 3:
				player_cards = global.player3_cards
			elif global.player_turn == 4:
				player_cards = global.player4_cards
			else:
				{}
			print(str(global.player_turn))
			var selected_card = check_cards_available_ai(player_cards)
			
			#check index properly ------------------------------------------------------
			for i in player_cards:
				if player_cards[i] == selected_card:
					selected_card_index = i + 1

			print("player_card_index = " + str(selected_card_index))
			var selected_card_node = get_node("../card" + str(selected_card_index))
			print("Selected_card_node = " + selected_card_node.name)
			var card_move_tween = create_tween()
			card_move_tween.tween_property(selected_card_node, "position", Vector2(30, 680), 0.25)
			match global.player_turn:
				2:
					global.player2_card_selected = selected_card
					global.player2_card_node = selected_card_node
					print(global.player2_cards.values())
					global.player2_cards.erase(selected_card_index - 1)
					print(global.player2_cards.values())
					print("--------------------------------")
					
				3:
					global.player3_card_selected = selected_card
					global.player3_card_node = selected_card_node
					print(global.player3_cards.values())
					global.player3_cards.erase(selected_card_index - 1)
					print(global.player3_cards.values())
					print("--------------------------------")
				4:
					global.player4_card_selected = selected_card
					global.player4_card_node = selected_card_node
					print(global.player4_cards.values())
					global.player4_cards.erase(selected_card_index - 1)
					player_move.start(3)
					print(global.player4_cards.values())
					print("--------------------------------")

			global.player_turn = global.player_turn + 1 if global.player_turn < 4 else 1
			global.reset_turn += 1
			global.can_select_ai = false
			reset_turn()



func _on_ai_move_timeout():
	global.can_select_ai = true


func _on_player_move_timeout():
	print("------------------6666666666666666666" + str(global.can_player_move))
	global.can_player_move = true
	print("----------------66666666666666666666-" + str(global.can_player_move))
