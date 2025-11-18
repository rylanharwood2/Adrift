extends Resource
class_name MinHeap

# { "key": unique_identifier, "priority" : float }
# Priority = distance to player for the homing missile
# Priority could = score later for the leaderboard

var _data : Array = []

# Helper functions
func size() -> int:
	return _data.size()
	
func is_empty() -> bool:
	return _data.is_empty()
	
func clear() -> void:
	_data.clear()
	

# Public facing API ----------------------------------------------------------------

# ADD (key, priority)
func push(key, priority : float) -> void:
	var entry = {"key": key, "priority": priority}
	_data.append(entry)
	_heapify_up(_data.size() - 1)

# Remove and return the smallest-priority item
func pop_min():
	if _data.is_empty():
		return null
	
	var min_item = _data[0]
	_data[0] = _data.back()
	_data.remove_at(_data.size() - 1)
	if not _data.is_empty():
		_heapify_down(0)
	return min_item
	
# Update the priority of a specific key (remove + reinsert)
func update(key, new_priority : float) -> void:
	for i in range(_data.size()):
		if _data[i]["key"] == key:
			_data[i]["priority"] = new_priority
			_heapify_up(i)
			_heapify_down(i)
			return
	
# Remove an entry by key
func remove(key) -> void:
	for i in range(_data.size()):
		if _data[i]["key"] == key:
			_data[i] = _data.back()
			_data.remove_at(_data.size() - 1)
			if i < _data.size():
				_heapify_up(i)
				_heapify_down(i)
			return
	
# Peek at smallest (closest enemy)
func peek_min():
	if _data.is_empty():
		return null
	return _data[0]


# Internal Heap Logic ------------------------------------------------------------

func _heapify_up(index : int) -> void:
	while index > 0:
		var parent = (index - 1) / 2
		if _data[index]["priority"] < _data[parent]["priority"]:
			_swap(index, parent)
			index = parent
		else:
			break

func _heapify_down(index: int) -> void:
	var heap_size = _data.size()
	while true:
		var left = index * 2 + 1
		var right = index * 2 + 2
		var smallest = index
		
		if left < heap_size and _data[left]["priority"] < _data[smallest]["priority"]:
			smallest = left
		if right < heap_size and _data[right]["priority"] < _data[smallest]["priority"]:
			smallest = right
			
		if smallest != index:
			_swap(index, smallest)
			index = smallest
		else:
			break
	
func _swap(a: int, b: int) -> void:
	var temp = _data[a]
	_data[a] = _data[b]
	_data[b] = temp
