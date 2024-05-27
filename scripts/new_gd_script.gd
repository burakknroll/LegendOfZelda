extends Node

@export_range(0, 1) var dropPercent: float = 0.5
@export var healthComponent: Node
@export var heartScene: PackedScene

func _ready():
	(healthComponent as HealthComponent).died.connect(onDied)

func onDied():
	if randf() > dropPercent:
		return
	if heartScene == null: #boşsa bişi atma
		return
	
	if not owner is Node2D: 
		return
	
	var spawnPos = (owner as Node2D).global_position
	var heartInstance = heartScene.instantiate() as Node2D
	var entitiesLayer = get_tree().get_first_node_in_group("EntitiesLayer")
	entitiesLayer.add_child(heartInstance)
	heartInstance.global_position = spawnPos
