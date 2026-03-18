extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_down", "move_up")
	velocity = direction * 600
	move_and_slide()
	

#if velocity.length() > 0.0:
	#get_node("").play_walk_animation()
#else:
	#get_node("").play_idle_animation()
	

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	 # Add the bullet to the scene tree root instead of the player
	get_tree().current_scene.add_child(new_bullet)
	new_bullet.global_position = global_position # Use marker for accurate position
	new_bullet.global_rotation = global_rotation
	
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
