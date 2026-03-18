extends Area2D

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	%ShootingPoint.add_child
	
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
