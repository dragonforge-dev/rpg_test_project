extends CharacterBody3D

@export var is_player = false
@export var mouse_sensitivity = 0.0075
@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_velocity = 8.0
@export var rotation_speed = 12.0

@export var dodge_speed = 5.0
@export var dodge_acceleration = 4.0

@export var gold = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping = false
var grounded = true
var blocking = false
var sheathed = false

@onready var spring_arm = $FollowCamera
@onready var model = $Rig
@onready var anim_tree = $AnimationTree
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var anim_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer3D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get movement
	if is_player:
		get_move_input(delta)

	# Apply Movement
	#   The character can't move when blocking or attacking,
	#   but it can move while dodging.
	if (!blocking and !is_attacking()) or is_dodging() or jumping:
		move_and_slide()
	
	# Player Facing
	if is_player:
		##Line the player up with the camera
		if velocity.length() > 1.0:
			model.rotation.y = lerp_angle(model.rotation.y, spring_arm.rotation.y, rotation_speed * delta)
	

func get_move_input(delta):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		do_action("jump")
		
	# We just hit the floor after being in the air
	if is_on_floor() and not grounded:
		do_action("land")
	grounded = is_on_floor()
	
	# Falling (We're in the air, but we didn't jump)
	if not is_on_floor() and not jumping:
		do_action("fall")
	
	#Combination Attacks
	if Input.is_action_pressed("attack") and Input.is_action_pressed("forward"):
		do_action("attack_stab")
	if Input.is_action_pressed("attack") and Input.is_action_pressed("back"):
		do_action("attack_chop")
	if Input.is_action_pressed("attack") and Input.is_action_pressed("left"):
		do_action("attack_slice_horizontal")
	if Input.is_action_pressed("attack") and Input.is_action_pressed("right"):
		do_action("attack_slice_horizontal")
	
	# Walking/Running
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, spring_arm.rotation.y)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	#Determine Walk/Run Animation
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	var vl = velocity * model.transform.basis
	anim_tree.set("parameters/IWR/blend_position", Vector2(vl.x, -vl.z) / speed)


func _unhandled_input(event):
	if is_player:
		if event is InputEventMouseMotion:
			spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
			spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0)
			spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
		
		do_action(Actions.get_action(event))


func do_action(action):
	match action:
		"sheath_weapon":
			if sheathed:
				find_child("1H_Axe").show()
				find_child("Sheath_1H_Axe").hide()
				sheathed = false
			else:
				find_child("1H_Axe").hide()
				find_child("Sheath_1H_Axe").show()
				sheathed = true
		_:
			if action != null:
				var return_value = Animations.do_animation(action, anim_tree)
				if return_value != null:
					match return_value.keys()[0]:
						"jumping":
							jumping = return_value.get("jumping")
						"blocking":
							blocking = return_value.get("blocking")


# Returns true if we are in the middle of a dodging animation.
# Currently how we are tracking when the animation ends.
func is_dodging():
	return anim_state.get_current_node().contains("Dodge")


# Returns true if we are in the middle of a attacking animation.
# Currently how we are tracking when the animation ends.
func is_attacking():
	return anim_state.get_current_node().contains("Attack")


func is_alive():
	return !anim_state.get_current_node().contains("Death")


func die():
	if is_alive():
		anim_state.travel("Death_A")
		drop_loot()
	
	
func drop_loot():
	var heldobject = load("res://environment/treasure/coin.tscn").instantiate()
	add_child(heldobject)

func _on_h_sword_body_entered(body):
	body.die()


func pickup_item(item, amount, sound):
	if item == null:
		gold += amount
		audio_stream_player.set_stream(sound)
		audio_stream_player.play()
		print(name + " Gold: ", gold)
	else:
		# TODO: Add item to inventory
		# Play sound
		audio_stream_player.set_stream(sound)
		audio_stream_player.play()
		print(name + " picked up " + item.name)
