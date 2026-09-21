extends Node2D
class_name Unit

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
export(Resource) var grid_data
export(String) var unit_id
var creator_card : Node2D

func _ready():
	# Безопасно проверяем, не забыли ли перетащить ресурс в инспекторе
	if grid_data:
		grid_data.register_unit(self)
	else:
		push_error("ВНИМАНИЕ: Забыли перетащить файл battle_grid_data.tres в инспектор юнита " + name)

## Метод получения урона
func take_damage(amount: int) -> void:
	current_hp -= amount
	print(name, " получил ", amount, " урона. Осталось HP: ", current_hp, "/", max_hp)
	
	if current_hp <= 0:
		die()

## Логика смерти юнита
func die() -> void:
	print(name, " погиб!")
	if grid_data:
		grid_data.unregister_unit(self)
	queue_free() 
