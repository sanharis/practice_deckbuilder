class_name MapGenerator
extends Node

const X_DISTANCE := 25
const Y_DISTANCE := 30
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MAP_WIDTH := 9
const PATHS := 6
const MONSTER_ROOM_WEIGHT := 10.0
const SHOP_WEIGHT := 2.0
const CAMPFIRE_WEIGHT := 4.0
const TREASURE_WEIGHT := 0.4

@export var battle_pool : BattleStatsPool

var random_room_type_weights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.TREASURE: 0.0
}
var random_room_type_total_weight := 0.0
var map_data: Array[Array]


# Straight up map building
func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in FLOORS -1:
			current_j = _setup_connection(i, current_j)
	
	battle_pool.setup()
	
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_rooms: Array[Room] = []
		
		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DISTANCE, i * -Y_DISTANCE) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			# Boss Room has a non-random Y
			if i == FLOORS - 1:
				current_room.position.y = FLOORS * -Y_DISTANCE
			
			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	
	return result

func _get_random_starting_points() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 3:
		unique_points = 0
		y_coordinates = []
		
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH -1)
			
			if not y_coordinates.has(starting_point):
				unique_points += 1
			
			y_coordinates.append(starting_point)
	
	return y_coordinates

func _setup_connection(i: int, j: int) -> int:
	var next_room: Room = null
	var current_room := map_data[i][j] as Room
	
	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]
	
	current_room.next_rooms.append(next_room)
	
	return next_room.column

func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbor: Room
	var right_neighbor: Room
	
	if j > 0:
		left_neighbor = map_data[i][j-1]
	if j < MAP_WIDTH -1 :
		right_neighbor = map_data[i][j+1]
	
	if right_neighbor and room.column > j:
		for next_room: Room in right_neighbor.next_rooms:
			if next_room.column < room.column:
				return true
	
	if left_neighbor and room.column < j:
		for next_room: Room in left_neighbor.next_rooms:
			if next_room.column > room.column:
				return true
	
	return false

# Setting up Rooms
func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS -1][middle] as Room
	
	for j in MAP_WIDTH:
		var current_room := map_data[FLOORS -2][j] as Room
		
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
	
	boss_room.type = Room.Type.BOSS
	boss_room.battle_stats = battle_pool.get_random_battle_for_tier(3)

func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[Room.Type.CAMPFIRE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = MONSTER_ROOM_WEIGHT + CAMPFIRE_WEIGHT + SHOP_WEIGHT
	random_room_type_weights[Room.Type.TREASURE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_WEIGHT + SHOP_WEIGHT + TREASURE_WEIGHT
	
	random_room_type_total_weight = random_room_type_weights[Room.Type.TREASURE]

func _setup_room_types() -> void:
	var middle := ceili(FLOORS * 0.5)
	var pre_boss := FLOORS - 2
	# First floor is always a battle
	for room: Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MONSTER
			room.battle_stats = battle_pool.get_random_battle_for_tier(0)
	
	# Middle floor is always a treasure
	for room: Room in map_data[middle]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.TREASURE
	
	# Last floor is always campfire
	for room: Room in map_data[pre_boss]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.CAMPFIRE
	
	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)

func _set_room_randomly(room: Room) -> void:
	var campfire_below_4 := true
	var consecutive_campfire := true
	var consecutive_shop := true
	var campfire_13 := true
	
	var type_candidate: Room.Type
	
	while campfire_below_4 or consecutive_campfire or consecutive_shop or campfire_13:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var is_shop := type_candidate == Room.Type.SHOP
		var has_campfire_parent := _room_has_parent_of_type(room, Room.Type.CAMPFIRE)
		var has_shop_parent := _room_has_parent_of_type(room, Room.Type.SHOP)
		
		campfire_below_4 = is_campfire and room.row <3
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shop = is_shop and has_shop_parent
		campfire_13 = is_campfire and room.row == (FLOORS - 3)
	
	room.type = type_candidate
	
	if type_candidate == Room.Type.MONSTER:
		var monster_room_tier := 0
		
		if room.row > (FLOORS / 3):
			monster_room_tier = 1
		if room.row > (FLOORS / 1.5):
			monster_room_tier = 2
		
		room.battle_stats = battle_pool.get_random_battle_for_tier(monster_room_tier)

func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents : Array[Room] = []
	
	# Left parent
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row -1][room.column -1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# Parent below
	if room.row > 0:
		var parent_candidate := map_data[room.row -1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	# Right parent
	if room.column < MAP_WIDTH -1 and room.row > 0:
		var parent_candidate := map_data[room.row -1][room.column +1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true
	
	return false

func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.TREASURE
