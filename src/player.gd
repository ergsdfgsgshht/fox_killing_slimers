extends CharacterBody2D

@export var speed:float
@onready var animation_player = $AnimatedSprite2D
enum PlayerState {STANDING,MOVING,DIED}
@onready var player_state = PlayerState.STANDING
var count:int = 0
var ttl : int = 0 #用于判定还有多少物理帧以后可以发射
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if ttl > 0:
		ttl -= 1
	var inputs = Input.get_vector("left","right","up","down")
	var can_move = inputs!=Vector2.ZERO
	if player_state == PlayerState.DIED:
		animation_player.play("died")
		return
	if can_move:
		if player_state == PlayerState.STANDING:
			animation_player.play("跑步")
			player_state = PlayerState.MOVING
		velocity = Vector2(inputs*speed)
		move_and_slide()
	else:
		animation_player.play("待机")
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if ttl == 0:
			var bullet= preload("res://scenes/bullet.tscn").instantiate()
			add_child(bullet)
			bullet.position = Vector2(25,0)
			ttl = 60
			
	
		
	
	
	
	
	
