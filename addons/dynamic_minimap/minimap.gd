extends Control

@export var radius: float = 64.0
@export var bg_color: Color = Color(0, 0, 0, 0.4)
@export var border_color: Color = Color.WHITE
@export var border_width: float = 2.0
@export var world_scale: float = 256.0

@export_subgroup("Setup")
@export var player_node: Node

@export_subgroup("Behavior")
@export var enabled_auto_register: bool = true
@export var clamp_to_border: bool = true
@export var rotate_with_player: bool = true

@export_subgroup("Icons")
@export var icons: Array[IconType]
#@export var icons := {
	#"player": Color("#e0e0e0"),
	#"enemy": Color("#e83f6a"),
	#"item": Color("#66c779")
#}
@export var icon_size: float = 16.0
@export var use_default_icons := true

@export_subgroup("Debug")
@export var show_debug: bool = false

var targets: Array = []

func _ready() -> void:
	var diam = radius*2
	size = Vector2(diam, diam)
	pivot_offset = Vector2(radius, radius)
	
	var viewport_size = get_viewport_rect().size
	position = Vector2(viewport_size.x - size.x - 32, 32)
	
	_auto_set_player()
	
	if enabled_auto_register: _auto_register()
	
	if use_default_icons and icons.is_empty():
		_load_default_icons()
	
func _load_default_icons():
	var base_path = "addons/dynamic_minimap/icons/default/"
	
	var defaults = [
		load(base_path + "player.tres"),
		load(base_path + "enemy.tres"),
		load(base_path + "item.tres")
	]
	
	for d in defaults:
		if d != null:
			icons.append(d)
	
func _process(_delta):
	if player_node == null:
		_auto_set_player()
	
	targets = targets.filter(func(t):
		return is_instance_valid(t.node)
	)
	
	queue_redraw()
	
	if enabled_auto_register: _auto_register()
	
func _draw() -> void:
	var center = Vector2(radius, radius)
	
	# fundo do círculo
	draw_circle(center, radius, bg_color, true, -1.0, true)
	
	# borda do círculo
	draw_arc(center, radius, 0, TAU, 64, border_color, border_width, true)
	
	for t in targets:
		var node = t.node
		var type = t.type
		
		var world_pos = _get_world_2d_pos(node)
		var pos = _world_to_minimap(world_pos)
		
		if pos == null:
			continue
		
		var offset = pos - center
		var margin = 2.0
		var max_dist = radius - border_width - margin
		
		if offset.length() > max_dist:
			if clamp_to_border:
				offset = offset.normalized() * max_dist
				pos = center + offset
			else:
				continue
		
		var data = _get_icon_data(type)
		
		if type == "player":
			if data != null and data.texture != null:
				_draw_icon_texture(pos, data.texture)
			else:
				_draw_player_icon(pos)
		elif data != null and data.texture != null:
			_draw_icon_texture(pos, data.texture)
		elif data != null:
			draw_circle(pos, 3.0, data.color, true, -1.0, true)
		else:
			draw_circle(pos, 3.0, Color.YELLOW, true, -1.0, true)
	
func _draw_player_icon(pos: Vector2):
	var size = 6.0
	
	# direção (pra cima)
	var points = [
		Vector2(0, -size),      # ponta
		Vector2(size * 0.6, size),
		Vector2(-size * 0.6, size)
	]
	
	# pegar rotação do player
	var angle := 0.0
	
	if not rotate_with_player:
		if player_node is Node3D:
			angle = player_node.global_rotation.y
		elif player_node is Node2D:
			angle = player_node.rotation
	
	# rotacionar pontos
	for i in range(points.size()):
		points[i] = points[i].rotated(angle) + pos
	
	var player_data = _get_icon_data("player")
	var color = player_data.color if player_data else Color.WHITE
	
	draw_colored_polygon(points, color)
	draw_polyline(points + [points[0]], Color.WHITE, 1.0, true)
	
func _draw_icon_texture(pos: Vector2, texture: Texture2D):
	var size = Vector2(icon_size, icon_size)
	
	draw_texture_rect(
		texture,
		Rect2(pos - size * 0.5, size),
		false
	)
	
func _get_icon_data(type: String) -> IconType:
	for i in icons:
		if i.type == type:
			return i
	return null
	
func _world_to_minimap(world_pos: Vector2):
	if player_node == null:
		return null
	
	var center_pos = _get_world_2d_pos(player_node)
	var offset = world_pos - center_pos
	
	var angle := 0.0
	
	if player_node is Node3D:
		angle = player_node.global_rotation.y
	elif player_node is Node2D:
		angle = player_node.rotation
	
	var rotated = offset
	if rotate_with_player:
		rotated = offset.rotated(-angle)
	
	var scale = radius / world_scale
	
	return rotated * scale + Vector2(radius, radius)
	
func _get_world_2d_pos(node) -> Vector2:
	if node is Node3D:
		return Vector2(node.global_position.x, node.global_position.z)
	elif node is Node2D:
		return node.global_position
	return Vector2.ZERO
	
func _auto_set_player():
	if player_node != null:
		# garante que está no grupo
		if not player_node.is_in_group("player"):
			player_node.add_to_group("player")
		return
	
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		player_node = players[0]
	else:
		if show_debug:
			print("Minimap: No player found in group 'player'")
	
func _auto_register():
	for icon_data in icons:
		var type = icon_data.type
		
		var nodes = get_tree().get_nodes_in_group(type)
		
		for n in nodes:
			add_target(n, type)
	
func add_target(node: Node, type: String):
	for t in targets:
		if t.node == node:
			return
	targets.append({ "node": node, "type": type })
	
