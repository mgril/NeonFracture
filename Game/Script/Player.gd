extends CharacterBody3D

@onready var root_node = $Model/RootNode


const SPEED = 10
const JUMP_VELOCITY = 22 


# Get the gravity from the project settings to be synced with RigidBody nodes.

# there is a problem gravity is not adjust for the jump 
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var animation_tree = $Model/AnimationTree
@onready var footstep_vfx = $Model/RootNode/VFX/Footstep_VFX
@onready var animation_player_material = $Model/AnimationPlayer_Material
@onready var heal_player_vfx = $Model/RootNode/VFX/HEAL_Player_VFX
@onready var melee_vfx = $Model/RootNode/VFX/MELEE_VFX
@onready var area_3d_hit_box = $Model/RootNode/Area3D_HitBox
@onready var animation_player_blade_vfx = $Model/RootNode/VFX/AnimationPlayer_BladeVFX


const maxHealth = 3

var currentHealth
var controllable = true 
var isInvincible = false
var uncontrollableRemain = 0
var getHurtCooldown = 1
var meleeAttackCooldown = 0.6
var meleeAttackDamage = 10

signal currentHealthUpdated(newValue)

func _ready():
	currentHealth = maxHealth 
	area_3d_hit_box.monitoring = false

func _process(delta):
	handleMovementVFX()
	if currentHealth <= 0:
		return
		
	animation_tree.set("parameters/StateMachine/GroundMovement/blend_position", abs(velocity.x))
	animation_tree.set("parameters/StateMachine/Airborne/blend_position", velocity.y)
	
	if is_on_floor():
		animation_tree.changeStateToNormal()
	else: 
		animation_tree.changeStateToAirBorne()

	if controllable == false && currentHealth > 0 : 
		uncontrollableRemain -= delta
		if uncontrollableRemain <= 0:
			uncontrollableRemain = 0
			controllable = true
	
	if controllable == true && Input.is_action_just_pressed("MeleeAttack"):
		controllable = false
		uncontrollableRemain += meleeAttackCooldown
		
		animation_tree.set("parameters/OneShotMelee/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		animation_player_blade_vfx.play("PlayerBladeVFX")
		
		area_3d_hit_box.monitoring = true 
		await get_tree().create_timer(0.3).timeout
		area_3d_hit_box.monitoring = false

func _physics_process(delta):
	if controllable == false :
		updateHorizontalVelocity()
		updateVerticalVelocity(delta)
		move_and_slide()
		return
		
#region Rotate player to the moving direction
	if velocity.x != 0:
		var faceRight = velocity.x > 0
		if faceRight:
			root_node.rotation = Vector3(0,0,0)
		else: 
			root_node.rotation = Vector3(0,PI,0)
#endregion
	# Add the gravity.
	if not is_on_floor():
		updateVerticalVelocity(delta)

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		playGroundSmokeVFX()
		
	var horizontal_input =  Input.get_axis("MoveLeft","MoveRight")
	if horizontal_input:
		velocity.x = horizontal_input * SPEED
	else:
		updateHorizontalVelocity()

	move_and_slide()
	
func handleMovementVFX():
	if is_on_floor():
		if velocity.x != 0:
			footstep_vfx.emitting = true
		else:
			footstep_vfx.emitting = false
	else:
		footstep_vfx.emitting = false
		
	if is_on_floor():
		if animation_tree.checkIfStateIsAirborne(): 
			playGroundSmokeVFX()
		
		
		
func playGroundSmokeVFX():
	var vfxToSpawn = preload("res://Asset/VFX/Scene/land_vfx.tscn")
	var vfxInstance = vfxToSpawn.instantiate()
	get_tree().get_root().get_node("Root").add_child(vfxInstance)
	
	vfxInstance.global_position = global_position + Vector3(0, 0.3, 0.2)
	vfxInstance.restart()
	await get_tree().create_timer(0.6).timeout
	vfxInstance.queue_free()
	
func applyDamage():
	
	if currentHealth == 0 || isInvincible:
		return
		
	currentHealth -= 1
	controllable = false
	uncontrollableRemain += getHurtCooldown
	isInvincible = true
	emit_signal("currentHealthUpdated", currentHealth)
	print(currentHealth)
	
	if currentHealth <= 0 :
		animation_tree.changeStateToDead()
		#print ("The player is dead ")
	else:
		animation_tree.set("parameters/OneShotMelee/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		animation_tree.set("parameters/OneShotHurt/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		animation_player_material.play("Flash_Invincible")
		
		await get_tree().create_timer(2.0).timeout
		animation_player_material.play("RESET")
		isInvincible = false
	
func updateHorizontalVelocity():
	velocity.x = move_toward(velocity.x, 0, 1)
	
func updateVerticalVelocity(delta):
	velocity.y -= gravity * delta * 8
	
func addHealth():
	if currentHealth == maxHealth: 
		return false
		
	currentHealth += 1
	animation_player_material.play("Flash_Heal")
	heal_player_vfx.restart()
	
	emit_signal("currentHealthUpdated", currentHealth)
	return true


func _on_area_3d_hit_box_body_entered(body):
	body.applyDamage(meleeAttackDamage)
	
	var vfx_position = body.global_position
	vfx_position.y += 1.5
	vfx_position.z += 1
	melee_vfx.global_position = vfx_position
	
	for item in melee_vfx.get_children():
		item.restart()
