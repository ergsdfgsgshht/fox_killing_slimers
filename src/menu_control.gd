extends Node2D

signal menu_respawn
signal menu_exit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_respawn_pressed() -> void:
	menu_respawn.emit()
	pass # Replace with function body.


func _on_exit_button_up() -> void:
	menu_exit.emit()
	pass # Replace with function body.
