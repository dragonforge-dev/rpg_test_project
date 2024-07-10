extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_test_tools_gui_knight_selected():
	$Barbarian.is_player = false
	$Mage.is_player = false
	
	$Knight.is_player = true
	$Knight.get_node("FollowCamera/Camera3D").set_current(true)


func _on_test_tools_gui_mage_selected():
	$Barbarian.is_player = false
	$Knight.is_player = false
	
	$Mage.is_player = true
	$Mage.get_node("FollowCamera/Camera3D").set_current(true)
	

func _on_test_tools_gui_barbarian_selected():
	$Knight.is_player = false
	$Mage.is_player = false
	
	$Barbarian.is_player = true
	$Barbarian.get_node("FollowCamera/Camera3D").set_current(true)

#TODO: +Implement Dodge
#TODO: +Implement Attacks based on direction
#TODO: Implement Health
#TODO: +Implement Collision for weapons
#TODO: Implement collision for shields
#TODO: Implement health lost when hit by weapon
#TODO: +Implement Coin drop when character dies
#TODO: Implement spawning when character dies
#TODO: Implement shopkeeper that sells sword
#TODO: See if I can attach a new weapon to the Knight's hand
#TODO: Create a Tutorial Shell
#TODO: +Install Blender
#TODO: Pull over the TC Soundplayer and test it.
#TODO: +Implement Coin pickup
#TODO: Implement Footsep sounds
#TODO: Implement Skeleton Mob

