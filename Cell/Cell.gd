extends Area2D
class_name Cell

export(Vector2) var grid_position = Vector2.ZERO

# ЭКСПОРТ: Перетаскиваем сюда MainGridModel.tres
export(Resource) var grid_model

func _ready():
	if grid_model:
		grid_model.register_cell(grid_position, self)
	else:
		push_error("ВНИМАНИЕ: Забыли привязать MainGridModel.tres к клетке на позиции " + str(grid_position))

func _exit_tree():
	if grid_model:
		grid_model.unregister_cell(grid_position)

# Ловим клик мыши по клетке (через Area2D или Control/TextureButton внутри клетки)
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("Нажатие по клетке")
		if grid_model:
			# Клетка напрямую шлет сигнал в модель!
			grid_model.emit_signal("cell_clicked", grid_position)
