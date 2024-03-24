extends Control

signal entity_change_gear

@export var CharacterScene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = CharacterScene.instantiate()
		
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		for spawn in $Level.get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				print("uu")
				currentPlayer.global_position = spawn.global_position
		index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_time_multiplier_changed(time_multiplier):
	print("mult2:")
	print(time_multiplier)
	for child in get_children():
		child.on_time_multiplier_changed(time_multiplier)

