extends CharacterBody3D


const SPEED = 1.4

const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var ray_cast_3d_forward = $CollisionShape3D/RayCast3D_Forward
@onready var root_node = $Model/RootNode
@onready var collision_shape_3d = $CollisionShape3D
@onready var animation_player = $Model/AnimationPlayer
@onready var ray_cast_3d_downward = $CollisionShape3D/RayCast3D_Downward

var direction
var facingRight = true

func _ready():
	animation_player.play("NPC_01_WALK")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * 5
		
	if ray_cast_3d_forward.is_colliding() || ray_cast_3d_downward.is_colliding() == false:
		facingRight = !facingRight
	
	if facingRight:
		direction = 1
		root_node.rotation = Vector3(0,0,0)
		collision_shape_3d.rotation = Vector3(0,0,0)
	else: 
		direction = -1
		root_node.rotation = Vector3(0,PI,0)
		collision_shape_3d.rotation = Vector3(0,PI,0)
		
	velocity.x = direction * SPEED		

	move_and_slide()


func _on_area_3d_body_entered(body):
	body.applyDamage()
