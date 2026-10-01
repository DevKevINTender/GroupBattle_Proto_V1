extends Node

export(Resource) var grid_model
export(Resource) var selection_channel
export(Resource) var unit_move_model # Сюда перетаскиваем тот же unit_move_model.tres

var highlighted_positions: Array = [] # Храним Vector2 позиции

func _ready():
	if selection_channel:
		selection_channel.connect("unit_selected", self, "_on_unit_selected")
		selection_channel.connect("unit_deselected", self, "_on_unit_deselected")
		
	# ПОДПИСЫВАЕМСЯ НА КАНАЛ ПЕРЕМЕЩЕНИЯ
	if unit_move_model:
		unit_move_model.connect("unit_movement_started", self, "_on_unit_movement_started")

func _on_unit_selected(unit_node: Node2D) -> void:
	clear_highlight()
	print("AttackRangeVisualizer: получен сигнал - юнит выбран")

	for offset in unit_node.attack_pattern:
		set_highlight(unit_node, offset)

func set_highlight(unit_node: Node2D, offset: Vector2):
	var target_pos = unit_node.grid_position + offset
	if grid_model.is_position_inside_bounds(target_pos):
		var cell_node = grid_model.get_cell(target_pos)
		if cell_node and cell_node.has_method("set_highlight"):
			var color = Color(1.5, 0.4, 0.4, 1.0)
			cell_node.set_highlight(true, color) 
			highlighted_positions.append(target_pos)

func _on_unit_deselected(_unit_node) -> void:
	clear_highlight()

# Срабатывает мгновенно в начале движения юнита
func _on_unit_movement_started(_unit_node, _from_pos):
	clear_highlight()

func clear_highlight() -> void:
	for pos in highlighted_positions:
		var cell_node = grid_model.get_cell(pos)
		if is_instance_valid(cell_node) and cell_node.has_method("set_highlight"):
			cell_node.set_highlight(false)
	highlighted_positions.clear()
