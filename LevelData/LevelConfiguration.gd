# LevelConfiguration.gd
extends Resource
class_name LevelConfiguration

export(int) var level_index = 1
export(int) var section_index = 1

# Массив, в который мы будем добавлять данные врагов прямо в инспекторе
export(Array, Resource) var enemies_to_spawn = []
