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
var dodging = false

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
	if (!is_blocking() and !is_attacking()) or is_dodging():
		move_and_slide()
	
	# Player Facing
	if is_player:
		##Line the player up with the camera
		if velocity.length() > 1.0:
			model.rotation.y = lerp_angle(model.rotation.y, spring_arm.rotation.y, rotation_speed * delta)
	
	## Collision Detection for footstep sounds
	#if is_player and velocity > Vector3.ZERO:
		#for index in range(get_slide_collision_count()):
			#var collision = get_slide_collision(index)
			#if collision.get_collider() == null:
				#continue
			#
			#if collision.get_collider().name.contains("tile"):
				#$AnimationPlayer2.play("new_animation")


func get_move_input(delta):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		do_action("jump")
	anim_tree.set("parameters/conditions/jumping", jumping)
		
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
		
		#Attacking
		if event.is_action_pressed("attack"):
			do_action("attack_slice_diagonal")
		#Blocking
		if event.is_action_pressed("block"):
			do_action("block")
		if event.is_action_released("block"):
			do_action("unblock")
		if event.is_action_pressed("shield_bash"):
			do_action("shield_bash")
		#Dodging
		if event.is_action_pressed("dodge_forward"):
			do_action("dodge_forward")
		if event.is_action_pressed("dodge_backward"):
			do_action("dodge_backward")
		if event.is_action_pressed("dodge_right"):
			do_action("dodge_right")
		if event.is_action_pressed("dodge_left"):
			do_action("dodge_left")
		if event.is_action_released("dodge_forward"):
			do_action("dodge_end")
		if event.is_action_released("dodge_backward"):
			do_action("dodge_end")
		if event.is_action_released("dodge_right"):
			do_action("dodge_end")
		if event.is_action_released("dodge_left"):
			do_action("dodge_end")


func do_action(action):
	match action:
		#Attack Actions
		"attack_slice_diagonal":
			anim_state.travel("1H_Melee_Attack_Slice_Diagonal")
		"attack_slice_horizontal":
			anim_state.travel("1H_Melee_Attack_Slice_Horizontal")
		"attack_chop":
			anim_state.travel("1H_Melee_Attack_Chop")
		"attack_stab":
			anim_state.travel("1H_Melee_Attack_Stab")
		"shield_bash":
			anim_state.travel("Block_Attack")
		#Block Actions
		"block":
			anim_state.travel("Block")
			anim_tree.set("parameters/conditions/blocking", true)
			anim_tree.set("parameters/conditions/unblocking", false)
			blocking = true
		"unblock":
			anim_state.travel("IWR")
			anim_tree.set("parameters/conditions/unblocking", true)
			anim_tree.set("parameters/conditions/blocking", false)
			blocking = false
		#Dodge Actions
		"dodge_forward":
			anim_state.travel("Dodge_Forward")
			dodging = true
		"dodge_backward":
			anim_state.travel("Dodge_Backward")
			dodging = true
		"dodge_right":
			anim_state.travel("Dodge_Right")
			dodging = true
		"dodge_left":
			anim_state.travel("Dodge_Left")
			dodging = true
		"dodge_end":
			dodging = false
		#Jump Actions
		"jump":
			velocity.y = jump_velocity
			jumping = true
			anim_tree.set("parameters/conditions/grounded", false)
		"fall":
			anim_state.travel("Jump_Idle")
			anim_tree.set("parameters/conditions/grounded", false)
		"land":
			jumping = false
			anim_tree.set("parameters/conditions/grounded", true)


# Returns true is we are in the middle of a dodging animation
func is_dodging():
	return anim_state.get_current_node().contains("Dodge")


# Returns true is we are in the middle of a blocking animation
func is_blocking():
	return anim_state.get_current_node().contains("Block")


# Returns true is we are in the middle of an attacking animation
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


func pickup_item(item, value, sound):
	if item == "gold":
		gold += value
		audio_stream_player.set_stream(sound)
		audio_stream_player.play()
		print("Gold: ", gold)
