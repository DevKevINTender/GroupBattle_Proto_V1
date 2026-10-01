extends Node2D
class_name Unit

export(String) var unit_id
export(Resource) var unit_grid_model
export(NodePath) var hp_component_path
export(Vector2) var grid_position = Vector2.ZERO

var hp_component: HpComponent
var creator_card : Node2D


func _ready():
	unit_grid_model.register_unit(self)
	hp_component = get_node(hp_component_path)
	hp_component.connect("unit_died", self, "_unit_die")

func _unit_die():
	unit_grid_model.unregister_unit(self)
	queue_free()



