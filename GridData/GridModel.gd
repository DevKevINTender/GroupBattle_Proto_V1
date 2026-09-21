extends Resource
class_name GridDataResource

export(int) var width = 4
export(int) var height = 4

# Сигнал, на который подпишется менеджер перемещений
signal cell_clicked(grid_pos)

# Словарь { Vector2: Нода_Клетки }
var cells = {}

func clear_data() -> void:
	cells.clear()

## Метод для самостоятельной регистрации клеток
func register_cell(grid_pos: Vector2, cell_node: Node) -> void:
	cells[grid_pos] = cell_node
	print("Сетка: Клетка зарегистрирована на ", grid_pos)

## Метод для отмены регистрации (на случай смены сцены/удаления)
func unregister_cell(grid_pos: Vector2) -> void:
	if cells.has(grid_pos):
		cells.erase(grid_pos)

func get_cell(grid_pos: Vector2) -> Node:
	if cells.has(grid_pos):
		return cells[grid_pos]
	return null

## Модель сетки теперь проверяет ТОЛЬКО границы поля. 
## Она больше ничего не знает про юнитов!
func is_position_inside_bounds(grid_pos: Vector2) -> bool:
	return grid_pos.x >= 0 and grid_pos.x < width and grid_pos.y >= 0 and grid_pos.y < height
