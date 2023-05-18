extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

#this is a way to add a scene without adding it to the inspector, but
#this follows the hardcoded = bad ideaology because if this ever changes
#the string wont update
var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")

func _ready():
	area_entered.connect(on_area_entered)
	

func on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
		
	if health_component == null:
		return
	
	var hitbox_compoent = other_area as HitBoxComponent
	health_component.damage(hitbox_compoent.damage)
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(str(hitbox_compoent.damage))
