extends CharacterBody2D
@export var speed:float

signal slime_collieded(body:Node2D)
var hp:int = 10
var is_first_time:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass




func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Slime根节点已经接收到撞击信号，信号源：",body)
	slime_collieded.emit(body)
	
func _physics_process(delta: float) -> void:
	
	pass
	

	
	
	
