extends Node2D

@export var start_open := true;

func _ready():
	if !start_open:
		for i in range($LeftSide.get_child_count()):
			var curtain : Sprite2D = $LeftSide.get_child(i);
			curtain.modulate = Color.WHITE;
			curtain = $RightSide.get_child(i);
			curtain.modulate = Color.WHITE;
	pass;


func open_curtains() -> void:
	$OpenLeft.show();
	$OpenRight.show();
	var curtain_tween = create_tween();
	for i in range($LeftSide.get_child_count()):
		var subtween = create_tween();
		var curtain : Sprite2D = $LeftSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i + 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(0, 0, 0, 0), 0.25);
		curtain_tween.tween_subtween(subtween);
		curtain_tween.parallel();
		
		subtween = create_tween();
		curtain = $RightSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i + 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(0, 0, 0, 0), 0.25);
		curtain_tween.tween_subtween(subtween);
		pass;
	curtain_tween.play();
	pass;

func close_curtains() -> void:
	$OpenLeft.hide();
	$OpenRight.hide();
	$LeftSide.show();
	$RightSide.show();
	var curtain_tween = create_tween();
	
	for i in range($LeftSide.get_child_count() - 1, 0, -1):
		var subtween = create_tween();
		var curtain : Sprite2D = $LeftSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i - 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(255, 255, 255, 255), 0.25);
		curtain_tween.tween_subtween(subtween);
		curtain_tween.parallel();
		
		subtween = create_tween();
		curtain = $RightSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i - 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(255, 255, 255, 255), 0.25);
		curtain_tween.tween_subtween(subtween);
		pass;
	curtain_tween.play();
	pass;
