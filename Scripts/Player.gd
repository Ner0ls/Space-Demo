extends Area2D

export (int) var speed
export (float) var acceleration
export (float) var friction
var velocity = Vector2.ZERO
var smooth:float = 15.0
var limit
signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	limit = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		input_velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_velocity.y += 1
	input_velocity = input_velocity.normalized()
	
	if input_velocity:
		velocity = velocity.linear_interpolate(input_velocity * speed, acceleration)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	position += velocity * delta

	position.x = clamp(position.x, 0+5, limit.x-5)
	position.y = clamp(position.y, 0+5, limit.y-5)
	
	if input_velocity.x != 0:
		rotatePlayer(atan2(input_velocity.x, -input_velocity.y))
	
	if input_velocity.y != 0:
		rotatePlayer(atan2(input_velocity.x, -input_velocity.y))

func _on_Player_body_entered(body):
	self.set_collision_mask_bit(1, false)
	hide()
	emit_signal("hit")

func start(pos):
	position = pos
	rotation = 0
	$AnimatedSprite.rotation_degrees = 0
	$CollisionPolygon2D.rotation_degrees = $AnimatedSprite.rotation_degrees
	self.set_collision_mask_bit(1, true)
	show()
	

func lerp_angle_own(from, to, weight):
	return from + short_angle_dist(from, to) * weight


func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func rotatePlayer(facing):
	rotation = lerp_angle(rotation, facing, 0.3)
#	while (rotation != facing):
