extends Node2D


func _ready():
	$Player/CameraTransform.remote_path = $Camera2D.get_path();
	pass;
