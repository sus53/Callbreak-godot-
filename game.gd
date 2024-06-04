extends Node

var bid1 = [0,0,0,0,0]
var score1 = [0,0,0,0,0]
var bid2 = [0,0,0,0,0]
var score2 = [0,0,0,0,0]
var bid3 = [0,0,0,0,0]
var score3 =[0,0,0,0,0]
var bid4 = [0,0,0,0,0]
var score4 = [0,0,0,0,0]

var round = 0

var card_disabled = false

var can_select = false
var player_turn = 1
var start_turn = 1
var reset_turn = 0

var player_active = ""

var card_names = ["clubs","diamond","shade","Hearts"]

var player1_cards = {}
var player2_cards = {}
var player3_cards = {}
var player4_cards = {}

var player1_card_selected = ""
var player1_card_node 
var player2_card_selected = ""
var player2_card_node 
var player3_card_selected = ""
var player3_card_node 
var player4_card_selected = ""
var player4_card_node 

var index = 0

func _ready():
	pass
	
func calculate_score():
	var highest = 0
	var selected_card_arr = {1:player1_card_selected,2:player2_card_selected,3:player3_card_selected,4:player4_card_selected}
	for i in range(1,5):
		if selected_card_arr[i].substr(0,1) == "s":
			selected_card_arr[i] = selected_card_arr[i].substr(0,1) + str(int(selected_card_arr[i].substr(1,-1)) * 100)  
		elif selected_card_arr[start_turn].substr(0,1) != selected_card_arr[i].substr(0,1):
			selected_card_arr[i] = selected_card_arr[i].substr(0,1) + str(int(selected_card_arr[i].substr(1,-1)) * -1)
			
	for i in range(1,5):
		if highest < int(selected_card_arr[i]):
			highest = int(selected_card_arr[i]) 
			index  = i
			player_turn = i
			start_turn = i
	match  index:
		1:
			score1[round] += 1
			return Vector2(0,20000)
		2:
			score2[round] += 1
			return Vector2(20000,0)
		3: 
			score3[round] += 1
			return Vector2(0,-20000)
		4: 
			score4[round] += 1
			return Vector2(-20000,0)
	
