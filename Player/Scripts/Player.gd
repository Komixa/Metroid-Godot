extends CharacterBody2D

var movement = Vector2()
var speed = 200
var jump_ht = 600
var fall_vel = 5
var current_direction = "right"
var crouch = false
var dash = false

@onready var anim = $Player_Anim

func _physics_process(delta):
	current_gravity()
	#check_crouch_state()
	player_mvt()
	animation_player()
	
	movement = movement.normalized() * speed * delta
	move_and_slide()

func player_mvt():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var JUMP = Input.is_action_just_pressed("ui_accept")
	var DOWN = Input.is_action_pressed("ui_down")
	var UP = Input.is_action_pressed("ui_up")
	var DASH = Input.is_action_pressed("dash")
	
	movement.x = -int(LEFT) + int(RIGHT)
	movement.y = -int(JUMP)
	
	if movement.x != 0:
		velocity.x = movement.x * speed
	else:
		velocity.x = 0
	
	if JUMP and is_on_floor():
		fall_vel -= jump_ht
	
	if DOWN:
		crouch = true
	if !DOWN:
		crouch = false
	
	if DASH:
		dash = true
		player_dash()
	if !DASH:
		dash = false

#func check_crouch_state():
	#if crouch:
		#pass
	#else:
		#pass

func animation_player():
	if movement.x == -1:
		current_direction = "left"
	
	if movement.x == 1:
		current_direction = "right"
	
	check_direction()

func check_direction():
	if !crouch:
		speed = 200
		#run left
		if current_direction == "left":
			if is_on_floor():
				anim.play("Run_Left")
			#jump left
			if !is_on_floor():
				if velocity.y < 0:
					anim.play("Jump_Left")
				if velocity.y > 0:
					anim.play("Fall_Left")
		#run right
		if current_direction == "right":
			if is_on_floor():
				anim.play("Run_Right")
			#jump right
			if !is_on_floor():
				if velocity.y < 0:
					anim.play("Jump_Right")
				if velocity.y > 0:
					anim.play("Fall_Right")
		#idle
		if movement.x == 0:
			#left
			if current_direction == "left":
				anim.play("Idle_Left")
				#jump left
				if !is_on_floor():
					if velocity.y < 0:
						anim.play("Idle_Jump_Left")
					if velocity.y > 0:
						anim.play("Fall_Left")
			#right
			if current_direction == "right":
				anim.play("Idle_Right")
				#jump right
				if !is_on_floor():
					if velocity.y < 0:
						anim.play("Idle_Jump_Right")
					if velocity.y > 0:
						anim.play("Fall_Right")
	#crouch left
	if crouch and current_direction == "left":
		speed = 0
		anim.play("Crouch_Left")
		#falling
		if !is_on_floor():
			if velocity.y > 0:
				anim.play("Fall_Left")
	#crouch right
	if crouch and current_direction == "right":
		speed = 0
		anim.play("Crouch_Right")
		#falling
		if !is_on_floor():
			if velocity.y > 0:
				anim.play("Fall_Right")

func current_gravity():
	var new_gravity = gravity_force.new()
	velocity.y = fall_vel
	if !is_on_floor():
		fall_vel += new_gravity.gravity_strength
	if is_on_floor() and fall_vel > 5:
		fall_vel = 5
	if fall_vel >= new_gravity.terminal_vel:
		fall_vel = new_gravity.terminal_vel

func player_dash():
	if current_direction == "left":
		anim.play("Dash_Left")
	if current_direction == "right":
		anim.play("Dash_Right")

func player_atk():
	pass
