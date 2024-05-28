extends Node2D

var card_names = ["clubs","diamond","shade","Hearts"]
var random_index_card
var random_index_number
var card_sprite
var global = Game
@onready var card_show = $Timer
@onready var menu_show = $"../../place_call_menu/Timer"
@onready var lbl_bid = $lbl_bid

func _ready():
	randomize()  
	for i in range(1, 8): 
			card_sprite = get_node("./card_suffle/card" + str(i) + "/card" + str(i) + "_sprite")
			card_sprite.texture = load("res://assets/card_backside.jpeg")
			var card_player = get_node("./card_suffle/card" + str(i) + "/AnimationPlayer")
			card_player.play("suffle" + str(i))
	card_show.start()
	match int(self.name.substr(11,12)):
		1:
			lbl_bid.text = "Score/Bid : " + str(global.score1)+"/"+str(global.bid1)
		2:
			lbl_bid.rotation =  deg_to_rad(90)
			lbl_bid.position.x += 20
			lbl_bid.position.y -= 20
			lbl_bid.text = "Score/Bid : " + str(global.score2)+"/"+str(global.bid2)
		3:
			lbl_bid.rotation =  deg_to_rad(180)
			lbl_bid.position.x += 100 
			lbl_bid.position.y += 30 
			lbl_bid.text = "Score/Bid : " + str(global.score3)+"/"+str(global.bid3)
		4:
			lbl_bid.rotation =  deg_to_rad(270)
			lbl_bid.position.x -= 10 
			lbl_bid.position.y += 80 
			lbl_bid.text = "Score/Bid : " + str(global.score4)+"/"+str(global.bid4)

func _process(delta):
	match int(self.name.substr(11,12)):
		1:
			lbl_bid.text = "Score/Bid : " + str(global.score1)+"/"+str(global.bid1)
		2:
			lbl_bid.text = "Score/Bid : " + str(global.score2)+"/"+str(global.bid2)
		3:
			lbl_bid.text = "Score/Bid : " + str(global.score3)+"/"+str(global.bid3)
		4:
			lbl_bid.text = "Score/Bid : " + str(global.score4)+"/"+str(global.bid4)
			
func _on_timer_timeout():
	if int(self.name.substr(11,12)) == int(1): 
		suffle_card_and_add_cards(global.player1_cards)
		
	if int(self.name.substr(11,12)) == int(2): 
		suffle_card_and_add_cards(global.player2_cards)
		
	if int(self.name.substr(11,12)) == int(3): 
		suffle_card_and_add_cards(global.player3_cards)
		
	if int(self.name.substr(11,12)) == int(4): 
		suffle_card_and_add_cards(global.player4_cards)
		
	card_show.stop()
	menu_show.start()

func suffle_card_and_add_cards(player_card):
	for i in range(1, 8):
			random_index_card = randi() % card_names.size() 
			random_index_number = (randi() % 13) + 1
			card_sprite = get_node("./card_suffle/card" + str(i) + "/card" + str(i) + "_sprite")
			card_sprite.texture = load("res://assets/" + card_names[random_index_card] + "/PNG/" + str(random_index_number) + ".png")
			player_card[i-1] = card_names[random_index_card][0] + str(random_index_number)

func _on_mouse_entered():
	global.player_active = self.name.substr(11)

	
