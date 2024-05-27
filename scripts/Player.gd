extends CharacterBody2D

@export var speed = 66 #hız belirledim
@export var sword: PackedScene
@export var flameSword: PackedScene
@onready var playerAnition = $Animasyon #animasyon node'nu tanıttım
#@onready var tSword  = load("res://scenes/swordArea.tscn")

var dmg = 15 #fırlatılabilen kılıcın hasarı
var amount = 30 #atılabilirlik sınırlayıcısı kaç tane atabileceğimiz
var currentDir = "none" #mevcut bir tane yön oluşturdum içini boş atadım
var attackDetector = false #attack yapabiliyor muyum? boolean
var enemyInAttackRange = false #enemy'i görebiliyor muyum?
var enemyAttackCooldown = true #enemy attack süresi boyunca icerde mi
var health = 100 #can tanımladım
var playerAlive = true #player canlı mı?

func _ready():
	$HUD/globalCoin.text = str(Global.coin)

func movement():
	var moveDir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = moveDir * speed
	
func playerAnim():
	if velocity.length() == 0:
		if attackDetector == false: #attack yapmıyorsam
			playerAnition.stop() #animasyonları durdur
	else:
		if attackDetector == false: #attack yapmıyorsam
			var dir = "Up"
			$HandPos.rotation_degrees = 90
			if velocity.x > 0 :
				dir = "Right"
				$HandPos.rotation_degrees = 0
			elif velocity.x < 0 :
				dir = "Left"
				$HandPos.rotation_degrees = 180
			elif velocity.y < 0 :
				dir = "Down"
				$HandPos.rotation_degrees = -90
			playerAnition.play("walk" + dir)

func shoot():
	if Global.flameSwordBought == true:
		var flameSwordInstance = flameSword.instantiate()
		add_child(flameSwordInstance)
		flameSwordInstance.setDamage(dmg)
		flameSwordInstance.transform = $HandPos.transform
		flameSwordInstance.position = $HandPos.global_position
	else:
		var s = sword.instantiate()
		add_child(s)
		s.setDamage(dmg)
		s.transform = $HandPos.transform
		s.position = $HandPos.global_position

#sütlü köpüklü, canga
func swordPickUP():
	if amount == 3:
		return false
	else:
		amount += 1
		return true


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		if amount > 0:
			amount = amount - 1
			shoot()

func attack():
	if Input.is_action_just_pressed("attack"):
		Global.playerCurrentAttack = true #attack yapabiliyorum
		attackDetector = true #attack
		var dir = currentDir
		if velocity.x < 0:
			dir = "Left"
			$dealAttackTimer.start()
			playerAnition.play("attack" + dir)
		elif velocity.x > 0:
			dir = "Right"
			$dealAttackTimer.start()
			playerAnition.play("attack" + dir)
		elif velocity.y < 0:
			dir = "Down"
			$dealAttackTimer.start()
			playerAnition.play("attack" + dir)
		elif velocity.y > 0:
			dir = "Up"
			$dealAttackTimer.start()
			playerAnition.play("attack" + dir)

func _physics_process(delta):
	$HUD/globalCoin.text = str(Global.coin)
	movement()
	playerAnim()
	enemyAttack()
	move_and_slide()
	attack()
	if health <= 0:
		playerAlive = false
		health = 0
		self.queue_free()

func player():
	pass

func hurt():
	$HUD/hpbar.value-=0.5
	if $HUD/hpbar.value==0:
		get_tree().reload_current_scene()

func _on_hit_box_body_entered(body):
	if body.has_method("enemy"):
		enemyInAttackRange = true #enemy'i görüyor muyuz?

func _on_hit_box_body_exited(body):
	if body.has_method("enemy"):
		enemyInAttackRange = false

func healed():
	if $HUD/hpbar.value == 3:
		return false
	else:
		$HUD/hpbar.value += 0.5
		return true

func enemyAttack():
	if enemyInAttackRange and enemyAttackCooldown == true:
		health = health - 15
		enemyAttackCooldown = false
		$attackCooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	enemyAttackCooldown = true

func _on_deal_attack_timer_timeout():
	$dealAttackTimer.stop() #timer'ı bitir attack yapamaz hale sok
	Global.playerCurrentAttack = false #Global değişkende attack'ı kontrol etmek için false
	attackDetector = false #attack yapama
