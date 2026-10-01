extends Node
class_name UnitMovementManager

export(Resource) var grid_model      
export(Resource) var unit_grid_model 
export(Resource) var selection_model
export(Resource) var unit_move_model

export(NodePath) var indicator_manager_path

func _ready():
	if selection_model:
		selection_model.clear()
		selection_model.connect("unit_selected", self, "_on_unit_selected")
		selection_model.connect("unit_deselected", self, "_on_unit_deselected")
	
	var indicator_manager = get_node_or_null(indicator_manager_path)
	indicator_manager.connect("indicator_selected", self, "_on_indicator_cell_clicked")


func _on_unit_selected(unit_node):
	unit_node.modulate = Color(1.3, 1.3, 1.3, 1.0) 

func _on_unit_deselected(unit_node):
	if is_instance_valid(unit_node):
		unit_node.modulate = Color(1, 1, 1, 1)

func _on_indicator_cell_clicked(grid_pos: Vector2):
	var cell_node = grid_model.get_cell(grid_pos)
	_move_unit_to(selection_model.selected_unit, cell_node)


# ФИЗИЧЕСКИЙ ПЕРЕНОС ЮНИТА
func _move_unit_to(unit_node: Node2D, target_cell: Object) -> void:
	var old_pos = unit_node.grid_position
	
	unit_move_model.emit_signal("unit_movement_started", unit_node, old_pos)
	_on_unit_deselected(unit_node)
	selection_model.clear()
	
	# Смена родителя ноды
	var old_cell = grid_model.get_cell(old_pos)

	old_cell.remove_child(unit_node)	
	target_cell.add_child(unit_node)
	
	unit_node.position = Vector2.ZERO 
	
	# Меняем логическую позицию
	unit_node.grid_position = target_cell.grid_position
	
	# 2. ТРИГГЕР ЗАВЕРШЕНИЯ ХОДА: Оповещаем, что юнит встал на новую клетку
	if unit_move_model:
		unit_move_model.emit_signal("unit_movement_finished", unit_node, unit_node.grid_position)
		
	print("Юнит успешно перемещен на: ", unit_node.grid_position)
