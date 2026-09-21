# ClickableComponent.gd
extends Area2D
class_name ClickableComponent

# ЭКСПОРТ: Сюда перетаскиваем ActiveSelectionChannel.tres
export(Resource) var selection_channel

# Ссылка на родительский юнит, данные которого мы будем передавать в канал
onready var parent_unit = get_parent()

func _ready():
	# Принудительно проверяем настройки, чтобы избежать глупых багов в редакторе
	input_pickable = true
	
	if not selection_channel:
		push_error("ВНИМАНИЕ: На узле %s внутри %s не подключен ActiveSelectionChannel.tres!" % [name, parent_unit.name])

func _on_input_event(_viewport, event, _shape_idx):
	# Проверяем клик левой кнопкой мыши
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if selection_channel and is_instance_valid(parent_unit):
			# Передаем в канал выделения именно САМОГО ЮНИТА (родителя), а не компонент
			selection_channel.focus_unit(parent_unit)
			print("SelectionComponent: юнит выбран")
