extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		get_node("HappyBoo").play_walk_animation()
		# $HappyBoo is a shortcut version of get_node("HappyBoo")
		# %HappyBoo will work wherever the node is, but you will need to assign it as unique first.
		# To do so, right click node, then check the Access as Unique name box.
	else:
		get_node("HappyBoo").play_idle_animation()
