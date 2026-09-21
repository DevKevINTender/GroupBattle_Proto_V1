# UnitCard.gd
extends TextureButton

# Сигнал, который карточка шлет менеджеру при клике на нее
signal card_selected(card_node)

export(String) var unit_id = "knight"
export(PackedScene) var unit_scene # Сцена самого юнита (Unit.tscn), который будет спавниться на поле

var is_deployed: bool = false # Находится ли юнит сейчас на поле
var spawned_unit_ref: Node2D = null # Ссылка на живого юнита на поле

func _ready():
	# Подключаем встроенный сигнал нажатия кнопки к собственному методу
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	emit_signal("card_selected", self)

func _on_unit_destroyed():
	# Сбрасываем статус карточки, так как юнита больше нет на поле
	spawned_unit_ref = null
	set_deployed(false)
	print("Карточка ", unit_id, " зафиксировала гибель юнита и вернулась в запас.")

# Визуальное изменение карточки в зависимости от статуса
func set_deployed(deployed: bool) -> void:
	is_deployed = deployed
	if is_deployed:
		modulate = Color(0.5, 0.5, 0.5, 1) # Затемняем карточку (юнит на поле)
	else:
		modulate = Color(1, 1, 1, 1) # Возвращаем обычный цвет (юнит в запасе)

