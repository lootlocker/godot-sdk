extends Node
class_name LLInternal_LootLockerCache

static var _instance : LLInternal_LootLockerCache = null

var data: Dictionary = {}

# TODO: Test if this info is saved properly in WebGL
var filename: String = "LootLockerCache.dat"
var path: String = "user://"

signal data_changed(key: String, value)

static func current():
	if(_instance == null):
		_instance = LLInternal_LootLockerCache.new()
	return _instance
	
func _init():
	path = path + filename
	if not FileAccess.file_exists(path):
		save_lootlocker_data()
	else:
		load_lootlocker_data()

func set_data(key: String, value):
	data[key] = value
	data_changed.emit(key, value)
	await save_lootlocker_data()

func get_data(key: String, default_value):
	if data.has(key):
		return data[key]
	else:
		return default_value

func delete_data(key: String):
	if data.has(key):
		data.erase(key)
		await save_lootlocker_data()

func save_lootlocker_data():
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_lootlocker_data():
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		data = file.get_var()
	else:
		save_lootlocker_data()
	file.close()
	
func clear():
	DirAccess.remove_absolute(path)
	_instance = null
	
func print_cache():
	print(JSON.stringify(data, '\t'))
