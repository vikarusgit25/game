extends CanvasLayer

@onready var sound_button = $SoundButton

var sound_on = preload("res://Assets/sound_on.png")
var sound_off = preload("res://Assets/sound_off.png")
var is_muted = false

# Звуковые плееры
var button_click_player: AudioStreamPlayer
var flap_sound_player: AudioStreamPlayer
var score_sound_player: AudioStreamPlayer
var crash_sound_player: AudioStreamPlayer

func _ready():
	# Создаём звуковые плееры
	button_click_player = create_sound_player("res://Assets/Sounds/button_click.wav", -5)
	flap_sound_player = create_sound_player("res://Assets/Sounds/sfx_wing.wav", -3)
	score_sound_player = create_sound_player("res://Assets/Sounds/sfx_point.wav", -4)
	crash_sound_player = create_sound_player("res://Assets/Sounds/sfx_hit.wav", -2)
	
	# Загружаем состояние
	load_sound_settings()
	update_button_texture()
	
	# Подключаем кнопку
	sound_button.pressed.connect(_on_sound_button_pressed)
	
	sound_button.focus_mode = Control.FOCUS_NONE 

func create_sound_player(path: String, volume: float) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.stream = load(path)
	player.volume_db = volume
	add_child(player)
	return player

func _on_sound_button_pressed():
	toggle_mute()

func toggle_mute():
	is_muted = !is_muted
	update_mute_state()
	save_sound_settings()
	update_button_texture()

func update_mute_state():
	var volume = -80 if is_muted else -5
	
	if button_click_player:
		button_click_player.volume_db = volume
	if flap_sound_player:
		flap_sound_player.volume_db = volume
	if score_sound_player:
		score_sound_player.volume_db = volume
	if crash_sound_player:
		crash_sound_player.volume_db = volume

func update_button_texture():
	if is_muted:
		sound_button.texture_normal = sound_off
	else:
		sound_button.texture_normal = sound_on

func play_button_click():
	if button_click_player and not is_muted:
		button_click_player.play()

func play_flap():
	if flap_sound_player and not is_muted:
		flap_sound_player.play()

func play_score():
	if score_sound_player and not is_muted:
		score_sound_player.play()

func play_crash():
	if crash_sound_player and not is_muted:
		crash_sound_player.play()

func save_sound_settings():
	var file = FileAccess.open("user://sound_settings.save", FileAccess.WRITE)
	file.store_string(str(is_muted))
	file.close()

func load_sound_settings():
	if FileAccess.file_exists("user://sound_settings.save"):
		var file = FileAccess.open("user://sound_settings.save", FileAccess.READ)
		var muted = file.get_as_text()
		file.close()
		is_muted = muted == "True"
		update_mute_state()
	else:
		is_muted = false
