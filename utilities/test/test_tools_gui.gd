extends CanvasLayer

signal barbarian_selected
signal knight_selected
signal mage_selected


func _on_knight_toggled(toggled_on):
	if toggled_on:
		knight_selected.emit()
		$MarginContainer/VBoxContainer/Barbarian.button_pressed = false
		$MarginContainer/VBoxContainer/Barbarian.disabled = false
		$MarginContainer/VBoxContainer/Mage.button_pressed = false
		$MarginContainer/VBoxContainer/Mage.disabled = false
		
		$MarginContainer/VBoxContainer/Knight.disabled = true


func _on_mage_toggled(toggled_on):
	if toggled_on:
		mage_selected.emit()
		$MarginContainer/VBoxContainer/Barbarian.button_pressed = false
		$MarginContainer/VBoxContainer/Barbarian.disabled = false
		$MarginContainer/VBoxContainer/Knight.button_pressed = false
		$MarginContainer/VBoxContainer/Knight.disabled = false
		
		$MarginContainer/VBoxContainer/Mage.disabled = true


func _on_barbarian_toggled(toggled_on):
	if toggled_on:
		barbarian_selected.emit()
		$MarginContainer/VBoxContainer/Knight.button_pressed = false
		$MarginContainer/VBoxContainer/Knight.disabled = false
		$MarginContainer/VBoxContainer/Mage.button_pressed = false
		$MarginContainer/VBoxContainer/Mage.disabled = false
		
		$MarginContainer/VBoxContainer/Barbarian.disabled = true

