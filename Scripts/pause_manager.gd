extends Node

var pause_button = null
var pause_overlay = null
var menu_button = null
var resume_button = null
var is_paused = false

# Переменные для стилей с картинками
var pause_style = null
var play_style = null
var hover_style = null
var play_hover_style = null

func _ready():
	print("=== PauseManager START ===")
	
	# Находим кнопку паузы
	pause_button = get_tree().root.find_child("PauseButton", true, false)
	
	if pause_button:
		# Загружаем картинки
		var pause_texture = load("res://Assets/button_pause.png")
		var play_texture = load("res://Assets/button_resume.png")
		
		# Создаём стили с картинками
		pause_style = StyleBoxTexture.new()
		pause_style.texture = pause_texture
		
		play_style = StyleBoxTexture.new()
		play_style.texture = play_texture
		
		# Стиль для наведения (та же картинка, чтобы не пропадала)
		hover_style = StyleBoxTexture.new()
		hover_style.texture = pause_texture
		
		play_hover_style = StyleBoxTexture.new()
		play_hover_style.texture = play_texture
		
		# Устанавливаем стили
		pause_button.add_theme_stylebox_override("normal", pause_style)
		pause_button.add_theme_stylebox_override("hover", hover_style)
		pause_button.add_theme_stylebox_override("pressed", pause_style)
		
		# === НОВАЯ СТРОКА 1: Поднимаем кнопку поверх всех ===
		pause_button.z_index = 1600
		pause_button.z_as_relative = false
		
		if pause_button.pressed.is_connected(_on_pause_pressed):
			pause_button.pressed.disconnect(_on_pause_pressed)
		pause_button.pressed.connect(_on_pause_pressed)
		
		# Подключаем сигнал
		pause_button.pressed.connect(_on_pause_pressed)
		
		print("Кнопка паузы настроена")
	
	# Находим оверлей
	pause_overlay = get_node("/root/main/PauseOverlay")
	if pause_overlay:
		pause_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		print("PauseOverlay найден")
		
		# Ищем кнопку меню
		menu_button = pause_overlay.get_node("MenuButton")
		if menu_button:
			if not menu_button.pressed.is_connected(_on_menu_pressed):
				menu_button.pressed.connect(_on_menu_pressed)
			print("MenuButton найден")
		
		# Ищем кнопку Resume (если она есть в оверлее)
		resume_button = pause_overlay.get_node("ResumeButton")
		if resume_button:
			if not resume_button.pressed.is_connected(_on_resume_pressed):
				resume_button.pressed.connect(_on_resume_pressed)
			print("ResumeButton найден")
	
	# === НОВАЯ СТРОКА 2: Перемещаем кнопку в самый низ иерархии (чтобы была поверх) ===
	if pause_button:
		pause_button.get_parent().move_child(pause_button, -1)

func _on_pause_pressed():
	print("===== КНОПКА ПАУЗЫ НАЖАТА =====")
	
	if not is_paused:
		# Включаем паузу
		is_paused = true
		get_tree().paused = true
		
		# Меняем стиль кнопки на "продолжить"
		if pause_button and play_style:
			pause_button.add_theme_stylebox_override("normal", play_style)
			pause_button.add_theme_stylebox_override("hover", play_hover_style)
		
		# Показываем оверлей с затемнением
		if pause_overlay:
			pause_overlay.visible = true
			pause_overlay.modulate.a = 0.7
		
		# Показываем кнопку меню
		if menu_button:
			menu_button.visible = true
		
		# Убеждаемся, что кнопка паузы всё ещё поверх
		if pause_button:
			pause_button.z_index = 100
		
		print("Игра на паузе")
	else:
		# Выключаем паузу (RESUME) - повторное нажатие на ту же кнопку
		is_paused = false
		get_tree().paused = false
		
		# Меняем стиль кнопки обратно на "пауза"
		if pause_button and pause_style:
			pause_button.add_theme_stylebox_override("normal", pause_style)
			pause_button.add_theme_stylebox_override("hover", hover_style)
		
		# Скрываем оверлей
		if pause_overlay:
			pause_overlay.visible = false
			pause_overlay.modulate.a = 0
		
		# Скрываем кнопку меню
		if menu_button:
			menu_button.visible = false
		
		print("Игра продолжается")

func _on_resume_pressed():
	print("===== КНОПКА RESUME НАЖАТА =====")
	
	# Выключаем паузу
	is_paused = false
	get_tree().paused = false
	
	# Меняем стиль кнопки обратно на "пауза"
	if pause_button and pause_style:
		pause_button.add_theme_stylebox_override("normal", pause_style)
		pause_button.add_theme_stylebox_override("hover", hover_style)
	
	# Скрываем оверлей
	if pause_overlay:
		pause_overlay.visible = false
		pause_overlay.modulate.a = 0
	
	# Скрываем кнопку меню
	if menu_button:
		menu_button.visible = false
	
	print("Игра продолжается через Resume")

func _on_menu_pressed():
	print("===== КНОПКА МЕНЮ НАЖАТА =====")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
