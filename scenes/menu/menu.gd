extends Control

@onready var sound_button: TextureButton = %SoundButton

var sound_mode = true

func _ready() -> void:
	if AudioServer.is_bus_mute(0):
		sound_button.texture_normal = preload("uid://dxlnthvlg3u8t")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/backstage_1/backstage_1.tscn")

func _on_play_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/boss_fight.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_texture_button_pressed() -> void:
	if sound_mode:
		sound_mode = false
		sound_button.texture_normal = preload("uid://dxlnthvlg3u8t")
		AudioServer.set_bus_mute(0, true)
	else:
		sound_mode = true
		sound_button.texture_normal = preload("uid://cqdfvbsup22tp")
		AudioServer.set_bus_mute(0, false)


func _on_button_back_pressed() -> void:
	%MenuContainer.show()
	%CreditsContainer.hide()

func _on_credits_pressed() -> void:
	%CreditsContainer.show()
	%MenuContainer.hide()
