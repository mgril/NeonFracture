extends Node3D

const PICKUP_FRAGMENT = preload("res://Game/Scene/pickup_fragment.tscn")

func _ready():
	var player = get_tree().get_root().get_node("Root").get_node("Player")
	player.respawnNewFragment.connect(respawnFragment)

func respawnFragment():
	var newFragment = PICKUP_FRAGMENT.instantiate()
	get_parent().add_child(newFragment)

	var positionPoint = get_child(randi_range(0, get_child_count()-1))
	
	# Faire un tableau de random position 
	newFragment.global_position = positionPoint.global_position
	
