extends Area2D

@export var pos : Vector2

func _on_body_entered(body: Node2D) -> void:
	if not $Timer.is_stopped(): return
	
	if body.is_in_group("enemy"):
		body.can_dash = true
		$Timer.start()
		visible = false

func _on_timer_timeout() -> void:
	visible = true
