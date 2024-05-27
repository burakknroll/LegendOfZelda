extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		var indicatorLabel = get_parent().get_node("IndicatorLabel")
		var indicatorLabelAnim = get_parent().get_node("IndicatorLabel/AnimationPlayer")
		indicatorLabel.visible = true
		indicatorLabelAnim.play("idle")


func _on_body_exited(body):
	if body.name == "Player":
		var indicatorLabel = get_parent().get_node("IndicatorLabel")
		var indicatorLabelAnim = get_parent().get_node("IndicatorLabel/AnimationPlayer")
		indicatorLabel.visible = false
		indicatorLabelAnim.play("lost")
		
