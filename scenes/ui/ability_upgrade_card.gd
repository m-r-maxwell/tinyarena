extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel

signal selected

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	scale = Vector2.ZERO 
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")


func play_discard():
	$SelectedAnimationPlayer.play("discard")
	
func select_card():
	disabled = true
	$SelectedAnimationPlayer.play("selected")
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $SelectedAnimationPlayer.animation_finished
	selected.emit()
		

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent):
	if disabled:
		return
	#input mapping in settings to check based on name instead of key click
	if event.is_action_pressed("left_click"):
		select_card()

func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
