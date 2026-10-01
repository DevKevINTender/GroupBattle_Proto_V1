extends Node
class_name MoveIndicatorManager

# Сигнал, который слушает основной менеджер перемещения
signal indicator_selected(grid_pos)

export(PackedScene) var indicator_scene
export(Resource) var grid_model
export(Resource) var unit_grid_model
export(Resource) var selection_model
export(Resource) var unit_move_model # Сюда перетаскиваем unit_move_model.tres

var _active_indicators: Dictionary = {}

func _ready():
	if selection_model:
		selection_model.connect("unit_selected", self, "_on_unit_selected")
		selection_model.connect("unit_deselected", self, "_on_unit_deselected")
		
	# ПОДПИСЫВАЕМСЯ НА НАЧАЛО ДВИЖЕНИЯ ЮНИТА
	if unit_move_model:
		unit_move_model.connect("unit_movement_started", self, "_on_unit_movement_started")

func _on_unit_selected(unit_node):
	clear_indicators()
	_create_indicators_for(unit_node)

func _on_unit_deselected(_unit_node):
	clear_indicators()

# Срабатывает мгновенно, когда UnitMovementManager дает команду идти
func _on_unit_movement_started(_unit_node, _from_pos):
	clear_indicators()

func _create_indicators_for(unit_node):
	if not grid_model or not indicator_scene:
		return
		
	for x in range(grid_model.width):
		for y in range(grid_model.height):
			var check_pos = Vector2(x, y)
			if check_pos == unit_node.grid_position:
				continue
			if unit_grid_model and unit_grid_model.get_unit_at(check_pos) != null:
				continue
				
			_spawn_indicator_at(check_pos)

func _spawn_indicator_at(grid_pos: Vector2):
	var cell_node = grid_model.get_cell(grid_pos)
	if cell_node:
		var indicator = indicator_scene.instance()
		cell_node.add_child(indicator)
		
		if "position" in indicator:
			indicator.position = Vector2.ZERO
			
		if "grid_position" in indicator:
			indicator.grid_position = grid_pos
			
		if indicator.has_signal("indicator_clicked"):
			indicator.connect("indicator_clicked", self, "_on_indicator_clicked")
			
		_active_indicators[grid_pos] = indicator

func _on_indicator_clicked(grid_pos: Vector2):
	emit_signal("indicator_selected", grid_pos)

func clear_indicators():
	for grid_pos in _active_indicators.keys():
		var indicator = _active_indicators[grid_pos]
		if is_instance_valid(indicator):
			indicator.queue_free()
	_active_indicators.clear()
