extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var score_board = load("res://scene/score_board.tscn") as PackedScene
	var score_board_instance = score_board.instantiate()
	add_child(score_board_instance)
	score_board_instance.position = Vector2(-1200,250)
	score_board_instance.scale = Vector2(0.5,0.5)
	
	
func center_control_node(control_node):
	print(control_node.position)


	
