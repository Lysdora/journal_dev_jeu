extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 40.0

var is_not_dead: bool = true

var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2(0,1)

func _physics_process(delta: float) -> void:
	move_player()
	move_and_slide()


func move_player():
	
	if is_not_dead:
		direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed	
		#Enregister la derniere direction
		if direction != Vector2.ZERO:
			last_direction = direction.normalized()			
		#Animation
		if direction != Vector2.ZERO:
			if direction.x > 0:
				animated_sprite_2d.play("walk_right")
				# Déplacez la zone de dialogue complète	
			elif direction.x < 0:
				animated_sprite_2d.play("walk_left")	
			elif direction.y > 0:
				animated_sprite_2d.play("walk_down")
			elif direction.y < 0:
				animated_sprite_2d.play("walk_up")	
		else:
			if animated_sprite_2d.animation.begins_with("walk"):
				animated_sprite_2d.play(animated_sprite_2d.animation.replace("walk", "idle"))

func collect_item():
	pass
