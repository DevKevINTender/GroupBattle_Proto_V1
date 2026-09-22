extends Node

export(Resource) var grid_model
export(Resource) var selection_channel

var highlighted_cells: Array = []

func _ready():
	selection_channel.connect("unit_selected", self, "_on_unit_selected")
	selection_channel.connect("unit_deselected", self, "_on_unit_deselected")

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
			highlighted_cells.append(cell_node)

func _on_unit_deselected(_unit_node) -> void:
	clear_highlight()

func clear_highlight() -> void:
	for cell in highlighted_cells:
		if is_instance_valid(cell) and cell.has_method("set_highlight"):
			cell.set_highlight(false)
	highlighted_cells.clear()
