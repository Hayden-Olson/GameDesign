extends CharacterBody2D

var next_shoot_time = 0
@export var blaster_rate = 0.5  #Time between shots
@export var health = 5

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
		if Time.get_ticks_msec() >= next_shoot_time:
			shoot()
			next_shoot_time = Time.get_ticks_msec() + blaster_rate

func take_damage():
	health -= 1
	#NOTIFICATION_VISIBILITY_CHANGED
	#self.visibility_changed
	if health <= 0:
		queue_free()
