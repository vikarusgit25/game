extends CanvasLayer

class_name UI

@onready var game_over_box = $GameOverBox
@onready var points_label = $PointsLabel
@onready var score_label = $GameOverBox/ScorePanel/ScoreLabel
@onready var best_label = $GameOverBox/ScorePanel/BestLabel
@onready var medal_icon = $GameOverBox/ScorePanel/MedalIcon
@onready var click_sound = $GameOverBox/ButtonRestart/AudioStreamPlayer2D

var current_score = 0
var best_score = 0

func _ready():
	points_label.text = "0"
	game_over_box.visible = false
	_load_best_score()

func update_points(points: int):
	current_score = points
	points_label.text = str(points)

func on_game_over():
	if current_score > best_score:
		best_score = current_score
		_save_best_score()
	
	score_label.text = str(current_score)
	best_label.text = str(best_score)
	_update_medal(current_score)
	game_over_box.visible = true

func _update_medal(score: int):
	var medal = null
	if score >= 40:
		medal = load("res://Assets/platinum_medal.png")
	elif score >= 30:
		medal = load("res://Assets/gold_medal.png")
	elif score >= 20:
		medal = load("res://Assets/silver_medal.png")
	elif score >= 10:
		medal = load("res://Assets/bronse_medal.png")
	
	medal_icon.visible = medal != null
	if medal:
		medal_icon.texture = medal

func _load_best_score():
	var file = "user://best_score.save"
	if FileAccess.file_exists(file):
		best_score = int(FileAccess.open(file, FileAccess.READ).get_as_text())

func _save_best_score():
	var file = FileAccess.open("user://best_score.save", FileAccess.WRITE)
	file.store_string(str(best_score))

func _on_button_pressed():
	click_sound.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().reload_current_scene()
