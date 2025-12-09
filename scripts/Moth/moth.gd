extends CharacterBody2D

var target_pos = Vector2.ZERO
var speed_normal = 5000
var speed_player = 5000 # 10000
var follow_method = "None" # none stays still, player follows, lamp goes to lamp, tempted doesn't allow capture
var temptation_range = 250
var temptation_lamp

func _physics_process(delta: float) -> void:

	if get_tree().get_nodes_in_group("Lamp").size() == 0:
		follow_method = "Player"

	elif follow_method == "Lamp":
		target_pos = nearest_lamp().position

	elif follow_method == "Tempted" and temptation_lamp.dead:
		follow_method = "Player"

	elif follow_method == "Player":
		
		# tempt the moths
		if (nearest_lamp().position.distance_to(global_position) < temptation_range) and !nearest_lamp().dead:
			follow_method = "Tempted"
			temptation_lamp = nearest_lamp()
			target_pos = nearest_lamp().position
			$tempted_particle.emitting = true
			$moth_tempted.play()
		
		else:
			target_pos = get_tree().get_first_node_in_group("Player").position


	if follow_method != "None":
		velocity = (target_pos - global_position).normalized()
		velocity *= (speed_player if (follow_method == "Player") else speed_normal) * delta
		move_and_slide()
		
		look_at(target_pos)
		rotate(90)

func nearest_lamp():
	
	if get_tree().get_nodes_in_group("Lamp").size() == 0:
		return null
		
	var closest = get_tree().get_first_node_in_group("Lamp")
	for lamp in get_tree().get_nodes_in_group("Lamp"):
		if lamp.position.distance_to(global_position) < closest.position.distance_to(global_position):
			closest = lamp
	return closest

func die():
	set_physics_process(false)
	$Sprite2D.hide()
	$moth_died.play()
	$death_particle.emitting = true
	await $moth_died.finished
	queue_free()

func _on_lamp_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Lamp"):
		die()
	elif body.is_in_group("Player") and follow_method == "Lamp":
		follow_method = "Player"
		$follow_particle.emitting = true
		$moth_follow.play()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if follow_method == "None":
		follow_method = "Lamp"
		$VisibleOnScreenNotifier2D.queue_free()
