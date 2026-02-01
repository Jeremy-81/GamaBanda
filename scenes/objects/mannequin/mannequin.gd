extends Hurtbox

var has_fallen := false;

signal pushed;
signal fell;

func push_animation(direction : int):
	var tween := create_tween();
	tween.tween_property($Body, "rotation", direction * PI * 0.2, 0.1);
	tween.tween_property($Body, "rotation", direction * -PI * 0.1, 0.1);
	tween.tween_property($Body, "rotation", 0.0, 0.05);
	tween.tween_callback(func(): pushed.emit());
	tween.play();
	pass;

func fall_animation(direction : int):
	has_fallen = true;
	var tween := create_tween();
	tween.tween_property($Body, "rotation", direction * PI / 2.0, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT);
	tween.parallel();
	tween.tween_property($Body, "position:y", 8, 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT);
	tween.parallel();
	tween.tween_property($Foot, "rotation", direction * PI / 2.0, 0.5);
	tween.parallel();
	tween.tween_property($Foot, "position:y", 8, 0.5);
	tween.tween_callback(func(): fell.emit());
	tween.play();
	$FallParticles.position *= -direction;
	$FallParticles.restart();
	pass;

func _on_damaged(_damage, ko_damage, damage_dealer):
	if has_fallen: return;
	
	var direction : int = sign(global_position.x - damage_dealer.position.x);
	if ko_damage > 0.0:
		fall_animation(direction);
	else:
		push_animation(direction);
	pass;
