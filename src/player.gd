extends CharacterBody2D
class_name Player

@export var speed:float
@onready var animation_player = $AnimatedSprite2D
enum PlayerState {STANDING,MOVING,DIED}
@onready var player_state = PlayerState.STANDING
var count:int = 0
var ttl : int = 0 #用于判定还有多少物理帧以后可以发射
var to_mouse: Vector2 = Vector2.RIGHT #瞄准方向（可能被锁定为最后一次合法值），初始朝右与初始朝向一致
const AIM_LINE_LENGTH := 100000.0 #瞄准线长度，大到视觉上等于无限远

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ttl = 30
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if ttl > 0:
		ttl -= 1
	var inputs = Input.get_vector("left","right","up","down")
	var can_move = inputs!=Vector2.ZERO
	face_mouse(can_move, inputs)
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
		velocity = Vector2.ZERO
		move_and_slide()
		
# 决定角色朝向：静止时按鼠标方位翻转；移动时按左右移动方向翻转；纯上下移动不改朝向
# 瞄准方向 to_mouse 只允许在面向的 180 度半平面内，鼠标越界时锁定为最后一次合法值
func face_mouse(can_move: bool, inputs: Vector2) -> void:
	var raw: Vector2 = get_global_mouse_position() - global_position
	if not can_move:
		animation_player.flip_h = raw.x < 0
	elif inputs.x != 0:
		animation_player.flip_h = inputs.x < 0
	#面向右侧时合法范围是右半平面(raw.x>=0)，面向左侧时是左半平面(raw.x<=0)，正上/正下属于边界两边都合法
	var legal: bool = raw.x >= 0 if not animation_player.flip_h else raw.x <= 0
	if legal and raw != Vector2.ZERO: #鼠标正好压在角色中心时方向无定义，跳过以保留旧值
		to_mouse = raw
	queue_redraw()

# 自定义绘制只能写在 _draw() 里；起点跟随翻转状态换到面向的一侧，方向用（可能被锁定的）to_mouse
func _draw() -> void:
	var start: Vector2 = Vector2(-25, 0) if animation_player.flip_h else Vector2(25, 0)
	draw_line(start, to_mouse.normalized() * AIM_LINE_LENGTH, Color(1, 0, 0, 0.2), 1.0)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if ttl == 0:
			var bullet= get_parent().bullet_scene.instantiate()
			add_child(bullet)
			bullet.position = Vector2(-25, 0) if animation_player.flip_h else Vector2(25, 0)
			bullet.parent_status = to_mouse.normalized()
			bullet.parent_init_speed = velocity
			bullet.reparent(get_parent())
			ttl = 60
			
	
		
	
	
	
	
	
