extends Node
export(PackedScene) var particle_scene
export(PackedScene) var wall_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("click"):
		var particle = particle_scene.instance()
		particle.position = get_viewport().get_mouse_position()
		add_child(particle)
	if Input.is_action_pressed("right_click"):
		var wall = wall_scene.instance()
		wall.position = get_viewport().get_mouse_position()
		add_child(wall)
