## Internal LootLocker utility class that is used to serialize and deserialize json
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
extends Node
class_name LootLockerInternal_JsonUtilities

#region From JSON
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
	# Go through data_to_set and save those variables to LootLockerInternal_LootLockerCache
	for i in dictionary.size():
		for j in data_to_set.size():
			if data_to_set[j] == dictionary.keys()[i]:
				preload("../Resources/LootLockerInternal_LootLockerCache.gd").current().set_data(dictionary.keys()[i], dictionary.values()[i])
			pass
	
	return dictionary
	
static func GetLootLockerObjectFromFieldReflection(fieldName : String, onClass : Object):
	var LLReflection : Dictionary = {}
	if onClass.has_method("__LootLockerInternal_GetReflection"):
		LLReflection = onClass.__LootLockerInternal_GetReflection()
	else:
		print("LootLocker reflection was requested for object without reflection defined. Field name was " + fieldName + ". Please reach out to the LootLocker team with this error")
	return LLReflection.get(fieldName, null)

## Converts a JSON dictionary into a Godot class instance.
## Based on https://github.com/EiTaNBaRiBoA/JsonClassConverter, but adapted for LootLocker Internal and specialized deserialization
static func DictionaryToClass(dict: Dictionary, castClass) -> Object:
	if dict == null:
		return null
	if castClass == null:
		return null
	# Create an instance of the target class
	var _class: Object = castClass.new() as Object
	var properties: Array = _class.get_property_list()

	# Iterate through each key-value pair in the JSON dictionary
	for key: String in dict.keys():
		var value: Variant = dict[key]
		
		# Special handling for Vector types (stored as strings in JSON)
		if type_string(typeof(value)) == "String" and value.begins_with("Vector"):
			value = str_to_var(value)

		# Find the matching property in the target class
		for property: Dictionary in properties:
			# Skip the 'script' property (built-in)
			if property.name == "script":
				continue

			# Get the current value of the property in the class instance
			var property_value: Variant = _class.get(property.name)

			# If the property name matches the JSON key
			if property.name == key:
				# Case 0: Value is null so the rest doesn't matter
				if value == null:
					_class.set(property.name, null)
					
				# Case 1: Property is an Object (not an array)
				elif not property_value is Array and property.type == TYPE_OBJECT:
					_class.set(property.name, DictionaryToClass(value, GetLootLockerObjectFromFieldReflection(property.name, castClass)))

				# Case 2: Property is an Array
				elif property_value is Array:
					# Recursively convert the JSON array to a Godot array
					var arrayTemp: Array = JsonArrayToClass(value, GetLootLockerObjectFromFieldReflection(property.name, castClass))
					
					# Handle Vector arrays (convert string elements back to Vectors)
					if type_string(property_value.get_typed_builtin()).begins_with("Vector"):
						for obj_array: Variant in arrayTemp:
							_class.get(property.name).append(str_to_var(obj_array))
					else:
						_class.get(property.name).assign(arrayTemp)

				# Case 3: Property is a simple type (not an object or array)
				else:
					# Special handling for Color type (stored as a hex string)
					if property.type == TYPE_COLOR:
						value = Color(value)
					_class.set(property.name, value)

	# Return the fully deserialized class instance
	return _class

## Helper function to recursively convert JSON arrays to Godot arrays.
## Based on https://github.com/EiTaNBaRiBoA/JsonClassConverter, but adapted for LootLocker Internal and specialized deserialization
static func JsonArrayToClass(json_array: Array, cast_class) -> Array:
	var godot_array: Array = []
	for element: Variant in json_array:
		# Case 1: Property is an Object (not an array), so deserialize the element
		if typeof(element) == TYPE_DICTIONARY:
			godot_array.append(DictionaryToClass(element, cast_class))	
		# Case 2: Property is an Array, so recursively unpack elements
		elif typeof(element) == TYPE_ARRAY:
			godot_array.append(JsonArrayToClass(element, cast_class))
		# Case 3: Property is a simple type (not an object or array)
		else:
			# Special handling for Color type (stored as a hex string)
			if "type" in element && element.type == TYPE_COLOR:
				element = Color(element)
			godot_array.append(element)
	return godot_array
#endregion

#region To JSON
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
	if(dictionary == null || dictionary.is_empty()):
		return "{}"
	if minimized:
		return JSON.stringify(dictionary)
	return JSON.stringify(dictionary, '\t')
#endregion
