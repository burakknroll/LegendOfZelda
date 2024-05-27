extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		Global.coin += 100
		queue_free()
