extends Node2D

func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		if $ShopPopUP/Panel.visible == true:
			$ShopPopUP/Panel.visible = false
			
		else:
			$ShopPopUP/Panel.visible = true
		#$ShopPopUP/Panel.visible = true

func _on_buy_button_pressed():
	if Global.coin >= 10:
		Global.coin -= 10
		$ShopPopUP/Panel/swordPanel/buyButton.disabled = true
		Global.flameSwordBought = true
