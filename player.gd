extends CharacterBody2D

#Movement Variables
const SPEED = 100
const JUMP_VELOCITY = -200

#Dash Variables
var dash_direction = Vector2(1, 0)
var dash_speed = 350
var dashing = false
var can_dash = true

func _physics_process(delta: float) -> void:
#Gravity Template
	if not is_on_floor():
		velocity += get_gravity() * delta

#Jump Template
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

#Movement Template + Dash edit
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if dashing: velocity.x = direction * dash_speed
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) 

	#Dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$DashTimer.start()
		$DashCooldown.start()

	move_and_slide()

#Dash last timer
func _on_dash_timer_timeout() -> void:
	dashing = false

#Dash Cooldown
func _on_dash_cooldown_timeout() -> void:
	can_dash = true 
