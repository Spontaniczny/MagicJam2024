extends ProgressBar

var color
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_lifetime(lifetime: float) -> void:
	value = min(lifetime, 180.0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
