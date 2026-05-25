extends TextureButton

func _ready():
	print("Кнопка паузы загружена")
	pressed.connect(_on_press)

func _on_press():
	print("Кнопка паузы нажата!")
	get_tree().paused = not get_tree().paused
