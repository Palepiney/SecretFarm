extends Interactable


onready var player = get_node("/root/Main/Player/Pivot/Carrying")
var hay = preload("res://Scenes/Hay.tscn")

func get_interaction_text():
	return "pick up hay"

func interact():
	var hay_instance = hay.instance()
	
	player.add_child(hay_instance)
#
#	elif is_carrying:
#		player.queue_free()
#		is_carrying = false
#		print(is_carrying)
		
