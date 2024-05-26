extends Node

var bid1 = 0
var score1 = 0
var bid2 = 0
var score2 = 0
var bid3 = 0
var score3 = 0
var bid4 = 0
var score4 = 0

var card_disabled = false

var can_select = false
var player_turn = 1

var player_active = ""

var player1_cards = {}
var player2_cards = {}
var player3_cards = {}
var player4_cards = {}

var player1_card_selected = ""
var player1_card_index = 0
var player2_card_selected = ""
var player2_card_index = 0
var player3_card_selected = ""
var player3_card_index = 0
var player4_card_selected = ""
var player4_card_index = 0

func _ready():
	pass
	
func calculate_score():
	var highest = 0
	var index = 0
	var selected_card_arr = {1:player1_card_selected.substr(0,-1),2:player2_card_selected.substr(0,-1),3:player3_card_selected.substr(0,-1),4:player4_card_selected.substr(0,-1)}
	for i in range(1,5):
		if highest < int(selected_card_arr[i]):
			highest = int(selected_card_arr[i]) 
			index  = i
	match  index:
		1:
			return Vector2(1,1)
		2:
			return Vector2(1,1)
		3: 
			return Vector2(1,1)
		4: 
			return Vector2(1,1)
	
