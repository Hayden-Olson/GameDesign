extends Area2D
 
var direction = 1
@export var SPEED := 200.0
var last_wall = null
 
var level = 0
const ENEMY = preload("res://enemy_1.tscn")
var max_enemy_limit = 160
var enemy_list = []
 
# Spawn queue and timer
var spawn_queue = []
var spawn_timer = 0.0
const SPAWN_INTERVAL = 0.5
 
# Build the column order for center-outward fill (starts at col index 7 = Position8)
# Pattern: 8, 9, 7, 10, 6, 11, 5, 12, 4, 13, 3, 14, 2, 15, 1, 16
func _get_column_order() -> Array:
	var order = []
	var left = 7   # 0-indexed, Position8
	var right = 8  # 0-indexed, Position9
	order.append(left)
	while right < 16:
		order.append(right)
		right += 1
		if left > 0:
			left -= 1
			order.append(left)
	return order
 
# Kickstarts the code starting with level up.
func _ready() -> void:
	level_up()
 
func _physics_process(delta: float) -> void:
	position.x += direction * SPEED * delta
 
	# Handle staggered spawning from the queue
	if spawn_queue.size() > 0:
		spawn_timer -= delta
		if spawn_timer <= 0.0:
			spawn_timer = SPAWN_INTERVAL
			_spawn_next_in_queue()
 
# Handles the movement detection of the cluster so they bounce off the walls.
func _on_area_entered(body):
	if body != last_wall:
		direction *= -1
		last_wall = body
 
#This function pops the front of the enemy queue and adds them to the grid index.
func _spawn_next_in_queue() -> void:
	if spawn_queue.size() == 0:
		return
	var grid_index = spawn_queue.pop_front()
	_spawn_enemy_at_index(grid_index)
 
# Grid index is then passed here to figure out where the current enemy should spawn in the grid.
func _spawn_enemy_at_index(grid_index: int) -> void:
	if enemy_list.size() >= max_enemy_limit:
		return
 
	var column_order = _get_column_order()
	var row = grid_index / 16          # 0-indexed row
	var col_slot = grid_index % 16     # position within column order
	var col = column_order[col_slot]   # actual 0-indexed column
 
	var row_node = get_node("Row%d" % (row + 1))
	var position_node = row_node.get_node("Position%d" % (col + 1))
 
	var new_enemy = ENEMY.instantiate()
	get_tree().current_scene.add_child(new_enemy)
	enemy_list.append(new_enemy)
	new_enemy.set_cluster_position(position_node, self)
 
# This function ensures the spawn queue and enemy list are empty before leveling up.
func remove_enemy(enemy) -> void:
	enemy_list.erase(enemy)
	if enemy_list.size() == 0 and spawn_queue.size() == 0:
		level_up()
 
# Adds to the level
func level_up() -> void:
	level += 1
	var enemies_to_spawn = min(30 + (level - 1) * 2, max_enemy_limit)
	spawn_queue.clear()
	for i in range(enemies_to_spawn):
		spawn_queue.append(i)
	spawn_timer = 0.0  # Spawn first enemy immediately
