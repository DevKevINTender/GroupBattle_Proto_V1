extends Node2D

export(PackedScene) var indicator_scene
export(Resource) var grid_model
export(Resource) var selection_channel
export(Resource) var unit_move_model # Сюда перетаскиваем тот же unit_move_model.tres

var _active_indicators: Dictionary = {}

func _ready():
	if selection_channel:
		selection_channel.connect("unit_selected", self, "_on_unit_selected")
		selection_channel.connect("unit_deselected", self, "_on_unit_deselected")
		
	# ПОДПИСЫВАЕМСЯ НА КАНАЛ ПЕРЕМЕЩЕНИЯ
	if unit_move_model:
		unit_move_model.connect("unit_movement_started", self, "_on_unit_movement_started")


func _on_unit_deselected(_unit_node) -> void:
	clear_indicators()


func _on_unit_movement_started(_unit_node, _from_pos):
	selection_channel.deselect_unit()


func _on_unit_selected(unit_node: Node2D) -> void:
	var component = null
	
	for child in unit_node.get_children():
		if child is AttackComponent:
			component = child
	
	if component == null: 
		return
		
	clear_indicators()
	print("AttackRangeVisualizer: получен сигнал - юнит выбран")
	var cell_size = grid_model.cell_size
	for offset in component.attack_pattern:
		_create_indicators_for(unit_node, offset, cell_size)


func _create_indicators_for(unit_node: Node2D, offset: Vector2, cell_size: int):
	var target_pos = unit_node.global_position + offset * cell_size 
	print(name, "создает индиктор в ", target_pos)
	var indicator = indicator_scene.instance()
	self.add_child(indicator)
	var world_pos = (target_pos) - Vector2(cell_size / 2, cell_size / 2)
	
	indicator.global_position = target_pos
	_active_indicators[target_pos] = indicator


func clear_indicators():
	for grid_pos in _active_indicators.keys():
		var indicator = _active_indicators[grid_pos]
		if is_instance_valid(indicator):
			indicator.queue_free()
	_active_indicators.clear()
