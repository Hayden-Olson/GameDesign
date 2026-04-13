extends CharacterBody2D


@export var health = 2
enum enemy_states {ENTRY, IDLE, DIVE}
var enemy_state = enemy_states.ENTRY
var direction = 1
@export var SPEED := 200.0
var enemy_cluster
var clusterNode
@onready var path_follow := get_parent()  # The PathFollow2D
@export var entry_speed := 800.0
var entry_done := false
var next_shoot_time = 2000
var blaster_rate
@export var min_blaster_rate = 1000
@export var max_blaster_rate = 2000
var is_shooter
@export var shooter_percentage := 0.1
var player_position
var dive_rate := 0
var next_dive_time := 10000
var is_diving = false
@onready var player = get_node("/root/Game/Player")
@onready var audio = $Audio
@export var shoot_sound : AudioStream

var splode = preload("res://explosion.tscn")
const BULLET = preload("res://enemy_bullet.tscn")

func _ready():
	# randf() returns a value between 0.0 and 1.0
	blaster_rate = randf_range(min_blaster_rate, max_blaster_rate)
	if randf() <= shooter_percentage:
		is_shooter = true
	else:
		is_shooter = false
	next_dive_time = randf_range(20000,30000)

func _physics_process(delta: float) -> void:
	if is_shooter:
		if Time.get_ticks_msec() >= next_shoot_time:
			shoot()
			next_shoot_time = Time.get_ticks_msec() + blaster_rate
	match enemy_state:
		enemy_states.ENTRY:
			if not entry_done:
				path_follow.progress += entry_speed * delta
				if path_follow.progress_ratio >= 1.0:
					entry_done = true
					rotation = 0
					enemy_state = enemy_states.IDLE
	# Check if idle then call idle script
		enemy_states.IDLE:
			global_position = global_position.move_toward(clusterNode.global_position, SPEED * delta)
			global_rotation_degrees = 90
			$AnimationPlayer.play("Enemy_Idle")
			if Time.get_ticks_msec() >= next_dive_time:
				if randf() <= .0005:
					is_diving = true
				else:
					is_diving = false
				if is_diving == true:
					dive_movement(delta)
				next_dive_time = Time.get_ticks_msec() + dive_rate
	# Check if dive time has passed
		enemy_states.DIVE:
			var target_angle = global_position.direction_to(player_position).angle()
			global_rotation = lerp_angle(global_rotation, target_angle, 1 * delta)
			global_position = global_position.move_toward(player_position, SPEED * delta)
			if global_position.y > 650:
				global_position = Vector2(570,-170)
				enemy_state = enemy_states.IDLE
	# If dive time has passed, call dive function
	
	
# Shoot behavior is handled here.
func shoot():
	
	var new_bullet = BULLET.instantiate()
	audio.stream = shoot_sound
	audio.play()
	 # Add the bullet to the scene tree root instead of the player
	get_tree().current_scene.add_child(new_bullet)
	new_bullet.global_position = global_position # Use marker for accurate position
	new_bullet.global_rotation = PI
	new_bullet.is_enemy_bullet = true

# Enemy damage is handled here.
func take_damage():
	health -= 1
	if health <= 0:
		# Call cluster script for removing enemy
		die()
		
# This function is just for when enemy runs into the shield. They dont take damage, they just die.
func die():
	player.add_death_count()
	enemy_cluster.remove_enemy(self)
	var boom = splode.instantiate()
	 # Add the bullet to the scene tree root instead of the player
	get_tree().current_scene.add_child(boom)
	boom.global_position = global_position
	
	queue_free()

func set_cluster_position(PositionNode:Area2D, cluster:Area2D):
	#look_at(position.global_position)
	clusterNode = PositionNode
	enemy_cluster = cluster
	#var move_vec = Vector2(speed, 0).rotated(rotation)
	#global_position += move_vec
	
func entry_movement():
	entry_done = false
	path_follow.progress = 0
	
func dive_movement(delta: float):
	# Tuen idle off
	# Find current player position
	
	# move toward position
	# If player is dead, then cancel dive.
	if player == null:
		return
	else:
		player_position = player.global_position
		player_position *= 1.1
	# shoot while movingaaa
	dive_rate = randf_range(10000,20000)
	# after it passes player position offscreen, return to the spawn position
	# Call entry movement or move into position
	enemy_state = enemy_states.DIVE

func _on_area_2d_body_entered(body: Node2D) -> void:
	if player:
		player.take_damage()
		take_damage()
