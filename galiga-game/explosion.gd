extends Sprite2D
@onready var audio = $Audio
@export var die_sound : AudioStream
# Directly in the script of the object to be destroyed
func _ready():
	audio.play()
	$AnimationPlayer.play("Explode")
	
	await get_tree().create_timer(0.5).timeout
	queue_free()
