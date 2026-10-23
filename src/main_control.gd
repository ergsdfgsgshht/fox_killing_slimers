extends Node2D
@export var is_gameover:bool = false
var start_menu:Node2D
var over_menu:Node2D
var player:CharacterBody2D
var slimers: Array[Node]
var over_times: int = 0
@export var slimer_numbers:int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#加载start menu
	var start_menu_scene = preload("res://scenes/start_menu.tscn")
	start_menu = start_menu_scene.instantiate()
	add_child(start_menu)
	start_menu.position = Vector2(0,-6)
	start_menu.start_game.connect(_on_start_game)
	
	#预加载失败界面menu
	var menu_scene = preload("res://scenes/menu.tscn")
	over_menu = menu_scene.instantiate()
	
	#预加载玩家
	var player_scene = preload("res://scenes/player.tscn")
	player = player_scene.instantiate()
	
	#预加载slimers
	var slimerscenes = []
	for i in range(slimer_numbers):
		slimerscenes.append(preload("res://scenes/slime.tscn"))
	for i in range(slimer_numbers):
		var slimer_instance = slimerscenes[i].instantiate()
		slimers.append(slimer_instance)
		
	
	
func _on_start_game() -> void:
	print("点击开始，游戏启动")
	if !is_gameover:
		remove_child(start_menu)
	if is_gameover:
		is_gameover = false
	
	#加载玩家位置
	add_child(player)
	player.position = Vector2(-202,98)
	player.player_state = player.PlayerState.STANDING
	
	#加载slimers位置
	for i in range(slimer_numbers):
		var slimer_pos = Vector2(randi_range(-87,193),randi_range(-115,88))
		add_child(slimers[i])
		slimers[i].position = slimer_pos
		if over_times == 0:
			slimers[i].slime_collieded.connect(_on_slime_collied)
		
	
	
	
func _on_slime_collied(body:Node2D):
	print("主根节点接受到碰撞信号，信号源：",body)
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
	remove_child(player)
	for i in range(slimer_numbers):
		remove_child(slimers[i])
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
	pass
