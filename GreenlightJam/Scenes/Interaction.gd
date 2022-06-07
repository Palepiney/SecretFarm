extends RayCast

var current_collider
onready var interaction_label = get_node("/root/Main/UI/InteractLabel")
onready var player_script = $"/root/Main/Player"

func _ready():
	set_interaction_text("")

func _process(_delta):
	# Constantly check collider
	var collider = get_collider()
	
	# Check if raycast is colliding with an interactable object
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			set_interaction_text(collider.get_interaction_text())
			current_collider = collider
		
		if Input.is_action_just_pressed("interact"):
			if not player_script.is_carrying:
				collider.interact()
				set_interaction_text(collider.get_interaction_text())
				player_script.is_carrying = true
				print(player_script.is_carrying)
	elif current_collider:
		# If not colliding with anything, clear
		current_collider = null
		set_interaction_text("")

func set_interaction_text(text):
	if !text:
		interaction_label.set_text("")
		interaction_label.set_visible(false)
	else:
		var interact_key = OS.get_scancode_string(InputMap.get_action_list("interact")[0].scancode)
		interaction_label.set_text("Press %s to %s" % [interact_key, text])
		interaction_label.set_visible(true)
