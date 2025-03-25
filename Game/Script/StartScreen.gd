class_name StartScreen extends CanvasLayer

const gameplay_scene:PackedScene = preload("res://Game/main.tscn")

@onready var high_score_label = $Panel/ColorRect/HBoxContainer/VBoxContainer/Label
@onready var button_start = $Panel/ColorRect/HBoxContainer/VBoxContainer/GridContainer/TextureButton_Start
@onready var button_quit = $Panel/ColorRect/HBoxContainer/VBoxContainer/GridContainer/TextureButton_Quit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var high_score:int = Global.save_data.high_score
	high_score_label.text = "High Score: " + str(high_score)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_texture_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_texture_button_quit_pressed() -> void:
	get_tree().quit()
