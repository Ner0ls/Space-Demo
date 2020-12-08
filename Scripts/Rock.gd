extends RigidBody2D

export (int) var minVelocity
export (int) var maxVelocity

signal out_of_screen

func _ready():
	pass


func _process(delta):
	pass


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("out_of_screen", self, "Rocks")
	queue_free()
