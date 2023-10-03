extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
@onready var damage_timer = $DamgerIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals

var number_colliding_bodies = 0
var base_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_timer.timeout.connect(on_damage_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var directon = movement_vector.normalized()
	velocity_component.accelerate_in_direction(directon)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1) #this sets the sprite to continue facing whatever what it was going
	
func get_movement_vector():
	var x_movent = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movent, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_timer.is_stopped():
		return
		
	health_component.damage(1)
	damage_timer.start()
	
	#print(health_component.current_health)


func update_health_display():
	health_bar.value = health_component.get_health_percent()

func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	
	
func on_damage_timer_timeout():
	check_deal_damage()


func on_health_changed():
	GameEvents.emit_player_damager()
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:	
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)
