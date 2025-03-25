class_name Enemy_Spawner extends Node3D

@onready var spawn_timer = $spawnTimer

const ENEMY_A = preload("res://Game/Scene/enemy_a.tscn")

func _on_spawn_timer_timeout():
	var newEnemy = ENEMY_A.instantiate()
	get_parent().add_child(newEnemy)
	
	var PositionArray = get_node("PositionSpawnerArray")
	var positionPoint = PositionArray.get_child(randi_range(0, PositionArray.get_child_count()))
	
	# Faire unn tableau de random position 
	newEnemy.global_position = positionPoint.global_position
	
