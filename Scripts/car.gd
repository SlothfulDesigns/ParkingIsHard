extends Sprite

var player
var throttle = 0

# Car specs
var mass = 1000

# Stuffs
var speed = 0
var engineforce = 10000.0

# Things 
var position = Vector2(0.0, 0.0)
var rotation = Vector2(0.0, 0.0)
var heading = Vector2(1.0, 0.0)
var velocity = Vector2(0.0, 0.0)
var acceleration = Vector2(0.0, 0.0)


# Forces
var f_traction = Vector2(0.0, 0.0)
var f_braking = Vector2(0.0, 0.0)
var f_drag = Vector2(0.0, 0.0)
var f_rr = Vector2(0.0, 0.0)
var f_long = Vector2(0.0, 0.0)
var f_lat = Vector2(0.0, 0.0)

# Constants and magic
var c_drag = 0.4257
var c_rr = 12.8
var c_braking = 69.0


func simulate(throttle, delta):
	var ef = throttle * engineforce
	f_traction = heading * ef
	f_drag = -c_drag * velocity * velocity.length()
	f_rr = -c_rr * velocity
	f_long = f_traction + f_drag + f_rr
	
	acceleration = f_long / mass
	velocity += delta * acceleration
	position += delta * velocity
	
func _ready():
	player = get_parent()
	position = player.get_pos()
	rotation = player.get_rot()
	set_process(true)
	set_fixed_process(true)
	
func _process(delta):
	var steer_left = Input.is_action_pressed("player_steer_left")
	var steer_right = Input.is_action_pressed("player_steer_right")
	throttle = 0
	
	if(Input.is_action_pressed("player_accelerate")):
		throttle = 1
		
	player.set_pos(position)
	print(position)
	update()
	
func _fixed_process(delta):
	simulate(throttle, delta)
