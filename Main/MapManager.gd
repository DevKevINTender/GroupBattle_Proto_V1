# MapManager.gd
extends Node

export(PackedScene) var cell_scene
export(Resource) var grid_model



func _ready():
	if grid_model and grid_model:
		generate_map()

func generate_map() -> void:
	grid_model.clear_data()
	
	var cell_size = grid_model.cell_size
	var width = grid_model.width
	var height = grid_model.height
	
	var total_width = width * cell_size + (width - 1)
	var total_height = height * cell_size + (height - 1)
	

	var offset_x = -total_width / 2.0 + (cell_size / 2.0)
	var offset_y = -total_height / 2.0 + (cell_size / 2.0)
	
	for x in range(width):
		for y in range(height):
			var cell_instance = cell_scene.instance()

			
			# Позиционирование с учетом смещения к центру (0,0)
			var pos_x = offset_x + (x * cell_size)
			var pos_y = offset_y + (y * cell_size)
			cell_instance.position = Vector2(pos_x, pos_y)
			
			var grid_pos = Vector2(x, y)
			cell_instance.grid_position = grid_pos
			
			add_child(cell_instance)
