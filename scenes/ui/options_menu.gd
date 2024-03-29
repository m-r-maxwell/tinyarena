extends CanvasLayer

signal back_pressed

@onready var window_button: Button = $%WindowButton
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var back_button = $%BackButton

func _ready():
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	update_display()
	
	
	
func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)
	
	
func get_bus_volume_percent(bus_name: String):
	var bIndex = AudioServer.get_bus_index(bus_name)
	var volume = AudioServer.get_bus_volume_db(bIndex)
	return db_to_linear(volume)
	
	
func set_bus_volume_percent(bus_name: String, percent: float):
	var bIndex = AudioServer.get_bus_index(bus_name)
	var volume = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bIndex, volume)
	
	

func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Full Screen"
		
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")
	
func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	update_display()


func on_back_pressed():
#	ScreenTransition.transition()
#	await ScreenTransition.transition_halfway
	back_pressed.emit()
