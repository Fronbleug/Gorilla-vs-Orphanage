extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func Start(speed, dir, pos):
	position = pos
	rotation = dir.angle()
	Velocity = dir * speed
	add_to_group("Bullet")
	$AnimationPlayer.play("Move")
	
func _physics_process(delta):
	Velocity = move_and_slide(Velocity)


func _on_Area2D_area_entered(area):
	if area.is_in_group("BreakObject"):
		area.Collided(Velocity,0.1)
	queue_free()
