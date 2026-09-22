extends Resource
class_name UnitMoveModel

# Сигнал отправляется, когда юнит НАЧИНАЕТ движение (для мгновенной очистки интерфейса)
signal unit_movement_started(unit_node, from_pos)

# Сигнал отправляется, когда юнит ЗАВЕРШИЛ движение (для обновления графики, атак и т.д.)
signal unit_movement_finished(unit_node, to_pos)
