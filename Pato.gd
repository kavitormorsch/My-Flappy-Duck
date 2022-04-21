extends KinematicBody2D

var velocidade = Vector2()
var forca_pulo = 250
var gravidade = 500

var collidiu = 0
enum states {caindo, pulando} 
var state = states.caindo
signal ponto

var Pipes = preload("res://Pipes.tscn")



func _physics_process(delta):
	velocidade = move_and_slide(velocidade, Vector2.UP)
	if !Input.is_action_just_pressed("Jump"):
		change_states(0, delta)
	if state == states.caindo and Input.is_action_just_pressed("Jump"):
		change_states(1, delta)

	if rotation_degrees >= 90:
		rotation_degrees = 90


func change_states(new_state, delta):
	state = new_state
	
	match state:
		states.caindo:
			velocidade.y += gravidade * delta
			rotation += PI * delta
		states.pulando:
			pulo(delta)


func pulo(delta):
	velocidade.y = -forca_pulo
	rotation -= PI * delta * 40
	if rotation_degrees <= -60:
		rotation_degrees = -60



func _on_Area2D_area_entered(area):
	var pipeinstance = Pipes.instance()
	pipeinstance.position = Vector2(100, rand_range(-60, 60))
	get_parent().add_child(pipeinstance)
	emit_signal("ponto")
	





func _on_Area2D_body_entered(body):
	if body.name == "Pipes":
		queue_free()
