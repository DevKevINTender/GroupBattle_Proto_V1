# EnemySpawnData.gd
extends Resource
class_name EnemySpawnData

export(PackedScene) var enemy_scene # Сцена самого юнита врага (например, Enemy.tscn)
export(String) var enemy_id = "goblin"
export(Vector2) var grid_position = Vector2.ZERO # Координаты на поле 4х4
