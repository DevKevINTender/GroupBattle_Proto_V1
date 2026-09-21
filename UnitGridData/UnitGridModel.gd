extends Resource
class_name BattleGridData

# Вместо словаря теперь используем простой массив
export(Array) var units_list: Array = []

## Добавить юнита в общий список
func register_unit(unit) -> void:
	if not units_list.has(unit):
		units_list.append(unit)
		print("Ресурс: Зарегистрирован ", unit.name)

## Удалить юнита из общего списка
func unregister_unit(unit) -> void:
	if units_list.has(unit):
		units_list.erase(unit)
		print("Ресурс: Удален ", unit.name)

## Ищем юнита, опрашивая их актуальные позиции на лету
func get_unit_at(cell: Vector2):
	for unit in units_list:
		# Проверяем, жива ли нода и совпадает ли её текущая позиция
		if is_instance_valid(unit) and unit.grid_position == cell:
			return unit
	return null

## Возвращает копию массива всех живых юнитов для менеджера боя
func get_all_units() -> Array:
	var alive_units = []
	for unit in units_list:
		if is_instance_valid(unit):
			alive_units.append(unit)
	return alive_units
