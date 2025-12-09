extends CharacterBody2D

@export var health = 1
var dead = false

func lamp_fall(direction):
	dead = true
	$crash.play()
	$CollisionShape2D.queue_free()
	$anim.play("fall_" + direction)
	await $anim.animation_finished
	Score.lamps += 1
	queue_free()


func _on_buzz_finished() -> void:
	$buzz.play()
