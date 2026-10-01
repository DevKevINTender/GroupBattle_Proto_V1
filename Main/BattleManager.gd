extends Node

# ЭКСПОРТЫ: Перетаскиваем оба .tres файла в инспекторе менеджера
export(Resource) var unit_grid_model
export(Resource) var turn_model

func _ready():
	if not unit_grid_model:
		push_error("ВНИМАНИЕ: Забыли перетащить файл battle_unit_grid_model.tres в BattleManager!")
		
	if turn_model:
		# Подписываемся на сигнал из ресурса хода
		turn_model.connect("turn_requested", self, "_on_turn_requested")
	else:
		push_error("ВНИМАНИЕ: Забыли перетащить файл turn_model.tres в BattleManager!")

# Этот метод сработает, когда кнопка дернет сигнал в ресурсе
func _on_turn_requested():
	start_combat_round()

func start_combat_round():
	print("--- Начало раунда атак ---")
	
	var all_units = unit_grid_model.get_all_units()
	print("Всего юнитов до сортировки: ", all_units.size())
#	all_units.sort_custom(self, "_sort_by_initiative")
	
	print("Всего юнитов: ", all_units.size())
	
	for unit in all_units:
		_execute_unit_turn(unit)
			
	print("--- Конец раунда атак ---")

func _execute_unit_turn(attacker: Unit):
	var targets = _get_targets_for_unit(attacker)
	print("Юнит ", attacker, " нашел ", targets.size())
	if targets.empty():
		return
		
	for target in targets:
		_attack_targets(target, attacker)

func _attack_targets(target: Unit, attacker: Unit):
	var target_hp_component = _get_component(target, HpComponent);
	var attacker_atack_component = _get_component(attacker, AttackComponent)
	if target_hp_component.current_hp > 0:
		print(attacker.name, " (Инициатива: ", attacker_atack_component.initiative, ") атакует ", target.name)
		target_hp_component.take_damage(attacker_atack_component.attack_power)

func _get_targets_for_unit(attacker: Unit) -> Array:
	
	var found_targets = []
	
	var component = _get_component(attacker, AttackComponent)
	if component == null: 
		return found_targets
	
	var rotation_angle = Vector2.LEFT.angle_to(component.attack_direction)

	for offset in component.attack_pattern:
		
		var rotated_offset = offset.rotated(rotation_angle).round()
		var target_cell = attacker.grid_position + rotated_offset
		
		var target_unit = unit_grid_model.get_unit_at(target_cell)
		if target_unit == null:
			continue
		var target_team = _get_component(target_unit, HpComponent).team
		var attacker_team = _get_component(attacker, HpComponent).team
		if target_team != attacker_team:
			found_targets.append(target_unit)
				
	return found_targets

func _sort_by_initiative(unit_a, unit_b) -> bool:
	return unit_a.initiative > unit_b.initiative
	
	
func _get_component(node: Node, type: Script) -> Node:
	var component = null
	
	for child in node.get_children():
		if child is type:
			component = child
			break
			
	return component
