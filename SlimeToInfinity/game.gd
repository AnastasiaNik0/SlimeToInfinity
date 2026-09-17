extends Node2D
@onready var player: CharacterBody2D = %Player
const CHUNK := 1024
var loaded := {}

func _process(_delta):
	var c := Vector2i((player.global_position / CHUNK).floor())
	for x in range(c.x - 1, c.x + 2):
		for y in range(c.y - 1, c.y + 2):
			var key := Vector2i(x, y)
			if key == Vector2i.ZERO:
				continue
			if not loaded.has(key):
				loaded[key] = _spawn_chunk(key)

func _spawn_chunk(key: Vector2i):
	var holder := Node2D.new()
	add_child(holder)
	var rng := RandomNumberGenerator.new()
	holder.y_sort_enabled = true  # Enables Y-sorting inside this chunk
	add_child(holder)
	
	rng.seed = hash(key)
	for i in 12:
		var t: Node2D = preload("uid://c2qg1nuvfnd4q").instantiate()
		t.position = Vector2(key * CHUNK) + Vector2(rng.randf(), rng.randf()) * CHUNK
		holder.add_child(t)
	return holder

func spawn_mob():
	%PathFollow2D.progress_ratio = randf()
	var new_mob = preload("res://mob.tscn").instantiate()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_depleted():
	%GameOver.show()
	get_tree().paused = true
