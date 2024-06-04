extends Control

@onready var round = $BoxContainer/round
@onready var player_1 = $BoxContainer/player1
@onready var player_2 = $BoxContainer/player2
@onready var player_3 = $BoxContainer/player3
@onready var player_4 = $BoxContainer/player4

var global = Game

func _ready():
	match global.round:
		1:
			score_adder(1)
		2:
			score_adder(2)
		3:
			score_adder(3)
		4:
			score_adder(4)
	
func score_adder(i):
	var _lbl_round = Label.new()
	var _player1 = Label.new()
	var _player2 = Label.new()
	var _player3 = Label.new()
	var _player4 = Label.new()
	

	_lbl_round.text = str(global.round)
	_player1.text = str(score_calulator(int(global.bid1[i-1]),int(global.score1[i-1])))
	#_player2.text = str(score_calulator(int(global.bid2[i-1]),int(global.score2[i-1])))
	#_player3.text = str(score_calulator(int(global.bid3[i-1]),int(global.score3[i-1])))
	#_player4.text = str(score_calulator(int(global.bid4[i-1]),int(global.score4[i-1])))
	
	round.add_child(_lbl_round)
	player_1.add_child(_player1)
	#player_2.add_child(_player2)
	#player_3.add_child(_player3)
	#player_4.add_child(_player4)
	
func score_calulator(bid,score):
	if score < bid:
		return bid * -1
	elif score >= bid:
		return bid + (score-bid) / 10.0

func _process(delta):
	pass
