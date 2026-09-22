extends Area2D

export(Resource) var selection_model 

onready var parent_unit = get_parent()

func _ready():
	input_pickable = true

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if selection_model.selected_unit == parent_unit:
			selection_model.deselect_unit()
			print(name,": Выделение с юнита снято.")
		
		else:
			if selection_model.selected_unit != null:
				selection_model.deselect_unit()
				
			selection_model.select_unit(parent_unit)
			print(name,": Юнит выбран.")
