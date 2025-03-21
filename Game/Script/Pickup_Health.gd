extends Node3D
@onready var heal_mesh = $HEAL_MESH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	heal_mesh.rotate_y(delta)

func _on_area_3d_body_entered(body):
	var result = body.addHealth()
	
	if result: 
		queue_free()
