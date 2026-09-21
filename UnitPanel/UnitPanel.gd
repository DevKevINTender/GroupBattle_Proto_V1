# UnitPanel.gd
extends Control

# ТРИ РЕСУРСА (Они независимы друг от друга)
export(Resource) var grid_model       # MainGridModel.tres
export(Resource) var battle_grid_data # battle_grid_data.tres

export(NodePath) var card_layout_path
onready var card_layout = get_node(card_layout_path)

func _ready():
	if not battle_grid_data:
		push_error("ВНИМАНИЕ: Забыли перетащить файл battle_grid_data.tres в инспектор UnitPanel!")
		
	# Подключаем клики от всех карточек в панели
	for card in card_layout.get_children():
		if card.has_signal("card_selected"):
			card.connect("card_selected", self, "_on_card_selected")

# ОБРАБОТКА КЛИКА ПО КАРТОЧКЕ
func _on_card_selected(card_node):
	if card_node.is_deployed:
		_remove_unit_from_field(card_node)
	else:
		_auto_deploy_unit(card_node)

# Автоматическое размещение в первый свободный слот
func _auto_deploy_unit(card_node):
	if not grid_model or not battle_grid_data:
		return

	var target_cell = null
	var target_pos = Vector2.ZERO

	# Ищем первую пустую клетку, опрашивая battle_grid_data вместо клеток
	for x in range(grid_model.width):
		for y in range(grid_model.height):
			var pos = Vector2(x, y)
			
			# Проверяем, свободна ли клетка по данным ресурса юнитов
			var existing_unit = battle_grid_data.get_unit_at(pos)
			if existing_unit == null or not is_instance_valid(existing_unit):
				target_cell = grid_model.get_cell(pos)
				target_pos = pos
				break # Нашли свободную клетку
		if target_cell:
			break

	# Если нашли свободное место — спавним
	if target_cell:
		var new_unit = card_node.unit_scene.instance()
		
		# ВАЖНО: Записываем координаты ДО добавления на сцену,
		# чтобы юнит в своем _ready() автоматически зарегистрировался по правильному адресу!
		new_unit.grid_position = target_pos
		
		if "unit_id" in new_unit:
			new_unit.unit_id = card_node.unit_id
		if "creator_card" in new_unit:
			new_unit.creator_card = card_node
		
		new_unit.connect("tree_exiting", card_node, "_on_unit_destroyed")
		# Добавляем на сцену внутрь клетки и центрируем
		target_cell.add_child(new_unit)
		new_unit.position = Vector2.ZERO 
		
		# Обновляем статус карточки
		card_node.spawned_unit_ref = new_unit
		card_node.set_deployed(true)
		print("Юнит автоматически размещен на позиции: ", target_pos)
	else:
		print("Нет свободных клеток на поле!")

# Удаление юнита с поля
func _remove_unit_from_field(card_node):
	var unit = card_node.spawned_unit_ref
	
	if is_instance_valid(unit):
		# Нам больше не нужно занулять cell.occupant! 
		# Мы просто вызываем die() или удаляем юнит. 
		# Если у вас в Unit.gd написан метод die(), лучше вызвать его. 
		# Если нет — пишем вызов queue_free(). Но так как мы удалили _exit_tree из Unit,
		# нужно убедиться, что юнит сам выпишется из базы данных.
		if unit.has_method("die"):
			unit.die() # Он сам выпишется из battle_grid_data и сделает queue_free()
		else:
			# Если метода die() нет, выписываем вручную перед удалением:
			battle_grid_data.unregister_unit(unit)
			unit.queue_free()
		
	# Сбрасываем статус карточки
	card_node.spawned_unit_ref = null
	card_node.set_deployed(false)
	print("Юнит убран с поля.")
