extends Control

var sayings = ["Long ago, before men ever set foot on earth, moths ruled the land.\n\n\n\n\n\n\n[center][Press SPACE to continue][/center]",
"For a time, there was peace; moths feasted on fruit, and all was good.",
"Yet, the humans, jealous of the moth's superiority, unleashed their ultimate weapon: [b]THOMAS EDISON.[/b]",
"Who developed their [b]TRUE[/b] weapon: [shake][b]THE LAMP[/b][/shake].",
"Drawn by its lurid luminosity, moths sought the lamps, unaware of the intense electrical flow brought on by Edison's reckless experiments.",
"Their only hope was to send a fly, resistant to the lamps' lure, able to extinguish mankind's defense once and for all.",
"You have one goal: [i]BREAK THE LAMPS.[/i]"]
var index = 0

func _ready() -> void:
	$RichTextLabel.text = sayings[index]
	index += 1
	$anim.play("scroll out")

func _process(delta: float) -> void:

	if Input.is_action_just_pressed("Jump"):
		if index < sayings.size():
			$RichTextLabel.text = sayings[index]
			index += 1
			$anim.play("scroll out")
	
		elif index == sayings.size():
				$anim.play("LAMPLIGHT")
				index += 1
		elif $anim.assigned_animation != "fade out":
			$anim.play("fade out")
			await $anim.animation_finished
			get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
