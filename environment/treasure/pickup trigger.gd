extends Node3D

@export var item_type: String
@export var item_value: int
@export var sound_pickup: AudioStream

func _on_pickup_trigger_body_entered(body):
	print("Coin Collision")
	if body.has_method("pickup_item"):
		body.pickup_item(item_type, item_value, sound_pickup)
		queue_free()
