extends Node2D

var card_names = ["clubs","diamond","shade","Hearts"]
var random_index_card
var random_index_number
var card_sprite

func _ready():
	randomize()  
	for i in range(1, 8): 
			card_sprite = get_node("./card_suffle/card" + str(i) + "/card" + str(i) + "_sprite")
			card_sprite.texture = load("res://assets/card_backside.jpeg")
			var card_player = get_node("./card_suffle/card" + str(i) + "/AnimationPlayer")
			card_player.play("suffle" + str(i))




