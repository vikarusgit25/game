extends Node

@onready var dragon = $"../Dragon"
@onready var pipe_spawner = $"../PipeSpawner"
@onready var ground = $"../ground"
@onready var fade = $"../Fade"
@onready var ui = $"../UI"

var points = 0

func _ready():
	dragon.game_started.connect(_on_game_started)
	ground.dragon_crashed.connect(_end_game)
	pipe_spawner.dragon_crashed.connect(_end_game)
	pipe_spawner.point_scored.connect(_on_point_scored)

func _on_game_started():
	pipe_spawner.start_spawning_pipes()

func _end_game():
	var pause_ui = get_tree().root.find_child("PauseUI", true, false)
	if pause_ui:
		pause_ui.disable_pause()
	
	fade.play() if fade else null
	ground.stop()
	dragon.kill()
	pipe_spawner.stop()
	ui.on_game_over()

func _on_point_scored():
	points += 1
	ui.update_points(points)
	dragon.play_score_sound()
