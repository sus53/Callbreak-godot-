extends Node2D

var card_names = ["clubs","diamond","spade","hearts"]
var random_index_card
var random_index_number
var card
var global = Game
var to_find_num
@onready var card_show = $card_show
@onready var menu_show = $"../../place_call_menu/Timer"
@onready var lbl_bid = $lbl_bid
@onready var collision_shape_2d = $CollisionShape2D

func card_suffle_backside():
	var tween_area = create_tween()
	var tween_sprite = create_tween()
	for i in range(1, 14): 
		card = get_node("./card_suffle/card" + str(i))
		card.get_child(0).texture = load("res://assets/card_backside.jpeg")
		tween_area.tween_property(card,"position",Vector2(-5700 + (i*800),4000 + 400),0.24)
		
		
func _ready():
	randomize()  
	card_show.start()
	match int(self.name.substr(11,12)):
		1:
			card_suffle_backside()
			lbl_bid.position.x -= 310 
			lbl_bid.position.y -= 200 
			lbl_bid.text = "Score/Bid : " + str(global.score1[global.round])+"/"+str(global.bid1[global.round])
		2:
			card_suffle_backside()
			lbl_bid.rotation =  deg_to_rad(90)
			lbl_bid.position.x -= 200
			lbl_bid.position.y -= 20
			lbl_bid.text = "Score/Bid : " + str(global.score2[global.round])+"/"+str(global.bid2[global.round])
		3:
			card_suffle_backside()
			lbl_bid.rotation =  deg_to_rad(180)
			lbl_bid.position.x -= 200 
			lbl_bid.position.y -= 150 
			lbl_bid.text = "Score/Bid : " + str(global.score3[global.round])+"/"+str(global.bid3[global.round])
		4:
			card_suffle_backside()
			lbl_bid.rotation =  deg_to_rad(270)
			lbl_bid.position.x -= 300 
			lbl_bid.position.y += 80 
			lbl_bid.text = "Score/Bid : " + str(global.score4[global.round])+"/"+str(global.bid4[global.round])

func _process(delta):
	match int(self.name.substr(11,12)):
		1:
			lbl_bid.text = "Score/Bid : " + str(global.score1[global.round])+"/"+str(global.bid1[global.round])
		2:
			lbl_bid.text = "Score/Bid : " + str(global.score2[global.round])+"/"+str(global.bid2[global.round])
		3:
			lbl_bid.text = "Score/Bid : " + str(global.score3[global.round])+"/"+str(global.bid3[global.round])
		4:
			lbl_bid.text = "Score/Bid : " + str(global.score4[global.round])+"/"+str(global.bid4[global.round])
			
func _on_timer_timeout():
	if int(self.name.substr(11,12)) == int(1): 
		global.player1_cards = suffle_card_and_add_cards(global.player1_cards)
		
	if int(self.name.substr(11,12)) == int(2): 
		global.player2_cards = suffle_card_and_add_cards(global.player2_cards)
		
	if int(self.name.substr(11,12)) == int(3): 
		global.player3_cards = suffle_card_and_add_cards(global.player3_cards)
		
	if int(self.name.substr(11,12)) == int(4): 
		global.player4_cards = suffle_card_and_add_cards(global.player4_cards)
		
	card_show.stop()
	menu_show.start()

func suffle_card_and_add_cards(player_card):
	var new_player_card = {}
	var card_names_index = [card_names[0].substr(0,1),card_names[1].substr(0,1),card_names[2].substr(0,1),card_names[3].substr(0,1)]
	for i in range(1, 14):
		random_index_card = randi() % card_names.size() 
		random_index_number = randi() % 13 + 2
		to_find_num = card_names[random_index_card] + str("%02d" % random_index_number)
		while find_duplicate(to_find_num):
			random_index_card = randi() % card_names.size() 
			random_index_number = randi() % 13 + 2
			to_find_num = card_names[random_index_card] + str("%02d" % random_index_number)
		player_card[i-1] = str(card_names[random_index_card] + str("%02d" % random_index_number))
	new_player_card = sort_cards(player_card)
	for  i in  range(1, 14):
		card = get_node("./card_suffle/card" + str(i))
		card.get_child(0).texture = load("res://assets/" + new_player_card[i-1].substr(0,new_player_card[i-1].length() - 2).to_lower() + "/PNG/" + str(new_player_card[i-1].substr(new_player_card[i-1].length() - 2,2)) + ".png")
	return new_player_card
		


func _on_mouse_entered():
	global.player_active = self.name.substr(11)

func find_duplicate(to_find_num):
	if to_find_num in get_all_player_cards():
		return true
	else:
		return false

func get_all_player_cards():
	var all_player_cards = [global.player1_cards, global.player2_cards, global.player3_cards, global.player4_cards]
	var new_arr = []
	for cards in all_player_cards:
		for card in cards.values():
			new_arr.append(card)
	return new_arr
	
func create_sort_key(card,cards):
	var suits_order = {"spade": 0, "hearts": 1, "clubs": 2, "diamond": 3}
	var suit = cards[card].substr(0,cards[card].length()-2).to_lower()
	var value = int(cards[card].substr(1, -1))
	return suits_order[suit] * 100 + value

func sort_cards(cards):
	var cards_with_keys = []
	for card in cards:
		cards_with_keys.append([create_sort_key(card,cards), cards[card]])
	
	cards_with_keys.sort()
	var sorted_cards = {}
	var i = 0
	for item in cards_with_keys:
		sorted_cards[i] = item[1]
		i += 1
	return sorted_cards
