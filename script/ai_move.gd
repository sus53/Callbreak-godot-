extends Node

var global = Game
var card_names = ["clubs","diamond","spade","hearts"]

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
						
func move_card_ai(card,player_cards):
	var card_move_tween = create_tween()
	var card_index = get_index_card(card,player_cards)
	var card_node = get_node("../card" + str(card_index))
	card_move_tween.tween_property(card_node, "position", Vector2(30,680), 0.25)

func get_index_card(card,player_cards):
	for i in range(1,14):
		if player_cards[i-1] == card:
			return i
