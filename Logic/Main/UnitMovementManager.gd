extends Node
class_name UnitMovementManager

export(Resource) var grid_model      
export(Resource) var unit_grid_model 
export(Resource) var selection_model

export(NodePath) var indicator_manager_path
onready var indicator_manager = get_node_or_null(indicator_manager_path)

func _ready():
	# СТАРЫЙ КОД УДАЛЕН: grid_model.connect("cell_clicked", ...) больше не нужен для движения!
	
	if selection_model:
		selection_model.clear()
		selection_model.connect("unit_selected", self, "_on_unit_selected")
		selection_model.connect("unit_deselected", self, "_on_unit_deselected")
		
	# ПОДКЛЮЧАЕМСЯ К ИНДИКАТОРАМ
	if indicator_manager:
		indicator_manager.connect("indicator_selected", self, "_on_indicator_cell_clicked")

func _on_unit_selected(unit_node):
	unit_node.modulate = Color(1.3, 1.3, 1.3, 1.0) 

func _on_unit_deselected(unit_node):
	if is_instance_valid(unit_node):
		unit_node.modulate = Color(1, 1, 1, 1)

# НОВЫЙ ОБРАБОТЧИК КЛИКА: срабатывает только при нажатии на зеленую клетку-индикатор
func _on_indicator_cell_clicked(grid_pos: Vector2):
	print(name, ": клик по индикатору на позиции ", grid_pos)
	
	if not selection_model or selection_model.selected_unit == null:
		return

	# Находим саму ноду клетки, чтобы перенести туда юнит физически
	var cell_node = grid_model.get_cell(grid_pos)
	if cell_node:
		_on_unit_deselected(selection_model.selected_unit)
		_move_unit_to(selection_model.selected_unit, cell_node)

# ФИЗИЧЕСКИЙ ПЕРЕНОС ЮНИТА
func _move_unit_to(unit_node: Node2D, target_cell: Object) -> void:
	if indicator_manager and indicator_manager.has_method("clear_indicators"):
		indicator_manager.clear_indicators()
		
	selection_model.clear()
	
	var old_cell = grid_model.get_cell(unit_node.grid_position)
	if old_cell:
		old_cell.remove_child(unit_node)
		
	target_cell.add_child(unit_node)
	unit_node.position = Vector2.ZERO 
	
	unit_node.grid_position = target_cell.grid_position
	print("Юнит успешно перемещен на: ", unit_node.grid_position)
