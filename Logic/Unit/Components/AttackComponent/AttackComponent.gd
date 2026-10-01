extends Node2D
class_name AttackComponent

export(int) var attack_power = 10
export(Array, Vector2) var attack_pattern = [Vector2(1, 0)]
export(int) var initiative = 10
export(Vector2) var attack_direction = Vector2.UP

func change_atack_direction():
	attack_direction = attack_direction.rotated(PI / 2)
	attack_direction = attack_direction.round()
