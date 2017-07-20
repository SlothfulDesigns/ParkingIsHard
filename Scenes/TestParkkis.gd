extends Node2D

var screen_size
var player
var player_heading = 0.0
var player_speed = 0.0
var player_acceleration = 0.3

var front_wheels = Vector2()
var back_wheels = Vector2()
var steer_angle = 0.0
var prev_steer = false

const max_speed = 18.0
const steer_speed = 5.0
const max_steer = 45.0
const wheel_base = 4.8


func _ready():
	screen_size = get_viewport_rect().size
	player = get_node("player")
	player_heading = player.get_rotd()
	
	var h = deg2rad(player_heading)
	var player_pos = player.get_pos()
	front_wheels = player_pos + wheel_base / 2.0 * Vector2(cos(h), sin(h))
	back_wheels = player_pos - wheel_base / 2.0 * Vector2(cos(h), sin(h))
	front_wheels += player_speed * 0 * Vector2(cos(h + deg2rad(steer_angle)), sin(h + deg2rad(steer_angle)))
	back_wheels += player_speed * 0 * Vector2(cos(h), sin(h))
	
	set_process(true)

func _process(delta):
	var steer_left = Input.is_action_pressed("player_steer_left")
	var steer_right = Input.is_action_pressed("player_steer_right")
	
	if(Input.is_action_pressed("player_accelerate")):
		if player_speed < max_speed:
			player_speed += player_acceleration
	elif(Input.is_action_pressed("player_brake_reverse")):
		if player_speed > -max_speed:
			player_speed -= player_acceleration
	else:
		player_speed = player_speed - player_acceleration if player_speed > 0.0 else player_speed + player_acceleration
			
	# STEERING
	if((steer_left or steer_right) and player_speed != 0.0):
		if steer_right and steer_angle < max_steer:
			steer_angle += steer_speed
		elif steer_left and steer_angle > -max_steer:
			steer_angle -= steer_speed
		prev_steer = true
	else:
		prev_steer = false
		if steer_angle != 0.0:
			steer_angle = steer_angle + steer_speed if steer_angle < 0.0 else steer_angle - steer_speed
		
	var h = deg2rad(player_heading)
	var player_pos = player.get_pos()
	
	front_wheels = player_pos + wheel_base / 2.0 * Vector2(cos(h), sin(h))
	back_wheels = player_pos - wheel_base / 2.0 * Vector2(cos(h), sin(h))

	front_wheels += player_speed * delta * Vector2(cos(h + deg2rad(steer_angle)), sin(h + deg2rad(steer_angle)))
	back_wheels += player_speed * delta * Vector2(cos(h), sin(h))
	
	player_pos = (front_wheels + back_wheels) / 2.0
	player_heading = rad2deg(atan2(front_wheels.y - back_wheels.y, front_wheels.x - back_wheels.x))
	player.set_pos(player_pos)
	player.set_rotd(-player_heading)
	
	print(player_heading)
	
	update()
	
	
func _draw():
	draw_line(back_wheels, front_wheels, Color(255, 0, 0), 3)