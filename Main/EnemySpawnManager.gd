# EnemySpawnManager.gd
extends Node
class_name EnemySpawnManager

# ТРИ РЕСУРСА (Они независимы друг от друга)
export(Resource) var grid_model           # MainGridModel.tres
export(Resource) var unit_grid_model     # unit_grid_model.tres
export(Resource) var current_level_config # Файл уровня, например Level1_Section1.tres

func _ready():
	# Ждем один кадр, чтобы все клетки на сцене успели выполниться в своих _ready()
	# и самостоятельно зарегистрироваться в grid_model
	yield(get_tree(), "idle_frame")
	
	if current_level_config and current_level_config is LevelConfiguration:
		spawn_enemies()

func spawn_enemies() -> void:
	if not grid_model:
		push_error("Grid Model не подключен к EnemySpawnManager!")
		return
		
	if not unit_grid_model:
		push_error("Battle Grid Data не подключен к EnemySpawnManager!")
		return
		
	print("Начало спавна врагов для Уровня ", current_level_config.level_index, " Секции ", current_level_config.section_index)
	
	for spawn_data in current_level_config.enemies_to_spawn:
		if not spawn_data or not spawn_data.enemy_scene:
			continue
			
		var coords = spawn_data.grid_position
		
		# 1. Проверяем границы поля через модель сетки
		if not grid_model.is_position_inside_bounds(coords):
			push_error("Ошибка спавна: клетки с координатами %s не существует на поле!" % str(coords))
			continue
			
		# 2. Проверяем занятость клетки напрямую через ресурс юнитов
		var existing_unit = unit_grid_model.get_unit_at(coords)
		if existing_unit != null and is_instance_valid(existing_unit):
			push_error("Ошибка спавна: клетка %s уже занята юнитом %s!" % [str(coords), existing_unit.name])
			continue
			
		# Находим саму ноду клетки, чтобы прикрепить к ней врага визуально
		var cell_node = grid_model.get_cell(coords)
		if cell_node:
			# Спавним врага
			var new_enemy = spawn_data.enemy_scene.instance()
			
			# Настраиваем логические данные ДО добавления в дерево сцены.
			# Это ОЧЕНЬ ВАЖНО: когда сработает add_child, внутри new_enemy вызовется _ready().
			# Если у врага внутри _ready() прописана саморегистрация в unit_grid_model,
			# он автоматически запишет себя туда по ПРАВИЛЬНЫМ координатам!
			if "grid_position" in new_enemy:
				new_enemy.grid_position = coords
			if "unit_id" in new_enemy:
				new_enemy.unit_id = spawn_data.enemy_id
				
			# Добавляем дочерним элементом к клетке и центрируем
			cell_node.add_child(new_enemy)
			new_enemy.position = Vector2.ZERO
			unit_grid_model.register_unit(new_enemy)
			print("Враг ", spawn_data.enemy_id, " успешно размещен на клетке: ", coords)
		else:
			push_error("Критическая ошибка: Нода клетки %s есть в модели, но отсутствует на сцене!" % str(coords))
