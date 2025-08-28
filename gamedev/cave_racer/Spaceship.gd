extends CharacterBody2D

var grav = 150.0
var res = 0.5
var speed := 0.0
var acceleration := 1.5
var rotation_speed := 1.0
var rotation_acceleration := 0.5
var rotation_direction = 0.0
var max_speed = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	get_input()
	pass
	

func get_input():
	if(Input.get_axis("DOWN_2", "UP_2")>0&&speed<max_speed):
		speed+=acceleration
	elif(Input.get_axis("DOWN_2", "UP_2")<0&&speed>-max_speed):
		speed-=acceleration
	velocity = -transform.y * speed

#func gravity(delta):

	
func _physics_process(delta):
	get_input()
#	rotation_speed += rotation_acceleration*Input.get_axis("LEFT", "RIGHT")
	rotation += rotation_speed * delta*Input.get_axis("LEFT_2", "RIGHT_2")
	if(!is_on_floor()):
		velocity.y += grav
	#resistance
	if(speed>10.0):
		speed -= res
	elif(speed<-10.0):
		speed += res
		
	move_and_slide()
	
	
