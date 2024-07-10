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



