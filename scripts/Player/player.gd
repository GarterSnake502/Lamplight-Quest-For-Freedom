extends CharacterBody2D

const PLAYABLE_SPEED: float = 500
const JUMP_VEL: float = -1000
const GRAVITY: float = 40
const MAX_FALL: float = 1000
const MAX_JUMPS: int = 3

const TEXTURES: Array[CompressedTexture2D] = [preload("res://assets/evil_fly_idle0.png"), preload("res://assets/evil_fly_idle1.png"), preload("res://assets/evil_fly_idle2.png"), preload("res://assets/evil_fly_idle3.png")]

var jumps_remaining: int = 3

var attacking: bool = false

func update_jumps(new_jumps):
	new_jumps = min(MAX_JUMPS, new_jumps)
	jumps_remaining = new_jumps
	$idle.texture = TEXTURES[new_jumps]

func _physics_process(delta):
	
	velocity.x = 0
	
	if Input.is_action_pressed("Move Right"):
		velocity.x = PLAYABLE_SPEED
		$idle.flip_h = false
		$attack.flip_h = false
		$attackZone.scale.x = 1
		
	if Input.is_action_pressed("Move Left"):
		velocity.x = -PLAYABLE_SPEED
		$idle.flip_h = true
		$attack.flip_h = true
		$attackZone.scale.x = -1
	
	if !(velocity.y >= MAX_FALL):
		velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("Jump") and jumps_remaining > 0:
		$anim.play("idle")
		jump()
		update_jumps(jumps_remaining - 1)
	elif is_on_floor():
		update_jumps(MAX_JUMPS)
		$idle.rotation = 0
		$anim.play("idle")
	
	if !attacking: # no animations, jumping, or refilling jumps
		if Input.is_action_just_pressed("attack"):
			attack()
		elif velocity.y > 0:
			$anim.stop()
	
	move_and_slide()

func jump() -> void:
	velocity.y = JUMP_VEL

func attack():
	#set_physics_process(false)
	attacking = true
	$anim.play("attack")
	await $anim.animation_finished
	attacking = false
	#set_physics_process(true)


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Lamp"):
		if $idle.flip_h:
			body.lamp_fall("left")
		else:
			body.lamp_fall("right")
		update_jumps(jumps_remaining +  1)
