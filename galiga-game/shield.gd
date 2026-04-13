extends Area2D

@onready var player = get_node("/root/Game/Player")
@onready var enemy = get_node("/root/Game/Enemy")
var disable_shield_time:= 0
var is_active := false
@onready var collision = $CollisionShape2D
@onready var sprite = $Shield2

func _ready() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	if is_active and Time.get_ticks_msec() >= disable_shield_time:
		is_active = false
		visible = false
		collision.disabled = true
		sprite.visible = false
	
# turn its collision off
# turn its collider off

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.die()
		print_debug("Entered body")

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.die()
		print_debug("entered area")
