extends TextureButton

# ЭКСПОРТ: Перетащите сюда файл turn_model.tres в инспекторе кнопки
export(Resource) var turn_model

func _ready():
	# Подключаем стандартный сигнал кнопки "pressed" к самой себе
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	turn_model.request_next_turn()
