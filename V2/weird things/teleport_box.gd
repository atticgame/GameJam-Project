extends Area2D

@export var pos : Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.position = pos
