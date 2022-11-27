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


func _on_secretButton_pressed():
	global.Level = "res://scenes/levels/Debug.tscn"


func _on_settings_pressed():
	$WindowDialog.popup()


func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value -50)


func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1,value -50)


func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(2,value -50)
