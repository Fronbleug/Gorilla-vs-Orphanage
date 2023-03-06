extends LivingGrabObject

export (StreamTexture) var texture

func _ready():
	add_to_group("Child")
	get_tree().root.get_node("Game").Children.append(self)
	


func Hurt(damage):
	.Hurt(damage)
	$TextureProgress.value = Hp
func Die():
	var index = get_tree().root.get_node("Game").Children.find(self)
	if index != -1:
		get_tree().root.get_node("Game").Children.remove(index)
	.Die()
