extends Node3D

@onready var fragment_mesh = $Fragment_Mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fragment_mesh.rotate_y(delta * 1.5)


func _on_area_3d_body_entered(body):
	var result = body.addFragment()
	
	if result:
		queue_free()
