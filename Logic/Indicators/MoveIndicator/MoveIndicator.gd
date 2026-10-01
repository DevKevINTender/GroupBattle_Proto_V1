extends Area2D
class_name MoveIndicator

# Переменная, в которую менеджер запишет координаты этой клетки
var grid_position: Vector2 = Vector2.ZERO

# Сигнал, который активируется при клике на индикатор
signal indicator_clicked(pos)

func _ready():
	# Подключаем встроенный сигнал Godot для отслеживания мыши
	connect("input_event", self, "_on_input_event")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("indicator_clicked", grid_position)
