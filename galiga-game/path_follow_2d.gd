extends PathFollow2D

var speed = 100

func _process(delta):
	# Increase the progress along the path over time
	# 'offset' property is used in older Godot versions. In modern Godot, use 'progress' or 'progress_ratio'.
	# 'progress' uses pixels/units as distance.
	# 'progress_ratio' uses a range from 0.0 to 1.0 (start to end).
	self.progress += speed * delta
