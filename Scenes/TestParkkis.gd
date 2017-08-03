extends Node2D

var screen_size
var player

func _ready():
	screen_size = get_viewport_rect().size
	player = get_node("player")
	player.set_pos(Vector2(screen_size.x / 2.0, screen_size.y / 2.0))

	set_process(true)

func _process(delta):
	update()