extends StaticBody2D

var Active = false


func use():
	Active = !Active
	$CollisionShape2D.disabled = Active
	$Sprite.visible = !Active
