extends TextureButton

# ЭКСПОРТ: Перетащите сюда файл turn_model.tres в инспекторе кнопки
export(Resource) var turn_model

func _ready():
	# Подключаем стандартный сигнал кнопки "pressed" к самой себе
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	if turn_model:
		# Дергаем метод в ресурсе, который разошлет сигнал дальше
		turn_model.request_next_turn()
	else:
		push_error("ВНИМАНИЕ: Забыли перетащить файл turn_model.tres в инспектор кнопки!")
