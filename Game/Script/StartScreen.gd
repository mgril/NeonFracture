class_name StartScreen extends CanvasLayer

const gameplay_scene:PackedScene = preload("res://Game/main.tscn")
#demander a sylavin pk ca fait tout peter 


@onready var button_start = $Panel/HBoxContainer/VBoxContainer/GridContainer/TextureButton_Start
@onready var button_quit = $Panel/HBoxContainer/VBoxContainer/GridContainer/TextureButton_Quit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#Global.save_data_.high_score = 10
	#Global.save_data.save()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_texture_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_texture_button_quit_pressed() -> void:
	get_tree().quit()
