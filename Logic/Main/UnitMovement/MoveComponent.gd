extends Area2D

export(Resource) var movement_channel 

onready var parent_unit = get_parent()

func _ready():
	input_pickable = true

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if movement_channel.selected_unit == parent_unit:
			movement_channel.deselect_unit()
			print("MoveComponent: Выделение с юнита снято.")
		
		else:
			if movement_channel.selected_unit != null:
				movement_channel.deselect_unit()
				
			movement_channel.select_unit(parent_unit)
			print("MoveComponent: Юнит выбран.")
