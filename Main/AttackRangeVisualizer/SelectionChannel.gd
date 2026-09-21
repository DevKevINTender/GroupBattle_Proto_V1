# SelectionChannel.gd
extends Resource
class_name SelectionChannel

signal unit_focused(unit_node)
signal unit_unfocused(unit_node)

var focused_unit: Node2D = null

func focus_unit(unit_node: Node2D) -> void:
	unfocus_current()
	
	focused_unit = unit_node
	emit_signal("unit_focused", unit_node)

func unfocus_current() -> void:
	if is_instance_valid(focused_unit):
		emit_signal("unit_unfocused", focused_unit)
	focused_unit = null
