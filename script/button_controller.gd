extends Node

var global = Game

@onready var place_call_menu = $"../.."

func _on_pressed():
	global.bid1 = self.name.substr(6, self.name.length() - 5)
	global.card_disabled = true
	place_call_menu.queue_free()
	
	
