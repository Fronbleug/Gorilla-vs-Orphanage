extends Control


onready var music = preload("res://audio/MainMenu.wav")

func _ready():
	if audio.stream != music:
		audio.stream = music
		audio.play()

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/screens/Game.tscn")


func _on_Button2_pressed():
	get_tree().quit()
