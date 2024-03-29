extends Node

#project settings -> auto load -> add the tscn file

signal experience_vial_collected(number: float)
signal ability_upgrrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrrade_added.emit(upgrade, current_upgrades) #relaying this

func emit_player_damager():
	player_damaged.emit()
