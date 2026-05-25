extends CharacterBody2D

class_name Dragon

signal game_started
signal crashed

@export var gravity = 900
@export var jump_force = -300
@export var rotation_speed = 2
@export var death_gravity_multiplier = 1.5

@onready var animation_player = $AnimationPlayer

var max_speed = 400
var is_started = false
var is_game_active = true
var is_dead = false
var current_gravity = 900

func _ready():
	velocity = Vector2.ZERO
	current_gravity = gravity
	animation_player.play('idle')

func _physics_process(delta):
	if get_tree().paused or not is_game_active:
		return
	
	if Input.is_action_just_pressed("jump") and not is_dead:
		if not is_started:
			game_started.emit()
			animation_player.play("flap_wings")
			is_started = true
		
		velocity.y = jump_force
		rotation = deg_to_rad(-30)
		SoundButtonUI.play_flap()
	
	if not is_started:
		return
	
	velocity.y += current_gravity * delta
	velocity.y = min(velocity.y, max_speed)
	move_and_collide(velocity * delta)
	
	if not is_dead:
		if velocity.y > 0 and rad_to_deg(rotation) < 90:
			rotation += rotation_speed * deg_to_rad(1)
		elif velocity.y < 0 and rad_to_deg(rotation) > -30:
			rotation -= rotation_speed * deg_to_rad(1)
	else:
		if rad_to_deg(rotation) < 90:
			rotation += rotation_speed * deg_to_rad(1)

func kill():
	if is_dead:
		return
	
	is_dead = true
	is_game_active = true
	current_gravity = gravity * death_gravity_multiplier
	velocity.y = -150
	SoundButtonUI.play_crash()
	crashed.emit()

func play_score_sound():
	SoundButtonUI.play_score()

func stop():
	is_game_active = false
	animation_player.stop()
