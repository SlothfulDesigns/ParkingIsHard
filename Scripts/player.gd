extends Sprite

var player

func _ready():
	player = get_parent()
	set_process(true)
	
func _process(delta):
	var steer_left = Input.is_action_pressed("player_steer_left")
	var steer_right = Input.is_action_pressed("player_steer_right")
	var throttle = 0
	
	if(Input.is_action_pressed("player_accelerate")):
		throttle = 1

	update()