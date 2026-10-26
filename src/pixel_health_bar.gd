class_name PixelHealthBar
extends Control
## Godot 4.x pixel health bar. Assign current_health directly.

@export var max_health: float = 100.0
@export var current_health: float = 100.0

const DEFAULT_SIZE := Vector2(160.0, 16.0)
const BORDER_COLOR := Color(1.0, 1.0, 1.0, 1.0)
const HEALTH_COLOR := Color(1.0, 0.0, 0.0, 1.0)
const LOST_COLOR := Color(0.85, 0.85, 0.85, 0.35)

var _display_ratio: float = -1.0
var _last_pixel_size := Vector2i(-1, -1)


static func create(total_health: float, initial_health: float) -> PixelHealthBar:
	# No scene preload: avoid cyclic script/scene dependencies.
	var bar := PixelHealthBar.new()
	bar.max_health = total_health
	bar.current_health = initial_health
	bar._sync_display()
	return bar


func _init() -> void:
	custom_minimum_size = Vector2(3.0, 3.0)
	size = DEFAULT_SIZE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _ready() -> void:
	# Also initializes instances loaded from the .tscn before first drawing.
	_sync_display()


func _process(_delta: float) -> void:
	_sync_display()


func _health_ratio() -> float:
	if not is_finite(max_health) or max_health <= 0.0:
		return 0.0
	if not is_finite(current_health):
		return 0.0
	return clampf(current_health / max_health, 0.0, 1.0)


func _sync_display() -> void:
	var ratio := _health_ratio()
	var pixel_size := Vector2i(int(floor(size.x)), int(floor(size.y)))
	if ratio != _display_ratio or pixel_size != _last_pixel_size:
		_display_ratio = ratio
		_last_pixel_size = pixel_size
		queue_redraw()


func _draw() -> void:
	var width := int(floor(size.x))
	var height := int(floor(size.y))
	if width < 3 or height < 3:
		return
	# Separate opaque border strips: no opaque background under lost health.
	draw_rect(Rect2(0, 0, width, 1), BORDER_COLOR)
	draw_rect(Rect2(0, height - 1, width, 1), BORDER_COLOR)
	draw_rect(Rect2(0, 1, 1, height - 2), BORDER_COLOR)
	draw_rect(Rect2(width - 1, 1, 1, height - 2), BORDER_COLOR)
	var inner_width := width - 2
	var inner_height := height - 2
	var filled := clampi(int(floor(inner_width * _display_ratio)), 0, inner_width)
	if filled > 0:
		draw_rect(Rect2(1, 1, filled, inner_height), HEALTH_COLOR)
	if filled < inner_width:
		draw_rect(Rect2(1 + filled, 1, inner_width - filled, inner_height), LOST_COLOR)
