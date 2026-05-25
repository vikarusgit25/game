extends CanvasLayer

class_name PauseUI

@onready var pause_button = $PauseButton
@onready var pause_overlay = $PauseOverlay
@onready var resume_button = $ResumeButton
@onready var menu_button = $MenuButton

var is_paused = false
var is_transitioning = false
var is_game_over = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_button.pressed.connect(_on_pause_pressed)
	resume_button.pressed.connect(_on_resume_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	set_pause_ui_visible(false)

func _input(event):
	if event.is_action_pressed("ui_cancel") and not is_game_over:
		_on_resume_pressed() if is_paused else _on_pause_pressed()

func disable_pause():
	is_game_over = true
	pause_button.visible = false
	pause_button.disabled = true

func set_pause_ui_visible(visible: bool):
	pause_overlay.visible = visible
	pause_overlay.modulate.a = 0.7 if visible else 0
	resume_button.visible = visible
	menu_button.visible = visible

func _on_pause_pressed():
	if is_transitioning or is_game_over or is_paused:
		return
	
	SoundButtonUI.play_button_click()
	is_paused = true
	get_tree().paused = true
	pause_button.visible = false
	set_pause_ui_visible(true)

func _on_resume_pressed():
	if is_transitioning:
		return
	
	SoundButtonUI.play_button_click()
	set_pause_ui_visible(false)
	pause_button.visible = true
	await get_tree().create_timer(1.0).timeout
	is_paused = false
	get_tree().paused = false

func _on_menu_pressed():
	if is_transitioning:
		return
	
	SoundButtonUI.play_button_click()
	is_transitioning = true
	get_tree().paused = false
	set_pause_ui_visible(false)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
