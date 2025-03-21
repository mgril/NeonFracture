class_name GameOver extends Control

@onready var ui_chromatique_glitch = $"../../UI_ChromatiqueGlitch"
@onready var score_label = $VBoxContainer/ScoreLabel
@onready var high_score_label = $VBoxContainer/HighScoreLabel
@onready var texture_button_restart = $VBoxContainer/GridContainer/TextureButton_Restart
@onready var texture_button_quit = $VBoxContainer/GridContainer/TextureButton_Quit

const gameover_scene:PackedScene = preload("res://Game/Scene/control_game_over.tscn")
var gameover_menu:GameOver


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_root().get_node("Root").get_node("Player")
	player.currentHealthUpdated.connect(checkGameOver)
	player.playerHasReachedTheDoor.connect(showGameOverUI)
	visible = false

func set_score(n:int):
	score_label.text = "Final Score :" + str(n)
	
	
func showGameOverUI():
	await get_tree().create_timer(1.0).timeout
	ui_chromatique_glitch.set_visible(false)
	visible = true

func checkGameOver(newValue):
	if newValue<= 0:
		var player = get_tree().get_root().get_node("Root").get_node("Player")
		set_score(player.currentFragment)
		showGameOverUI()


func _on_texture_button_restart_pressed():
	get_tree().reload_current_scene()


func _on_texture_button_quit_pressed():
	get_tree().quit()
	
func _notification(what):
	#match what:
		#NOTIFICATION_ENTER_TREE:
			#get_tree().paused = true
		#NOTIFICATION_EXIT_TREE:
			#get_tree().paused = false
	pass
		
