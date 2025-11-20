extends Node

# ---------------------------------------------------------
# INTERNAL MIN HEAP STORAGE
# Each entry: { "enemy": Node2D, "distance": float }
# ---------------------------------------------------------
var _heap: Array = []

# Player reference
var player: Node2D

# Update frequency
const UPDATE_RATE := 0.1
var _update_timer := 0.0


func _ready() -> void:
	# Find player once (or assign manually)
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("EnemyDistanceManager: No player found in group 'player'")
		
	set_process(true)


# ---------------------------------------------------------
# PUBLIC API
# ---------------------------------------------------------

func register_enemy(enemy: Node2D) -> void:
	# Calculate initial distance
	if not is_instance_valid(enemy):
		return
	if not is_inside_tree():
		return
	
	var dist = player.global_position.distance_to(enemy.global_position)
	_heap_push({"enemy": enemy, "distance": dist})
	
	# hopefully auto-unregister when freed
	enemy.tree_exited.connect(func(): unregister_enemy(enemy))


func unregister_enemy(enemy: Node2D) -> void:
	_heap_remove(enemy)


func get_closest() -> Node2D:
	if _heap.is_empty():
		return null

	# Clean up invalid enemies at the top
	while not _heap.is_empty() and (not is_instance_valid(_heap[0]["enemy"])):
		_heap_pop_min()

	if _heap.is_empty():
		return null

	return _heap[0]["enemy"]


# ---------------------------------------------------------
# PROCESS LOOP — updates distances every 0.1 sec
# ---------------------------------------------------------

func _process(delta: float) -> void:
	_update_timer += delta
	if _update_timer >= UPDATE_RATE:
		_update_timer = 0.0
		_recompute_distances()


func _recompute_distances() -> void:
	# Rebuild all distances
	for entry in _heap:
		if is_instance_valid(entry["enemy"]):
			entry["distance"] = player.global_position.distance_to(entry["enemy"].global_position)
		else:
			entry["distance"] = INF

	# Re-heapify entire array in O(n)
	_heapify_all()


# ---------------------------------------------------------
# INTERNAL HEAP IMPLEMENTATION
# ---------------------------------------------------------

func _heap_is_empty() -> bool:
	return _heap.size() == 0

func _heap_push(entry: Dictionary) -> void:
	_heap.append(entry)
	_heapify_up(_heap.size() - 1)

func _heap_pop_min():
	if _heap.is_empty():
		return null

	var min_entry = _heap[0]
	_heap[0] = _heap.back()
	_heap.remove_at(_heap.size() - 1)

	if not _heap.is_empty():
		_heapify_down(0)

	return min_entry

func _heap_remove(enemy: Node2D) -> void:
	for i in range(_heap.size()):
		if _heap[i]["enemy"] == enemy:
			# Replace with last
			_heap[i] = _heap.back()
			_heap.remove_at(_heap.size() - 1)
			if i < _heap.size():
				_heapify_up(i)
				_heapify_down(i)
			return


func _heapify_up(i: int) -> void:
	while i > 0:
		var p = (i - 1) / 2
		if _heap[i]["distance"] < _heap[p]["distance"]:
			_swap(i, p)
			i = p
		else:
			break

func _heapify_down(i: int) -> void:
	var size = _heap.size()
	while true:
		var l = i * 2 + 1
		var r = i * 2 + 2
		var min_i = i

		if l < size and _heap[l]["distance"] < _heap[min_i]["distance"]:
			min_i = l
		if r < size and _heap[r]["distance"] < _heap[min_i]["distance"]:
			min_i = r

		if min_i != i:
			_swap(i, min_i)
			i = min_i
		else:
			break

func _heapify_all() -> void:
	for i in range((_heap.size() / 2) - 1, -1, -1):
		_heapify_down(i)

func _swap(a: int, b: int) -> void:
	var tmp = _heap[a]
	_heap[a] = _heap[b]
	_heap[b] = tmp
