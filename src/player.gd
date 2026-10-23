extends CharacterBody2D

@export var speed:float
@onready var animation_player = $AnimatedSprite2D
enum PlayerState {STANDING,MOVING,DIED}
@onready var player_state = PlayerState.STANDING
var count:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
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
		if player_state == PlayerState.MOVING:
			animation_player.play("待机")
			player_state = PlayerState.STANDING
			
	
		
	
	
	
	
	
