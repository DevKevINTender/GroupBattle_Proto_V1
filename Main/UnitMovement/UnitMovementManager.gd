extends Node
class_name UnitMovementManager

export(Resource) var grid_model       # MainGridModel.tres (только клетки)
export(Resource) var unit_grid_model # unit_grid_model.tres (только юниты)
export(Resource) var movement_channel # ActiveMovementChannel.tres (выделенный юнит)

func _ready():
	if grid_model:
		grid_model.connect("cell_clicked", self, "_on_cell_clicked")
	else:
		push_error("UnitMovementManager: Grid Model не подключен")
		
	if movement_channel:
		movement_channel.clear()
		movement_channel.connect("unit_selected", self, "_on_unit_selected")
		movement_channel.connect("unit_deselected", self, "_on_unit_deselected")
	else:
		push_error("UnitMovementManager: Movement Channel не подключен")

func _on_unit_selected(unit_node):
	unit_node.modulate = Color(1.3, 1.3, 1.3, 1.0) 

func _on_unit_deselected(unit_node):
	if is_instance_valid(unit_node):
		unit_node.modulate = Color(1, 1, 1, 1)

# ОБРАБОТКА КЛИКА (Сигнал прилетает из модели сетки)
func _on_cell_clicked(grid_pos: Vector2):
	print("UnitMovementManager: сигнал получен - нажатие на клетку")
	# Если никто не выбран — игнорируем
	if not movement_channel or movement_channel.selected_unit == null:
		return
		
	# 1. Проверяем границы через модель сетки
	if not grid_model or not grid_model.is_position_inside_bounds(grid_pos):
		return
		
	# 2. МЕНЕДЖЕР САМ ПРОВЕРЯЕТ ПРЕПЯТСТВИЕ: заглядывает в ресурс юнитов
	if unit_grid_model:
		var obstacle_unit = unit_grid_model.get_unit_at(grid_pos)
		if obstacle_unit != null and is_instance_valid(obstacle_unit):
			print("UnitMovementManager: Клетка ", grid_pos, " занята юнитом ", obstacle_unit.name)
			return

	# Находим саму ноду клетки, чтобы перенести туда юнит физически
	var cell_node = grid_model.get_cell(grid_pos)
	if cell_node:
		_on_unit_deselected(movement_channel.selected_unit)
		_move_unit_to(movement_channel.selected_unit, cell_node)

# ФИЗИЧЕСКИЙ ПЕРЕНОС ЮНИТА
func _move_unit_to(unit_node: Node2D, target_cell: Object) -> void:
	movement_channel.clear()
	
	# Убираем из старого родителя
	var old_cell = grid_model.get_cell(unit_node.grid_position)
	if old_cell:
		old_cell.remove_child(unit_node)
		
	# Переносим в новую клетку
	target_cell.add_child(unit_node)
	unit_node.position = Vector2.ZERO 
	
	# Меняем логическую позицию (BattleGridData мгновенно увидит изменения)
	unit_node.grid_position = target_cell.grid_position
	
	print("Юнит успешно перемещен на: ", unit_node.grid_position)
