# MovementChannel.gd
extends Resource
class_name MovementChannel

signal unit_selected(unit_node)
signal unit_deselected(unit_node) # Новый сигнал отмены

var selected_unit: Node2D = null

func select_unit(unit_node: Node2D) -> void:
	selected_unit = unit_node
	emit_signal("unit_selected", unit_node)

# Метод для очистки с отправкой сигнала
func deselect_unit() -> void:
	if is_instance_valid(selected_unit):
		emit_signal("unit_deselected", selected_unit)
	selected_unit = null

func clear() -> void:
	selected_unit = null
