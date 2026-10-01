extends Node2D
class_name HpComponent

enum Team { PLAYER, ENEMY }

signal unit_died

export(Team) var team = Team.PLAYER
export(int) var max_hp = 50
onready var current_hp = max_hp

func take_damage(amount: int) -> void:
	current_hp -= amount
	print(name, " получил ", amount, " урона. Осталось HP: ", current_hp, "/", max_hp)
	
	if current_hp <= 0:
		die()


func die() -> void:
	print(name, " погиб!")
	emit_signal("unit_died")


