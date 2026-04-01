extends CharacterBody2D

var next_shoot_time = 0
@export var blaster_rate = 0.5  #Time between shots
@export var health = 5
var can_take_damage: bool = true
var enemies_downed = 0
@onready var shield = get_node("/root/Game/Player/Shield")
var shield_uses = 3
var shield_length = 3000
@onready var collision = $CollisionShape2D
@onready var color_rect = $ColorRect2
signal health_depleted
@export var required_kills := 25
@onready var health_text = get_node("/root/Game/Health")
@onready var shield_text = get_node("/root/Game/Shield")

func _ready():
	update_hud()
	
func update_hud():
	health_text.text = "Health: " + str(health)
	shield_text.text = "Shield: " + str(shield_uses)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_down", "move_up")
	velocity = direction * 600
	move_and_slide()
	update_hud()
	
	
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
	if event.is_action_pressed("shield") and shield_uses >= 1:
		turn_on_shield()

func take_damage():
	if can_take_damage == true:
		health -= 1
		update_hud()
	if health <= 0:
		update_hud()
		health_depleted.emit()
		queue_free()
	can_take_damage = false
	#while Time.get_ticks_msec() != 10000:
		#CanvasModulate.color
		
	
	can_take_damage = true

func add_death_count():
	enemies_downed += 1
	if enemies_downed >= required_kills:
		enemies_downed = 0
		shield_uses += 1
		update_hud()
		
func turn_on_shield():
	shield.disable_shield_time = Time.get_ticks_msec() + shield_length
	shield.is_active = true
	shield.visible = true
	shield.collision.disabled = false
	shield.color_rect.visible = true
	shield_uses -= 1
	update_hud()
