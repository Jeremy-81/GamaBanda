extends Node2D

@onready var boss: CharacterBody2D = $Boss
@onready var player: CharacterBody2D = $Player

func _ready():
	$Player/CameraTransform.remote_path = $Camera2D.get_path()
