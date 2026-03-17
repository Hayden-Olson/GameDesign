extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_left", "move_right")
	velocity = direction * 600
	move_and_slide()
