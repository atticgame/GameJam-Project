extends CharacterBody2D

@export var world_bottom : float #if you go below it, you die

# Movement Variables
const SPEED := 200
const TERMINAL_VELOCITY := 600
var friction := .3
var facing := 1 #1 right, -1 left

#Dash Variables
const DASH_SPEED := 800
var dash_direction := 1
var dashing := false
var can_dash := false
var dashing_dir : Vector2

# jumping
const JUMP_HEIGHT := -400
var was_on_floor := false
var coyoting := false
var jump_buffered := false

# other

func _physics_process(delta: float) -> void:
	#vertical stuff
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_just_released("jump"):
			if velocity.y < 0:
				velocity.y /= 1.5
	else:
		if not dashing:
			can_dash = true
		if jump_buffered:
			jump_buffered = false
			jump()
	
	if was_on_floor and not is_on_floor():
		$"coyote timer".start()
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or not $"coyote timer".is_stopped():
			jump()
		else:
			jump_buffered = true
			$"jump buffering".start()

	# velocity stuff
	var horizontal_input_direction := Input.get_axis("left", "right")
	if dashing:
		velocity = dashing_dir * DASH_SPEED
		if Input.is_action_just_released("dash"):
			dashing = false
		
		if $dashbox.get_overlapping_bodies().size() > 1:
			dashing = false
			velocity = Vector2.ZERO
	else:
		if horizontal_input_direction > 0:
			facing = 1
		elif horizontal_input_direction < 0:
			facing = -1
		if horizontal_input_direction:
			velocity.x = lerpf(velocity.x, horizontal_input_direction * SPEED, friction)
		else:
			velocity.x = lerpf(velocity.x, 0, friction)

	# dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$"dash timer".start()
		
		# so many if statements, it's disgusting
		if horizontal_input_direction == 0:
			if Input.is_action_pressed("up"):
				dashing_dir = Vector2(0, -1)
			elif Input.is_action_pressed("down"):
				dashing_dir = Vector2(0, 1)
			else:
				dashing_dir = Vector2(facing, 0)
		else:
			if facing == 1:
				if Input.is_action_pressed("up"):
					dashing_dir = Vector2(1, -1).normalized()
				elif Input.is_action_pressed("down"):
					dashing_dir = Vector2(1, 1).normalized()
				else:
					dashing_dir = Vector2(1, 0)
			else:
				if Input.is_action_pressed("up"):
					dashing_dir = Vector2(-1, -1).normalized()
				elif Input.is_action_pressed("down"):
					dashing_dir = Vector2(-1, 1).normalized()
				else:
					dashing_dir = Vector2(-1, 0)
		
		$dashbox/CollisionShape2D.position = dashing_dir

	if velocity.length() > TERMINAL_VELOCITY:
		velocity = velocity.normalized() * TERMINAL_VELOCITY
	
	was_on_floor = is_on_floor()

	move_and_slide()
	
	if position.y >= world_bottom:
		get_tree().reload_current_scene()

func jump() -> void:
	velocity.y = JUMP_HEIGHT

#region timers
func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_jump_buffering_timeout() -> void:
	jump_buffered = false

#endregion
