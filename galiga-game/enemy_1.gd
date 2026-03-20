extends CharacterBody2D
var right = true
var direction = 0

func _physics_process(delta: float) -> void:
	const SPEED = 200
	const RANGE = 1200
	if right == true:
		direction = -transform.x
	else:
		direction = transform.x
	position += direction * SPEED * delta



func shoot():
	const BULLET = preload("res://enemy_bullet.tscn")
	var new_bullet = BULLET.instantiate()
	 # Add the bullet to the scene tree root instead of the player
	get_tree().current_scene.add_child(new_bullet)
	new_bullet.global_position = global_position # Use marker for accurate position
	new_bullet.global_rotation = global_rotation
	


func _on_timer_timeout() -> void:
	shoot()
	if right == true:
		right = false
	elif right == false:
		right == true
	%Timer.autostart = true
