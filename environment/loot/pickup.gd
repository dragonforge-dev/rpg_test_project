extends Node3D

class_name Pickup

## The [PackedScene] to pass to the player character to add to inventory.
## [b]NOTE:[/b] [i]If this is left empty, gold will be added to the player's
## using the number or range from the amount field. This is a good way to
## allow the conversion of items to gold without requiring an intermediary.[/i]
@export var item: PackedScene
## The amount of the item to inventory as an [Array] of [int]s.
## If only 1 value is supplied, that amount will be added.
## If 2 values are supplied, it will use the first number as the minimum
## amount and the second number as the maximum amount and return a random value
## between the two (inclusive).
## If 3 or more values are supplied, it will randomly select one of the options
## from the list and send that amount.
## Defaults to giving the player one of the item.
@export var amount: Array[int] = [1]
## The sound to play when the item is picked up as an [Array] of [AudioStream]s.
## If no tracks are supplied, no sound is played.
## If only 1 track is supplied, that sound always plays.
## If 2 or more values are supplied, it will randomly select one of the options
## from the list and send that sound file.
## [b]NOTE:[/b] [i]You always want to use .WAV files for sound effects when you can.[/i]
@export var sound_on_pickup: Array[AudioStream]


func _on_pickup_trigger_body_entered(body):
	print("Pickup Collision")
	if body.has_method("pickup_item"):
		body.pickup_item(item, _get_amount(), _get_audio_file())
		get_parent_node_3d().queue_free()


func _get_amount():
	var choices = amount.size()
	match choices:
		1:
			return amount[0]
		2:
			var rng = RandomNumberGenerator.new()
			return rng.randi_range(amount[0], amount[1])
		_:
			return amount.pick_random()


func _get_audio_file():
	if sound_on_pickup.is_empty():
		return
	return sound_on_pickup.pick_random()
