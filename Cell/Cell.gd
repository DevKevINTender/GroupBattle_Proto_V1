extends Area2D
class_name Cell

export(Vector2) var grid_position = Vector2.ZERO

# ЭКСПОРТ: Перетаскиваем сюда MainGridModel.tres
export(Resource) var grid_model

func _ready():
	grid_model.register_cell(grid_position, self)

func _exit_tree():
	if grid_model:
		grid_model.unregister_cell(grid_position)

# Ловим клик мыши по клетке (через Area2D или Control/TextureButton внутри клетки)
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("Cell: Нажатие по клетке")
		if grid_model:
			# Клетка напрямую шлет сигнал в модель!
			grid_model.emit_signal("cell_clicked", grid_position)


## Метод включает или выключает подсветку клетки (например, делает её красноватой)
func set_highlight(is_visible: bool, color: Color = Color(1, 0.5, 0.5, 1)) -> void:
	if is_visible:
		modulate = color # Окрашиваем клетку (подберите нужный цвет)
		
	else:
		modulate = Color(1, 1, 1, 1) # Возвращаем обычный цвет
		print("Cell: клетка подсвечена ", modulate)


