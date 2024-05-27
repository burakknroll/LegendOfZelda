extends Node
class_name HealthComponent #class_name diğer scriptlerden erişebilir hale 
#getiriyoruz

#signal'in kullanım amacı ekstra kendimiz bir signal üretmek için...
signal died #ölmesi için 
signal healthChanged #can değişikliği için (can azalması)
signal healedPlayer #can artması için (can artması)

@export var maxHealth: float = 10 #maksimum can değeri
@export var healed: float = 10 #maksimum canlanma yani +hp değeri
var currentHealth #anlık can değeri

func _ready():
	currentHealth = maxHealth #en başta anlık can değerim maksimum can değerime
	#eşit

func damage(damageAmount: float):
	currentHealth = max(currentHealth - damageAmount, 0) #maksimum değerin üstüne
	#çıkmamızı önlüyor.
	healthChanged.emit() #singal çalışması için emit parametresini kullanırız.
	Callable(checkDeath).call_deferred()

func getHealthPercent():
	if maxHealth <= 0: 
		return 0 #hiç can alma
	return min(currentHealth / maxHealth, 1)

func health(healthAmount: float):
	currentHealth = max(currentHealth + healthAmount, 0)
	healedPlayer.emit()

func checkDeath():
	var enemy = is_in_group("enemy")
	if currentHealth <= 0:
		died.emit()
		if owner.is_in_group("enemy"):
			owner.queue_free()
		owner.queue_free()



