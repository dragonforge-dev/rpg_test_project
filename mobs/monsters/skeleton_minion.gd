extends CharacterBody3D

@export var loot: Array[PackedScene]
@export var equipped_weapon: String
@export var gold = 0

@export var death_sounds: Array[AudioStream]

@export_group("Physics")
@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_velocity = 8.0
@export var rotation_speed = 12.0
@export var dodge_speed = 5.0
@export var dodge_acceleration = 4.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping = false
var grounded = true
var blocking = false
var sheathed = false

@onready var model = $Rig
@onready var anim_tree = $AnimationTree

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get movement
	# TODO: Add movement code here
	get_move_input(delta)

	# Apply Movement
	#   The character can't move when blocking or attacking,
	#   but it can move while dodging.
	if (!blocking and !is_attacking()) or is_dodging() or jumping:
		move_and_slide()
	

func get_move_input(_delta):
	# Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = jump_velocity
		#do_action("jump")
		
	# We just hit the floor after being in the air
	if is_on_floor() and not grounded:
		do_action("land")
	grounded = is_on_floor()
	
	# Falling (We're in the air, but we didn't jump)
	if not is_on_floor() and not jumping:
		do_action("fall")
	
	#Combination Attacks
	#if Input.is_action_pressed("attack") and Input.is_action_pressed("forward"):
		#do_action("attack_stab")
	#if Input.is_action_pressed("attack") and Input.is_action_pressed("back"):
		#do_action("attack_chop")
	#if Input.is_action_pressed("attack") and Input.is_action_pressed("left"):
		#do_action("attack_slice_horizontal")
	#if Input.is_action_pressed("attack") and Input.is_action_pressed("right"):
		#do_action("attack_slice_horizontal")
	
	# Walking/Running
	#var input_dir = Input.get_vector("left", "right", "forward", "back")
	#Remove spring_arm
	#var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, spring_arm.rotation.y)
	#if direction:
		#velocity.x = direction.x * speed
		#velocity.z = direction.z * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)

	#Determine Walk/Run Animation
	#velocity = lerp(velocity, direction * speed, acceleration * delta)
	#var vl = velocity * model.transform.basis
	#anim_tree.set("parameters/IWR/blend_position", Vector2(vl.x, -vl.z) / speed)


func do_action(action):
	match action:
		"sheath_weapon":
			if equipped_weapon.is_empty():
				return
			if sheathed:
				find_child(equipped_weapon).show()
				find_child("Sheath_" + equipped_weapon).hide()
				sheathed = false
			else:
				find_child(equipped_weapon).hide()
				find_child("Sheath_" + equipped_weapon).show()
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
	return Animations.is_doing("Dodge", anim_tree)


# Returns true if we are in the middle of a attacking animation.
# Currently how we are tracking when the animation ends.
func is_attacking():
	return Animations.is_doing("Attack", anim_tree)


# Temporary method. There will be better ways to do this.
func is_alive():
	return !Animations.is_doing("Death", anim_tree)


func die():
	if is_alive():
		Sounds.play_sound_effect(death_sounds.pick_random())
		Animations.do_animation("die", anim_tree)
		drop_loot()
	
	
func drop_loot():
	if !loot.is_empty():
		for heldobject in loot:
			var droppeditem = heldobject.instantiate()
			get_parent_node_3d().add_child(droppeditem)

func _on_h_sword_body_entered(body):
	body.die()



