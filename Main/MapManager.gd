# MapManager.gd
extends Node

export(PackedScene) var cell_scene
export(Resource) var grid_model

export(int) var cell_size = 100
export(int) var spacing = 4

func _ready():
	if grid_model and grid_model:
		generate_map()

func generate_map() -> void:
	grid_model.clear_data()
	
	var total_width = grid_model.width * cell_size + (grid_model.width - 1) * spacing
	var total_height = grid_model.height * cell_size + (grid_model.height - 1) * spacing
	

	var offset_x = -total_width / 2.0 + (cell_size / 2.0)
	var offset_y = -total_height / 2.0 + (cell_size / 2.0)
	
	for x in range(grid_model.width):
		for y in range(grid_model.height):
			var cell_instance = cell_scene.instance()

			
			# Позиционирование с учетом смещения к центру (0,0)
			var pos_x = offset_x + (x * (cell_size + spacing))
			var pos_y = offset_y + (y * (cell_size + spacing))
			cell_instance.position = Vector2(pos_x, pos_y)
			
			var grid_pos = Vector2(x, y)
			cell_instance.grid_position = grid_pos
			
			add_child(cell_instance)
