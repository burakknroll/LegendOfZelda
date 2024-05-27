extends Node

@export_range(0,1) var dropPercent: float = 0.5
@export var heartScene: PackedScene
@export var healthComponent: Node

func _ready():
	(healthComponent as HealthComponent).died.connect(onDied)
	
func onDied():
	if heartScene == null:
		return
	if not owner is Node2D:
		return
	if randf() > dropPercent:
		return
		
	var spawnPosition = (owner as Node2D).global_position
	var heartInstance = heartScene.instantiate() as Node2D
	var entitiesLayer = get_tree().get_first_node_in_group("EntitiesLayer")
	entitiesLayer.add_child(heartInstance)
	heartInstance.global_position = spawnPosition
