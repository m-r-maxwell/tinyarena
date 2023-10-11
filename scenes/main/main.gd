extends Node

@export var end_screen_scene: PackedScene

var pause_menu = preload("res://scenes/ui/pause_menu.tscn")

func _ready():
	$%Player.health_component.died.connect(on_player_died)


func on_player_died():
	var end_screne_instance = end_screen_scene.instantiate()
	add_child(end_screne_instance)
	end_screne_instance.set_defeat() #this has to be in the scene tree before we can do this

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu.instantiate())
		get_tree().root.set_input_as_handled()
