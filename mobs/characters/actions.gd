extends Object

class_name Actions

# TODO: It would be nice to implement this as a match statement if InputEvent
# ever gets a get_action_name() method to test against.
static func get_action(event):
	#Blocking
	if event.is_action_pressed("block"):
		return "block"
	if event.is_action_released("block"):
		return "unblock"
	if event.is_action_pressed("shield_bash"):
		return "shield_bash"
	#Attacking
	# NOTE: Attacking goes after blocking, because otherwise shield_bash
	# would never be triggered.
	if event.is_action_pressed("attack"):
		return "attack_slice_diagonal"
	#Dodging
	if event.is_action_pressed("dodge_forward"):
		return "dodge_forward"
	if event.is_action_pressed("dodge_backward"):
		return "dodge_backward"
	if event.is_action_pressed("dodge_right"):
		return "dodge_right"
	if event.is_action_pressed("dodge_left"):
		return "dodge_left"
	#Sheathing
	if event.is_action_pressed("sheath_weapon"):
		return "sheath_weapon"

