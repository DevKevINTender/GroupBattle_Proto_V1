extends Node2D
class_name Unit

export(Resource) var grid_data

signal unit_died

enum Team { PLAYER, ENEMY }

export(Team) var team = Team.PLAYER
export(Vector2) var grid_position = Vector2.ZERO
export(int) var initiative = 10
export(int) var attack_power = 10
export(Array, Vector2) var attack_pattern = [Vector2(1, 0)]

# Логика здоровья
export(int) var max_hp = 50
onready var current_hp = max_hp

# ЭКСПОРТ ДЛЯ ПЕРЕТЯГИВАНИЯ: теперь сюда в инспекторе можно перетащить файл .tres

export(String) var unit_id
var creator_card : Node2D

func _ready():
	grid_data.register_unit(self)


func take_damage(amount: int) -> void:
	current_hp -= amount
	print(name, " получил ", amount, " урона. Осталось HP: ", current_hp, "/", max_hp)
	
	if current_hp <= 0:
		die()


func die() -> void:
	print(name, " погиб!")
	emit_signal("unit_died")

	if grid_data:
		grid_data.unregister_unit(self)
	queue_free() 
