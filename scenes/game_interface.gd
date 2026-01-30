extends Control

@export var boss: Node
@export var player: Node

@onready var boss_name: Label = $MarginContainer/VBoxContainer/VBoxContainer/BossName
@onready var boss_life: ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/BossLife

@onready var player_name: Label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerName
@onready var player_life: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/PlayerLife

func _ready() -> void:
	boss.boss_ready.connect(boss_interface_init)
	boss.boss_damage.connect(update_boss_life)
	boss.boss_died.connect(game_won)
	
	player.player_ready.connect(player_interface_init)
	player.life_changed.connect(update_player_life)
	player.player_died.connect(game_loose)


func update_boss_life(hp) -> void:
	boss_life.value = hp

func update_player_life(hp) -> void:
	player_life.value = hp

func boss_interface_init(name, hp) -> void:
	boss_name.text = name
	boss_life.max_value = hp
	boss_life.value = hp

func player_interface_init(name, hp) -> void:
	player_name.text = name
	player_life.max_value = hp
	player_life.value = hp


func game_won() -> void:
	get_tree().paused = true
	%GameWon.show()
	
func game_loose() -> void:
	get_tree().paused = true
	%GameOver.show()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
