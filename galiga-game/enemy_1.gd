extends CharacterBody2D


@export var health = 2

#_init():
	
# Shoot behavior is handled here.
func shoot():
	const BULLET = preload("res://enemy_bullet.tscn")
	var new_bullet = BULLET.instantiate()
	 # Add the bullet to the scene tree root instead of the player
	get_tree().current_scene.add_child(new_bullet)
	new_bullet.global_position = global_position # Use marker for accurate position
	new_bullet.global_rotation = global_rotation
	

# Enemy damage is handled here.
func take_damage():
	health -= 1
	if health <= 0:
		queue_free()


func _on_ready() -> void:
	pass # Replace with function body.

func set_cluster_position(position:Area2D, enemy:Enemy):
	pass
