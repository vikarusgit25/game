extends Control

@onready var play_button = $BoxContainer/PlayButton
@onready var click_sound = $BoxContainer/PlayButton/AudioStreamPlayer2D

func _ready():
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	click_sound.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
