extends Control

@export var radius: float = 64.0
@export var bg_color: Color = Color(0, 0, 0, 0.4)
@export var border_color: Color = Color.WHITE
@export var border_width: float = 2.0
@export var world_scale: float = 100.0
@export var enabled_auto_register: bool = true

@export var player_node: Node3D
@export var icons := {
	"player": Color("#e0e0e0"),
	"enemy": Color("#e83f6a"),
	"item": Color("#66c779")
}

var targets: Array = []

func _ready() -> void:
	var diam = radius*2
	size = Vector2(diam, diam)
	pivot_offset = Vector2(radius, radius)
	
	var viewport_size = get_viewport_rect().size
	position = Vector2(viewport_size.x - size.x - 32, 32)
	
	if enabled_auto_register: _auto_register()
	
func _process(_delta):
	targets = targets.filter(func(t):
		return is_instance_valid(t.node)
	)
	
	queue_redraw()
	_auto_register()
	
func _draw() -> void:
	var center = Vector2(radius, radius)
	
	# fundo do círculo
	draw_circle(center, radius, bg_color, true, -1.0, true)
	
	# borda do círculo
	draw_arc(center, radius, 0, TAU, 64, border_color, border_width, true)
	
	for t in targets:
		var node = t.node
		var type = t.type
		
		var world_pos = Vector2(node.global_position.x, node.global_position.z)
		var pos = _world_to_minimap(world_pos)
		
		if pos == null:
			continue
		
		var offset = pos - center
		var margin = 2.0
		var max_dist = radius - border_width - margin
		if offset.length() > max_dist:
			offset = offset.normalized() * max_dist
		pos = center + offset
		
		var color = icons.get(type, Color.YELLOW)
		draw_circle(pos, 3.0, color, true, -1.0, true)
	
func _world_to_minimap(world_pos: Vector2):
	if player_node == null:
		return null
	
	var center_pos = Vector2(player_node.global_position.x, player_node.global_position.z)
	var offset = world_pos - center_pos
	offset.x *= 1
	
	var angle = player_node.global_rotation.y
	
	var rotated = Vector2(
		offset.x * cos(angle) - offset.y * sin(angle),
		offset.x * sin(angle) + offset.y * cos(angle)
	)
	
	var scale = radius / world_scale
	
	return rotated * scale + Vector2(radius, radius)
	
func _auto_register():
	for type in icons.keys():
		var nodes = get_tree().get_nodes_in_group(type)
		
		for n in nodes:
			add_target(n, type)
	
func add_target(node: Node3D, type: String):
	for t in targets:
		if t.node == node:
			return
	targets.append({ "node": node, "type": type })
	
