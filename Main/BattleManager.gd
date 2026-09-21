extends Node

# ЭКСПОРТЫ: Перетаскиваем оба .tres файла в инспекторе менеджера
export(Resource) var grid_data
export(Resource) var turn_model

func _ready():
	if not grid_data:
		push_error("ВНИМАНИЕ: Забыли перетащить файл battle_grid_data.tres в BattleManager!")
		
	if turn_model:
		# Подписываемся на сигнал из ресурса хода
		turn_model.connect("turn_requested", self, "_on_turn_requested")
	else:
		push_error("ВНИМАНИЕ: Забыли перетащить файл turn_model.tres в BattleManager!")

# Этот метод сработает, когда кнопка дернет сигнал в ресурсе
func _on_turn_requested():
	start_combat_round()

func start_combat_round():
	if not grid_data:
		return
		
	print("--- Начало раунда атак ---")
	
	var all_units = grid_data.get_all_units()
	print("Всего юнитов до сортировки: ", all_units.size())
	all_units.sort_custom(self, "_sort_by_initiative")
	
	print("Всего юнитов: ", all_units.size())
	
	for unit in all_units:
		if is_instance_valid(unit) and unit.current_hp > 0:
			_execute_unit_turn(unit)
			
	print("--- Конец раунда атак ---")

func _execute_unit_turn(attacker: Unit):
	var targets = _get_targets_for_unit(attacker)
	print("Юнит ", attacker, " нашел ", targets.size())
	if targets.empty():
		return
		
	for target in targets:
		if is_instance_valid(target) and target.current_hp > 0:
			print(attacker.name, " (Инициатива: ", attacker.initiative, ") атакует ", target.name)
			target.take_damage(attacker.attack_power)

func _get_targets_for_unit(attacker: Unit) -> Array:
	var found_targets = []
	for offset in attacker.attack_pattern:
		var target_cell = attacker.grid_position + offset
		
		if target_cell.x >= 0 and target_cell.x < 4 and target_cell.y >= 0 and target_cell.y < 4:
			var unit_on_cell = grid_data.get_unit_at(target_cell)
			if unit_on_cell != null and is_instance_valid(unit_on_cell) and unit_on_cell.team != attacker.team:
				found_targets.append(unit_on_cell)
				
	return found_targets

func _sort_by_initiative(unit_a, unit_b) -> bool:
	return unit_a.initiative > unit_b.initiative
