extends Node2D

class_name PipePair

var speed = 0
signal dragon_entered
signal point_scored

func set_speed(new_speed: int):
	speed = new_speed

func _process(delta):
	if get_tree().paused:
		return
	position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	dragon_entered.emit()

func _on_point_scored(body):
	point_scored.emit()
