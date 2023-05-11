extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent


func _ready():
	area_entered.connect(on_area_entered)
	

func on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
		
	if health_component == null:
		return
	
	var hitbox_compoent = other_area as HitBoxComponent
	health_component.damage(hitbox_compoent.damage)
