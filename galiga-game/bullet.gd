extends Area2D

var travelled_distance = 0
@export var speed = 1000
var range = 1200

func _physics_process(delta: float) -> void:
	var direction = -transform.y
	position += direction * speed * delta

	travelled_distance += speed * delta
	if travelled_distance > range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()

func die():
	queue_free()
