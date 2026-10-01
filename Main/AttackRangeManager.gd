extends Node2D

export(PackedScene) var indicator_scene
export(PackedScene) var rotate_panel_scene
export(Resource) var grid_model
export(Resource) var selection_channel
export(Resource) var unit_move_model

var _active_indicators: Dictionary = {}
var rotate_panel_obj
var cell_size
	
func _ready():
	cell_size = grid_model.cell_size
	
	if selection_channel:
		selection_channel.connect("unit_selected", self, "_on_unit_selected")
		selection_channel.connect("unit_deselected", self, "_on_unit_deselected")
		selection_channel.connect("change_direction_requested", self, "_on_change_rotate_requested")
		
	if unit_move_model:
		unit_move_model.connect("unit_movement_started", self, "_on_unit_movement_started")

func _on_change_rotate_requested(unit_node):
	var unit_atack_comp = _get_component(unit_node, AttackComponent) as AttackComponent
	unit_atack_comp.change_atack_direction()
	_show_indicators(unit_node)

func _on_unit_deselected(_unit_node) -> void:
	_clear_indicators()
	_hide_rotate_panel()


func _on_unit_movement_started(_unit_node, _from_pos):
	selection_channel.deselect_unit()


func _on_unit_selected(unit_node: Node2D) -> void:
	_show_rotate_panel(unit_node)
	_show_indicators(unit_node)
	
	
func _show_indicators(unit_node: Node2D):
	var component = _get_component(unit_node, AttackComponent)
	if component == null: 
		return
		
	_clear_indicators()
	print("AttackRangeVisualizer: получен сигнал - юнит выбран")
	var rotation_angle = Vector2.LEFT.angle_to(component.attack_direction)
	for offset in component.attack_pattern:
		var rotated_offset = offset.rotated(rotation_angle)
		rotated_offset = rotated_offset.round()
		_create_indicators_for(unit_node, rotated_offset)


func _create_indicators_for(unit_node: Node2D, offset: Vector2):
	var target_pos = unit_node.global_position + offset * cell_size 
	print(name, "создает индиктор в ", target_pos)
	var indicator = indicator_scene.instance()
	self.add_child(indicator)
	indicator.global_position = target_pos
	_active_indicators[target_pos] = indicator


func _show_rotate_panel(unit_node: Node2D):
	var component = _get_component(unit_node, RotateComponent)
	if component == null: 
		return
	
	_hide_rotate_panel()
	rotate_panel_obj = rotate_panel_scene.instance()
	unit_node.add_child(rotate_panel_obj)
	rotate_panel_obj.rect_position = Vector2.ZERO


func _hide_rotate_panel():
	if is_instance_valid(rotate_panel_obj):
		rotate_panel_obj.queue_free()	


func _clear_indicators():
	for grid_pos in _active_indicators.keys():
		var indicator = _active_indicators[grid_pos]
		if is_instance_valid(indicator):
			indicator.queue_free()
	_active_indicators.clear()


func _get_component(node: Node, type: Script) -> Node:
	var component = null
	
	for child in node.get_children():
		if child is type:
			component = child
			break
			
	return component
