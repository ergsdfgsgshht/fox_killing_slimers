extends Node2D
@export var is_gameover:bool = false
var start_menu:Node2D
var over_menu:Node2D
var player:CharacterBody2D
var bullet_scene:Resource
var slimers: Array[Node]
var over_times: int = 0
var bullet_number:int = 30
@onready var camera = $Camera2D2
@export var slimer_numbers:int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#加载start menu
	var start_menu_scene = preload("res://scenes/start_menu.tscn")
	start_menu = start_menu_scene.instantiate()
	add_child(start_menu)
	start_menu.position = Vector2(0,-6)
	start_menu.start_game.connect(_on_start_game)
	start_menu.scale = Vector2(2.0,2.0)
	#预加载失败界面menu
	var menu_scene = preload("res://scenes/menu.tscn")
	over_menu = menu_scene.instantiate()
	
	#预加载玩家
	var player_scene = preload("res://scenes/player.tscn")
	player = player_scene.instantiate()
	
	
	#预加载slimers
	var slimerscenes:Resource
	for i in range(slimer_numbers):
		slimerscenes = preload("res://scenes/slime.tscn")
	for i in range(slimer_numbers):
		var slimer_instance = slimerscenes.instantiate()
		slimers.append(slimer_instance)
		
	#预加载bullet_scene
	bullet_scene = preload("res://scenes/bullet.tscn")
		
		
	
	
func _on_start_game() -> void:
	print("点击开始，游戏启动")
	if !is_gameover:
		remove_child(start_menu)
	if is_gameover:
		is_gameover = false
	
	#加载玩家位置
	add_child(player)
	player.position = Vector2(0,0)
	player.player_state = player.PlayerState.STANDING
	
	#加载slimers位置
	for i in range(slimer_numbers):
		var scope = randi_range(1,4)
		var slimer_pos:Vector2
		if scope == 1:
			slimer_pos = Vector2(randf_range(-828,-158),randf_range(-403,-87))
		if scope == 2:
			slimer_pos = Vector2(randf_range(177,812),randf_range(-392,-77))
		if scope == 3:
			slimer_pos = Vector2(randf_range(-821,-137),randf_range(86,381))
		if scope == 4:
			slimer_pos = Vector2(randf_range(129,803),randf_range(76,376))
		slimers[i].position = slimer_pos
		add_child(slimers[i])
		if over_times == 0:
			slimers[i].slime_collieded.connect(_on_slime_collied)
	
	camera.zoom = Vector2(2.515,2.455)
	camera.reparent(player)
	camera.position = Vector2.ZERO  #reparent默认保持全局位置，会残留偏移；归零让相机正对玩家
		
	
	
	
func _on_slime_collied(body:Node2D):
	if body.name == "Player":
		print("玩家撞到怪物，游戏结束")
		_game_over()
	pass

func _game_over() -> void:
	if is_gameover:
		return;
	is_gameover = true
	over_times += 1
	player.player_state = player.PlayerState.DIED
	await get_tree().create_timer(2.3).timeout
	camera.reparent(self)
	camera.position = Vector2.ZERO
	camera.zoom = Vector2(1.035,1.41)
	remove_child(player)
	for i in range(slimer_numbers):
		NodeUtils.safe_remove_child(self,slimers[i])
	add_child(over_menu)
	over_menu.position = Vector2(-178,-107)
	print("overtimes的值为",over_times)
	if over_times == 1:
		over_menu.menu_respawn.connect(_on_menu_respawn)
		over_menu.menu_exit.connect(_on_menu_exit)

func _on_menu_respawn() -> void:
	remove_child(over_menu)
	_on_start_game()
	pass
	
func _on_menu_exit() -> void:
	print("！！收到退出信号")
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if bullet_number != 0:
		pass
	pass
