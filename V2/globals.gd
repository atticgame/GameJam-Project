extends Node

func wait_until(thing: bool) -> void:
	while not thing:
		await get_tree().process_frame
