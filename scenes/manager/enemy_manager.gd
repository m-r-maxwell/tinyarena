extends Node

const SPAWN_RADIUS = 375 #viewport half + 10

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_timer = 0
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_timer = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO

	var spawn_pos = Vector2.ZERO
	var rand_dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_pos = player.global_position + (rand_dir * SPAWN_RADIUS)
		#ray cast collision  // pass in the bit value and can bitwise shift
		var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_pos, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
		#if null we are clear
		if result.is_empty():
			break
		else:
			rand_dir = rand_dir.rotated(deg_to_rad(90))
	return spawn_pos

func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D #programatically create a node
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1 / 12) * arena_difficulty
	time_off = min(time_off, .7)
	print(time_off)
	timer.wait_time = base_spawn_timer - time_off
	
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)
