## LootLocker "namespace" for getting state data from the LootLockerSDK
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LL_StateData
extends RefCounted

static func IsLoggedIn() -> bool:
	return HasSessionToken()

static func HasSessionToken() -> bool:
	return LootLockerInternal_LootLockerCache.current().get_data("session_token", "") != ""
	
static func GetCachedPlayerPublicUID() -> String:
	return LootLockerInternal_LootLockerCache.current().get_data("public_uid", "")
	
static func GetCachedPlayerULID() -> String:
	return LootLockerInternal_LootLockerCache.current().get_data("player_ulid", "")
	
static func GetCachedPlayerLegacyID() -> int:
	return LootLockerInternal_LootLockerCache.current().get_data("player_id", 0)
	
static func GetCachedPlayerIdentifier() -> String:
	return LootLockerInternal_LootLockerCache.current().get_data("player_identifier", "")
	
static func GetCachedPlayerName() -> String:
	return LootLockerInternal_LootLockerCache.current().get_data("player_name", "")
