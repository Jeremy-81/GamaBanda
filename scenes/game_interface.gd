extends CanvasLayer

@export var boss: Node
@export var player: Node

@onready var boss_name: Label = $MarginContainer/VBoxContainer/VBoxContainer/BossName
@onready var boss_life: ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/BossLife

@onready var player_name: Label = $MarginContainer/VBoxContainer/HBoxContainer/PlayerName
@onready var player_life: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/PlayerLife

var game_paused = false

func _ready() -> void:
	if boss:
		boss.boss_ready.connect(boss_interface_init)
		boss.boss_damage.connect(update_boss_life)
		boss.boss_died.connect(game_won)
	
	player.player_ready.connect(player_interface_init)
	player.life_changed.connect(update_player_life)
	player.player_died.connect(game_loose)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not game_paused:
			get_tree().paused = true
			%GamePaused.show()
			game_paused = true
		else:
			_on_continue_pressed()

func update_boss_life(hp) -> void:
	boss_life.value = hp

func update_player_life(hp) -> void:
	player_life.value = hp

func boss_interface_init(name_boss, hp) -> void:
	boss_name.text = name_boss
	boss_life.max_value = hp
	boss_life.value = hp

func player_interface_init(name_player, hp) -> void:
	player_name.text = name_player
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


func _on_continue_pressed() -> void:
	get_tree().paused = false
	game_paused = false
	%GamePaused.hide()


func _on_next_boss_pressed() -> void:
	get_tree().paused =false
	get_tree().change_scene_to_file("res://scenes/boss_fight.tscn")
