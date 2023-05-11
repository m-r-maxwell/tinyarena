extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel

signal selected

func _ready():
	gui_input.connect(on_gui_input)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent):
	#input mapping in settings to check based on name instead of key click
	if event.is_action_pressed("left_click"):
		selected.emit()
