extends Node

export(PackedScene) var indicator_scene
export(Resource) var grid_model
export(Resource) var selection_channel
export(Resource) var unit_move_model # Сюда перетаскиваем тот же unit_move_model.tres

var highlighted_positions: Array = [] # Храним Vector2 позиции
var _active_indicators: Dictionary = {}

func _ready():
	if selection_channel:
		selection_channel.connect("unit_selected", self, "_on_unit_selected")
		selection_channel.connect("unit_deselected", self, "_on_unit_deselected")
		
	# ПОДПИСЫВАЕМСЯ НА КАНАЛ ПЕРЕМЕЩЕНИЯ
	if unit_move_model:
		unit_move_model.connect("unit_movement_started", self, "_on_unit_movement_started")

func _on_unit_selected(unit_node: Node2D) -> void:
	clear_indicators()
	print("AttackRangeVisualizer: получен сигнал - юнит выбран")

	for offset in unit_node.attack_pattern:
		_create_indicators_for(unit_node, offset)

func _create_indicators_for(unit_node: Node2D, offset: Vector2):
	var target_pos = unit_node.grid_position + offset
	if grid_model.is_position_inside_bounds(target_pos):
		var cell_node = grid_model.get_cell(target_pos)
		_spawn_indicator_at(target_pos)
		

func _on_unit_deselected(_unit_node) -> void:
	clear_indicators()

# Срабатывает мгновенно в начале движения юнита
func _on_unit_movement_started(_unit_node, _from_pos):
	selection_channel.deselect_unit()


func _spawn_indicator_at(grid_pos: Vector2):
	var cell_node = grid_model.get_cell(grid_pos)
	if cell_node:
		var indicator = indicator_scene.instance()
		cell_node.add_child(indicator)
		
		if "position" in indicator:
			indicator.position = Vector2.ZERO
			
		if "grid_position" in indicator:
			indicator.grid_position = grid_pos
			
		_active_indicators[grid_pos] = indicator


func clear_indicators():
	for grid_pos in _active_indicators.keys():
		var indicator = _active_indicators[grid_pos]
		if is_instance_valid(indicator):
			indicator.queue_free()
	_active_indicators.clear()
