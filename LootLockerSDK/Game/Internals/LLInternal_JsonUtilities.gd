extends Node
class_name LLInternal_JsonUtilities

# Make into class from JSON
static func ObjectFromJsonString(json_string, data_to_set: Array, object : Object):
	return DictionaryToClass(DictionaryFromJsonString(json_string, data_to_set), object)

# Make into dictionary from JSON
static func DictionaryFromJsonString(json_string, data_to_set: Array):
	if json_string == null || json_string == "":
		return {}
	var dictionary = JSON.parse_string(json_string)
	if dictionary == null:
		return {}
	# Go through data_to_set and save those variables to LLInternal_LootLockerCache
	for i in dictionary.size():
		for j in data_to_set.size():
			if data_to_set[j] == dictionary.keys()[i]:
				LLInternal_LootLockerCache.current().set_data(dictionary.keys()[i], dictionary.values()[i])
			pass
	
	return dictionary
	
# Reduced implementation of https://github.com/fenix-hub/unirest-gdscript
# https://forum.godotengine.org/t/convert-dictionary-array-to-class-object/80807
static func DictionaryToClass( dict : Dictionary, object : Object ) -> Object:
	if dict == null || object == null:
		return object
	var properties : Array = object.get_property_list()
	for key in dict.keys():
		for property in properties:
			if property.name == key:
				if property.type == TYPE_OBJECT:
					var akjlsd = ClassDB.instantiate(property.class_name)
					object.set(key, DictionaryToClass(dict[key], akjlsd))
				else:
					object.set( key, dict[ key ] )
				break
	return object

static func ObjectToJsonString(object : Object, minimized : bool = true) -> String:
	return DictionaryToJsonString(ObjectToDictionary(object), minimized)

static func ObjectToDictionary(object : Object) -> Dictionary:
	if(object == null):
		return {}
	var dictionary = inst_to_dict(object)
	for key in dictionary:
		var field = dictionary[key]
		if field is Object:
			dictionary[key] = ObjectToDictionary(field)
		if field is Array:
			if (field as Array).is_empty():
				continue
			elif typeof((field as Array)[0]) != TYPE_OBJECT:
				continue
			var parsedObjectArray : Array[Dictionary]
			for val in (field as Array[Object]):
				parsedObjectArray.append(ObjectToDictionary(val))
			dictionary[key] = parsedObjectArray
	dictionary.erase("@path")
	dictionary.erase("@subpath")
	return dictionary

static func DictionaryToJsonString(dictionary : Dictionary, minimized : bool = true) -> String:
	if(dictionary == null):
		return "{}"
	if !minimized:
		return JSON.stringify(dictionary, '\t')
	return JSON.stringify(dictionary)
