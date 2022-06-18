extends AudioStreamPlayer2D



func start(audio):
	stream = audio
	play()


func _on_SFX_finished():
	queue_free()

