extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 15

@export var dagger_ability_scene: PackedScene

var dagger_count = 0

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrrade_added.connect(on_ability_upgrade_added)
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_rotation_degrees = 360.0 / (dagger_count + 1)
	for i in dagger_count + 1:
		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degrees))
		var spawn_pos = player.global_position +  (adjusted_direction * randf_range(0, BASE_RANGE))
		var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_pos, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
		if !result.is_empty():
			spawn_pos = result["position"]
		var dagger_ability = dagger_ability_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(dagger_ability)
		dagger_ability.global_position = spawn_pos
		dagger_ability.hit_box_component.damage = BASE_DAMAGE


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "dagger_amount":
		dagger_count = current_upgrades["dagger_amount"]["quantity"]
		
