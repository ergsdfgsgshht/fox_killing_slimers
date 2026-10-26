extends CharacterBody2D
class_name Slime
@export var speed:float
@export var initial_rand_speed:float
@export var k:float

signal slime_collieded(body:Node2D)
@export var hp:int 
var is_first_time:bool = true
var current_player:Node
var health_bar: Node
var ttl:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_player = get_parent().player
	velocity = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() * initial_rand_speed
	health_bar = PixelHealthBar.create(hp,hp)
	add_child(health_bar)
	health_bar.position = Vector2(-1,-8)
	health_bar.scale = Vector2(0.1,0.1)
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Slime根节点已经接收到撞击信号，信号源：",body)
	slime_collieded.emit(body)

#模拟万有引力系统	
func _physics_process(delta: float) -> void:
	if ttl > 0:
		ttl -= 1
	var displacement = current_player.position - position
	if displacement != Vector2.ZERO:
		#两者间距离(标量)
		var R = sqrt(displacement.x*displacement.x+displacement.y*displacement.y)
		var direction = displacement.normalized()  #方向向量
		var a:Vector2 = direction*k/(R*R)    #万有引力求加速度
		velocity = velocity + Vector2(a.x*delta,a.y*delta)  #相当于v=v0+at
		#撞墙前先保存速度：move_and_slide()碰撞后会把velocity改写成实际滑动后的结果
		var velocity_before = velocity
		move_and_slide()
		#撞到边界MapEdge时，把撞击前的速度沿碰撞面法线反射，实现反弹
		if get_slide_collision_count() > 0:
			var collision = get_last_slide_collision()
			velocity = velocity_before.bounce(collision.get_normal()) * 0.8
				
			if collision.get_collider() is Player:
				slime_collieded.emit(get_parent().player)

func being_attack() -> void:
	if ttl == 0:
		hp -= 1
		health_bar.current_health = hp
		ttl = 40
		if hp == 0:
			get_parent().remove_child(self)
	pass				
	

	
	
	
