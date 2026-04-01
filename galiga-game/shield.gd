extends Area2D

@onready var player = get_node("/root/Game/Player")
@onready var enemy = get_node("/root/Game/Enemy")
var disable_shield_time:= 0
var is_active := false
@onready var collision = $CollisionShape2D
@onready var color_rect = $ColorRect2

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	if is_active and Time.get_ticks_msec() >= disable_shield_time:
		is_active = false
		visible = false
		collision.disabled = true
		color_rect.visible = false
	
# turn its collision off
# turn its collider off

func _on_body_entered(body):
	if body == enemy:
		body.queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemy_bullet"):
		area.queue_free()  # Bullets are fine to free directly
	if area.is_in_group("enemy"):
		area.die()  # Let the enemy handle its own cleanup
