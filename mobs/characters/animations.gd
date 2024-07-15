extends Object

class_name Animations

static func do_animation(action: String, anim_tree: AnimationTree):
	var anim_state = anim_tree.get("parameters/playback")
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
			return { "blocking": true }
		"unblock":
			anim_state.travel("IWR")
			anim_tree.set("parameters/conditions/unblocking", true)
			anim_tree.set("parameters/conditions/blocking", false)
			return { "blocking": false }
		#Dodge Actions
		"dodge_forward":
			anim_state.travel("Dodge_Forward")
		"dodge_backward":
			anim_state.travel("Dodge_Backward")
		"dodge_right":
			anim_state.travel("Dodge_Right")
		"dodge_left":
			anim_state.travel("Dodge_Left")
		#Jump Actions
		"jump":
			anim_tree.set("parameters/conditions/grounded", false)
			anim_tree.set("parameters/conditions/jumping", true)
			return { "jumping": true }
		"fall":
			anim_state.travel("Jump_Idle")
			anim_tree.set("parameters/conditions/jumping", true)
			anim_tree.set("parameters/conditions/grounded", false)
			return { "jumping": true }
		"land":
			anim_tree.set("parameters/conditions/grounded", true)
			anim_tree.set("parameters/conditions/jumping", false)
			return { "jumping": false }
