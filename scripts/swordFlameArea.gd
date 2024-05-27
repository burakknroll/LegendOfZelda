extends Area2D

var speed = 100 #50, 70, 120
var dmg

func _ready():
	get_parent().global_position

func _physics_process(delta):
	position += transform.x * speed * delta

func setDamage(damage):
	print(damage)
	dmg = damage

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.dealDamage(dmg)
