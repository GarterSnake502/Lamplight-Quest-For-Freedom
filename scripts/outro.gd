extends Control

var final_score
var max_score = 59
var message

func _ready() -> void:
	final_score = Score.moths + Score.lamps
	
	if (final_score >= (max_score * (2.0/3.0))):
		$music_victory.play()
	else:
		$music_loss.play()
	
	$RichTextLabel.text = "Mission Results\nMoths: " + str(Score.moths) + "\nLamps: " + str(Score.lamps) + "\nFinal Score: " + str(final_score)

	$anim.play("scroll out")
	await $anim.animation_finished

	if final_score == max_score:
		$message.text = "Through your noble bravity, the moths have been avenged for their suffering, and the Earth is theirs. Congrats!"
	elif final_score >= (max_score * (2.0/3.0)):
		$message.text = "Some humans resist, but few succeed. You have restored Earth's natural order."
	elif (Score.moths > 0):
		if final_score >= (max_score * (1.0/3.0)):
			$message.text = "You saved a few moths, but humans still rule. Try harder next time."
		else:
			$message.text = "You saved some, but they didn't last long. Hope you enjoy King Edison."
	else:
		$message.text = "You killed all the moths and disrupted the world forever. May your own mind destroy you, as you yourself have destroyed."

	$anim.play("message")
	await $anim.animation_finished

func _process(delta: float) -> void:

	if Input.is_action_just_pressed("Jump"):
		Score.moths = 0
		Score.lamps = 0
		$anim.play("fade out")
		await $anim.animation_finished
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
