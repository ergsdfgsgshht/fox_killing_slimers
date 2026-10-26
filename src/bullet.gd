extends CharacterBody2D
class_name Bullet
@export var speed: float

signal destroy_self
var is_exploding := false

var parent_status:Vector2
var parent_init_speed:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BombEffect.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_exploding:
		return
	print(parent_init_speed)
	velocity = parent_status * speed + parent_init_speed
	rotation = parent_status.angle()
	move_and_slide()
	if get_slide_collision_count() > 0:
		var collider = get_last_slide_collision().get_collider()
		#用类型判断史莱姆：实例化时Godot会自动改名(Slime2、Slime3...)，按名字"Slime"匹配只能碰到第一只
		if collider.name == "MapEdge" or collider is Slime:
			print("!!!!!发生碰撞")
			is_exploding = true
			$BombEffect.visible = true
			$BombEffect.play("bomb")
			$Sprite2D.visible = false
			if collider is Slime:
				collider.being_attack()
			destroy_self.emit()


func _on_destroy_self() -> void:
	#等爆炸动画播放完再销毁，期间子弹停在原地(is_exploding)
	await get_tree().create_timer(0.8).timeout
	queue_free()
	pass # Replace with function body.
