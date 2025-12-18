extends Node2D

var max_score = 60

func _on_music_finished() -> void:
	$music.play()


func _on_end_body_entered(body: Node2D) -> void:
	
	Score.moths = get_tree().get_nodes_in_group("Moth").size()
	
	if body.is_in_group("Player"):
		if (Score.moths + Score.lamps) >= (max_score * (2.0/3.0)):
			$anim.play("fade out birds")
		else:
			$anim.play("fade out")
		await $anim.animation_finished
		get_tree().change_scene_to_file("res://Scenes/outro.tscn")
