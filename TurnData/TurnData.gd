extends Resource
class_name TurnData

# Объявляем сигнал начала раунда
signal turn_requested

## Этот метод будет вызывать кнопка при нажатии
func request_next_turn() -> void:
	emit_signal("turn_requested")
