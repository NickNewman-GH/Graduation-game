extends Node
export(PackedScene) var particle_scene

var grid 
var screen_size

func _ready():
	screen_size = get_viewport().size
	grid = Grid.new(get_node("."), Vector2(100, 100))
	
func _process(delta):
	if Input.is_action_pressed("click"):
		grid.action_processing(get_viewport().get_mouse_position())
	grid.update()
	#print(1/delta)
		
func _physics_process(delta):
	#if Input.is_action_just_pressed("ui_select"):
	pass
