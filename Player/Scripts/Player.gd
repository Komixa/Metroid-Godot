extends CharacterBody2D

var movement = Vector2()
var speed = 200
var jump_ht = 600
var fall_vel = 5
var current_direction = "right"
var crouch = false

var dash = 0
var dash_t = 15
var dash_cd = 40
var has_dash = dash_cd

@onready var anim = $Player_Anim

func _physics_process(delta):
	current_gravity()
	player_mvt()
	check_direction()
	movement = movement.normalized() * speed * delta
	move_and_slide()

func player_mvt():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var JUMP = Input.is_action_just_pressed("ui_accept")
	var DOWN = Input.is_action_pressed("ui_down")
	var UP = Input.is_action_pressed("ui_up")
	var DASH = Input.is_action_just_pressed("game_dash")
	var ATTACK = Input.is_action_just_pressed("game_attack")
	
	movement.x = -int(LEFT) + int(RIGHT)
	movement.y = -int(JUMP)
	
	if movement.x != 0:
		velocity.x = movement.x * speed
	else:
		velocity.x = 0
	
	if DASH and has_dash == dash_cd:
		dash = dash_t
		has_dash = 0
	
	if ATTACK:
		player_atk()
	
	if JUMP and is_on_floor():
		fall_vel -= jump_ht
	
	if DOWN:
		crouch = true
	if !DOWN:
		crouch = false
	
	if dash > 0:
		dash -=1
	if has_dash < dash_cd:
		has_dash += 1

#func check_crouch_state():
	#if crouch:
		#pass
	#else:
		#pass

func check_direction():
	if movement.x == -1:
		current_direction = "left"
	
	if movement.x == 1:
		current_direction = "right"
	
	animation_player()

func animation_player():
	if !crouch:
		speed = 200
		pl_run()
		#idle
		if movement.x == 0:
			pl_idle()
	#crouch left
	if crouch:
		pl_crouch()
	#dash
	if dash > 0:
		pl_dash()

func current_gravity():
	var new_gravity = gravity_force.new()
	velocity.y = fall_vel
	if !is_on_floor():
		fall_vel += new_gravity.gravity_strength
	if is_on_floor() and fall_vel > 5:
		fall_vel = 5
	if fall_vel >= new_gravity.terminal_vel:
		fall_vel = new_gravity.terminal_vel

func pl_idle():
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

func pl_run():
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

func pl_crouch():
	#crouch left
	if current_direction == "left":
		speed = 0
		anim.play("Crouch_Left")
		#falling
		if !is_on_floor():
			if velocity.y > 0:
				anim.play("Fall_Left")
	#crouch right
	if current_direction == "right":
		speed = 0
		anim.play("Crouch_Right")
		#falling
		if !is_on_floor():
			if velocity.y > 0:
				anim.play("Fall_Right")

func pl_dash():
	#smooth speed
	speed = (dash*(int(800/dash_t)))
	#dash left
	if current_direction == "left":
		anim.play("Dash_Left")
		anim.frame = int((dash_t-dash)/5)
	#dash right
	if current_direction == "right":
		anim.play("Dash_Right")
		anim.frame = int((dash_t-dash)/5)
	#horizontal air dash
	if !is_on_floor():
		velocity.y = 0

func player_atk():
	pass
