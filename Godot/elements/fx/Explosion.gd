extends Node2D

var explosion_time = 2.0

var touching_bodies = []

func _ready():
	$Timer.wait_time = explosion_time
	$Timer.start()
	SoundManager.play_FX("explosion")

func _physics_process(delta):
	#Just damage all the bodies in the area
	for body in touching_bodies:
		if body.has_method('hurt'):
			body.hurt(self)

func _on_DamageZone_body_entered(body):
	touching_bodies.append(body)


func _on_DamageZone_body_exited(body):
	touching_bodies.erase(body)


func _on_Timer_timeout():
	queue_free()
