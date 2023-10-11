extends CanvasLayer
@onready var panel = %PanelContainer

var options = preload("res://scenes/ui/options_menu.tscn")

var is_closing

func _ready():
	get_tree().paused = true
	panel.pivot_offset = panel.size / 2
	
	$%ResumeButton.pressed.connect(on_resume_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)
	
	$AnimationPlayer.play("default")
	var tween = create_tween()
	tween.tween_property(panel, "scale", Vector2.ZERO, .0)
	tween.tween_property(panel, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func on_resume_pressed():
	closed()

func on_options_pressed():
	var options_scene_instance = options.instantiate()
	add_child(options_scene_instance)
	options_scene_instance.back_pressed.connect(on_options_back_pressed.bind(options_scene_instance))
	
func on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		closed()
		get_tree().root.set_input_as_handled()
	
		
func closed():
	if is_closing:
		return
	is_closing = true
	$AnimationPlayer.play_backwards("default")
	var tween = create_tween()
	
	tween.tween_property(panel, "scale", Vector2.ONE, .0)
	tween.tween_property(panel, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()


func on_options_back_pressed(options_menu: Node):
	options_menu.queue_free()
