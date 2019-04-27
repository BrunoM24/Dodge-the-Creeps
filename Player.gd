extends Area2D

signal hit

export var speed := 400 #How fast the player will move (pixels/sec)
var screen_size #Size of the game window
var velocity := Vector2()
var target := Vector2() # Add this variable to hold the clicked position

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	
func _process(delta):
	# var velocity := Vector2() #The player's movement vector
	
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
	
	# Keyboard controls removed
	# if Input.is_action_pressed("ui_right"):
	# 	velocity.x += 1
	# if Input.is_action_pressed("ui_left"):
	# 	velocity.x -= 1
	# if Input.is_action_pressed("ui_up"):
	# 	velocity.y -= 1
	# if Input.is_action_pressed("ui_down"):
	# 	velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	
	# Don't need to camp the player's position
	# because we can't click outside of the screen
	# position.x = clamp(position.x, 0, screen_size.x)
	# position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.call_deferred("set_disabled", true)
	
func start(pos : Vector2) -> void:
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false

# Change the target whenever a touch event happens
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
