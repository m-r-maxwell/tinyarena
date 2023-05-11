extends Node

@export var end_screen_scene: PackedScene

func _ready():
	$%Player.health_component.died.connect(on_player_died)


func on_player_died():
	var end_screne_instance = end_screen_scene.instantiate()
	add_child(end_screne_instance)
	end_screne_instance.set_defeat() #this has to be in the scene tree before we can do this
