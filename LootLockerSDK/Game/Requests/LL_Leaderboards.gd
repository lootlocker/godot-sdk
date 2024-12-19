## LootLocker "namespace" for all requests relating to Leaderboards
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LL_Leaderboards
extends RefCounted


#region Data Definitions

## Response object with information about a player from a leaderboard
class _LL_LeaderboardMemberPlayerInformation:
	## The id of the player
	var id : int = 0
	## The public uid of the player
	var public_uid : String = ""
	## The name of the player (if any has been set)
	var name : String = ""
	## The ulid of the player
	var ulid : String = ""

## Data object for leaderboard members
class _LL_GetByListofMembersResponseMembersDataDefinition:
	## The id of the member
	var member_id : String = ""
	## The rank that this member holds on the specified leaderboard
	var rank : int = 0
	## The score for this rank and member
	var score : int = 0
	## Information about the player relating to this leaderboard entry (if leaderboard is of type player)
	var player : _LL_LeaderboardMemberPlayerInformation
	## Metadata of this leaderboard entry (if any)
	var metadata : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"player" : _LL_LeaderboardMemberPlayerInformation,
		}

## Pagination data
class _LL_LeaderboardPaginationDataDefinition:
	## A cursor pointing to the previous page according to the current page size (count) and cursor (after)
	var previous_cursor : int = 0
	## The total number of elements available to paginate through
	var total : int = 0
	## A cursor pointing to the next page according to the current page size (count) and cursor (after)
	var next_cursor : int = 0

## Leaderboard entry data object
class _LL_GetScoreListResponseItemsDataDefinition:
	## The id of the member
	var member_id : String = ""
	## The rank that this member holds on the specified leaderboard
	var rank : int = 0
	## The score for this rank and member
	var score : int = 0
	## Information about the player relating to this leaderboard entry (if leaderboard is of type player)
	var player : _LL_LeaderboardMemberPlayerInformation
	## Metadata of this leaderboard entry (if any)
	var metadata : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"player" : _LL_LeaderboardMemberPlayerInformation,
		}

## Data object containing schedule information for a leaderboard
class _LL_LeaderboardScheduleDataDefinition:
	## Cron expression used to define the scheduling
	var cron_expression : String = ""
	## The date when the next Leaderboard reset wil happen
	var next_run : String = ""
	## The date when the last Leaderboard reset happened
	var last_run : String = ""
	## A list of all the schedules that has previously ran
	var schedule : Array[String] = []
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
		}

## Data object with predicate argument information
class _LL_LeaderboardRewardPredicatesArgsDataDefinition:
	## Max predicate to reward
	var max : int = 0
	## Min predicate to reward
	var min : int = 0
	## The reward method (by_rank / by_percent)
	var method : String = ""
	## The direction of the predicate (asc / desc)
	var direction : String = ""

## Data object with predicate information for a reward
class _LL_LeaderboardRewardPredicateDataDefinition:
	## The ID of the reward predicate
	var id : String = ""
	## The type of reward predicate
	var type : String = ""
	## The details on predicate
	var args : _LL_LeaderboardRewardPredicatesArgsDataDefinition
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"args" : _LL_LeaderboardRewardPredicatesArgsDataDefinition,
		}

## Data object with details about a currency reward
class _LL_RewardsCurrencyDetailsDataDefinition:
	## The name of the Currency
	var name : String = ""
	## The code of the Currency
	var code : String = ""
	## The amount of the Currency
	var amount : int = 0
	## The ID of the Currency
	var id : String = ""

## Data object with information about a currency reward
class _LL_LeaderboardRewardCurrencyDataDefinition:
	## The date the Currency reward was created
	var created_at : String = ""
	## The date the Currency reward was last updated
	var updated_at : String = ""
	## The amount of Currency to be rewarded
	var amount : int = 0
	## The details on the Currency
	var details : _LL_RewardsCurrencyDetailsDataDefinition
	## The ID of a reward
	var reward_id : String = ""
	## The ID of the Currency
	var currency_id : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"details" : _LL_RewardsCurrencyDetailsDataDefinition,
		}

## Data object with details about a progression reset reward
class _LL_LeaderboardRewardProgressionResetDetailsDataDefinition:
	## The key of the Progression
	var key : String = ""
	## The name of the Progression
	var name : String = ""
	## The ID of the Progression
	var id : String = ""

## Data object with information about a progression reset reward
class _LL_LeaderboardRewardProgressionResetDataDefinition:
	## The date the Progression Reset reward was created
	var created_at : String = ""
	## The date the Progression Reset reward was last updated
	var updated_at : String = ""
	## The details of the Progression reward
	var details : _LL_LeaderboardRewardProgressionResetDetailsDataDefinition
	## The ID of the Progression
	var progression_id : String = ""
	## The ID of the reward
	var reward_id : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"details" : _LL_LeaderboardRewardProgressionResetDetailsDataDefinition,
		}

## Data object with details about a progression point reward
class _LL_LeaderboardRewardProgressionPointsDetailsDataDefinition:
	## The key of the Progression
	var key : String = ""
	## The name of the Progression
	var name : String = ""
	## The amount of Progression Points to be rewarded
	var amount : int = 0
	## The ID of the Progression
	var id : String = ""

## Data object with information about a progression points reward
class _LL_LeaderboardRewardProgressionPointsDataDefinition:
	## The date the Progression Points reward was created
	var created_at : String = ""
	## The date the Progression Points was last updated
	var updated_at : String = ""
	## The details of the Progression
	var details : _LL_LeaderboardRewardProgressionPointsDetailsDataDefinition
	## The amount of Progression Points to be rewarded
	var amount : int = 0
	## The ID of the Progression
	var progression_id : String = ""
	## The ID of the reward
	var reward_id : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"details" : _LL_LeaderboardRewardProgressionPointsDetailsDataDefinition,
		}

## Data object with details about an asset reward
class _LL_LeaderboardRewardAssetDetailsDataDefinition:
	## The name of the Asset
	var name : String = ""
	## The url to the thumbnail, will be null if its not set in the LootLocker console
	var thumbnail : String = ""
	## The name of the Variation Asset, will be null if its not a Variation Asset
	var variation_name : String = ""
	## The name of the Rental Asset, will be null if its not a Variation Asset
	var rental_option_name : String = ""
	## The ID of the Variation, will be null if its not a Variation Asset
	var variation_id : int = 0
	## The ID of the rental option, will be null if its not a Rental Asset
	var rental_option_id : int = 0
	## The ID of the Asset
	var legacy_id : int = 0
	## The ULID of the Asset
	var id : String = ""

## Data object with information about an asset reward
class _LL_LeaderboardRewardAssetDataDefinition:
	## The date the Asset reward was created
	var created_at : String = ""
	## The date the Asset reward was last updated
	var updated_at : String = ""
	## The details on the Asset
	var details : _LL_LeaderboardRewardAssetDetailsDataDefinition
	## The Asset variation ID, will be null if its not a variation
	var asset_variation_id : int = 0
	## The Asset rental option ID, will be null if its not a rental
	var asset_rental_option_id : int = 0
	## The ID of the Asset
	var asset_id : int = 0
	## The ID of the reward
	var reward_id : String = ""
	## The ULID of the Asset
	var asset_ulid : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"details" : _LL_LeaderboardRewardAssetDetailsDataDefinition,
		}

## Details about a reward group association
class _LL_LeaderboardRewardGroupAssociationsDataDefinition:
	## The kind of reward, (asset / currency / progression points / progression reset)
	var reward_kind : String = ""
	## The currency reward, will be null if the reward is of another type
	var currency : _LL_LeaderboardRewardCurrencyDataDefinition
	## The Progression Reset reward, will be null if the reward is of another type
	var progression_reset : _LL_LeaderboardRewardProgressionResetDataDefinition
	## The Progression Points reward, will be null if the reward is of another type
	var progression_points : _LL_LeaderboardRewardProgressionPointsDataDefinition
	## The Asset reward, will be null if the reward is of another type
	var asset : _LL_LeaderboardRewardAssetDataDefinition
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"currency" : _LL_LeaderboardRewardCurrencyDataDefinition,
			"progression_reset" : _LL_LeaderboardRewardProgressionResetDataDefinition,
			"progression_points" : _LL_LeaderboardRewardProgressionPointsDataDefinition,
			"asset" : _LL_LeaderboardRewardAssetDataDefinition,
		}

## Data object with information about a reward group
class _LL_LeaderboardRewardGroupDataDefinition:
	## The date the Group reward was created
	var created_at : String = ""
	## The name of the Group
	var name : String = ""
	## The description of the Group
	var description : String = ""
	## Associations for the Group reward
	var associations : Array[_LL_LeaderboardRewardGroupAssociationsDataDefinition] = []
	## The ID of the reward
	var reward_id : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"associations" : _LL_LeaderboardRewardGroupAssociationsDataDefinition,
		}

## Data object with information about a leaderboard reward
class _LL_LeaderboardRewardDataDefinition:
	## The kind of reward, (asset / currency / group / progression points / progression reset)
	var reward_kind : String = ""
	## The Predicates of the reward
	var predicates : Array[_LL_LeaderboardRewardPredicateDataDefinition] = []
	## The currency reward, will be null if the reward is of another type
	var currency : _LL_LeaderboardRewardCurrencyDataDefinition
	## The Progression Reset reward, will be null if the reward is of another type
	var progression_reset : _LL_LeaderboardRewardProgressionResetDataDefinition
	## The Progression Points reward, will be null if the reward is of another type
	var progression_points : _LL_LeaderboardRewardProgressionPointsDataDefinition
	## The Asset reward, will be null if the reward is of another type
	var asset : _LL_LeaderboardRewardAssetDataDefinition
	## The Group reward, will be null if the reward is of another type
	var group : _LL_LeaderboardRewardGroupDataDefinition
	## The id of this reward
	var reward_id : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"predicates" : _LL_LeaderboardRewardPredicateDataDefinition,
			"currency" : _LL_LeaderboardRewardCurrencyDataDefinition,
			"progression_reset" : _LL_LeaderboardRewardProgressionResetDataDefinition,
			"progression_points" : _LL_LeaderboardRewardProgressionPointsDataDefinition,
			"asset" : _LL_LeaderboardRewardAssetDataDefinition,
			"group" : _LL_LeaderboardRewardGroupDataDefinition,
		}

## Data object with information about a leaderboard
class _LL_ListLeaderboardsResponseItemsDataDefinition:
	## When this leaderboard was created
	var created_at : String = ""
	## When this leaderboard was last updated
	var updated_at : String = ""
	## The key of this leaderboard (if any has been set)
	var key : String = ""
	## The direction of the Leaderboard (Ascending / Descending)
	var direction_method : String = ""
	## The name of the Leaderboard
	var name : String = ""
	## The type of the Leaderboard (Player / Generic)
	var type : String = ""
	## The integer id of this leaderboard
	var id : int = 0
	## The ulid for this leaderboard
	var ulid : String = ""
	## The id of the game that this leaderboard is on
	var game_id : int = 0
	## Whether this leaderboard allows writes from the game api
	var enable_game_api_writes : bool = false
	## Will the score be overwritten even if it was less than the original score
	var overwrite_score_on_submit : bool = false
	## Does the Leaderboard have metadata
	var has_metadata : bool = false
	## Schedule of the Leaderboard
	var schedule : _LL_LeaderboardScheduleDataDefinition
	## A List of rewards tied to the Leaderboard
	var rewards : Array[_LL_LeaderboardRewardDataDefinition] = []
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"schedule" : _LL_LeaderboardScheduleDataDefinition,
			"rewards" : _LL_LeaderboardRewardDataDefinition,
		}

#endregion

#region Responses

## Response object for getting member rank
class _LL_GetMemberRankResponse extends LootLockerInternal_BaseResponse:
	## The id of the member
	var member_id : String = ""
	## The rank that this member holds on the specified leaderboard
	var rank : int = 0
	## The score for this rank and member
	var score : int = 0
	## Information about the player relating to this leaderboard entry (if leaderboard is of type player)
	var player : _LL_LeaderboardMemberPlayerInformation
	## Metadata of this leaderboard entry (if any)
	var metadata : String = ""
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"player" : _LL_LeaderboardMemberPlayerInformation,
		}

## Response object for getting member ranks
class _LL_GetByListofMembersResponse extends LootLockerInternal_BaseResponse:
	## List of leaderboard member information (rank, score, etc.)
	var members : Array[_LL_GetByListofMembersResponseMembersDataDefinition] = []
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"members" : _LL_GetByListofMembersResponseMembersDataDefinition,
		}

## Response object for getting a list of scores
class _LL_GetScoreListResponse extends LootLockerInternal_BaseResponse:
	## Pagination data for this request
	var pagination : _LL_LeaderboardPaginationDataDefinition
	## List of leaderboard member information (rank, score, etc.)
	var items : Array[_LL_GetScoreListResponseItemsDataDefinition] = []
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"pagination" : _LL_LeaderboardPaginationDataDefinition,
			"items" : _LL_GetScoreListResponseItemsDataDefinition,
		}

## Response object for submitting scores
class _LL_SubmitScoreResponse extends LootLockerInternal_BaseResponse:
	## Metadata (if any was set and it is enabled for this leaderboard) for the leaderboard entry
	var metadata : String = ""
	## The member id that was set for this leaderboard entry
	var member_id : String = ""
	## The rank that the submitted score reached
	var rank : int = 0
	## The score as submitted
	var score : int = 0

## Response object for getting leaderboard details
class _LL_GetLeaderboardDetailsResponse extends LootLockerInternal_BaseResponse:
	## When this leaderboard was created
	var created_at : String = ""
	## When this leaderboard was last updated
	var updated_at : String = ""
	## The key of this leaderboard (if any has been set)
	var key : String = ""
	## The direction of the Leaderboard (Ascending / Descending)
	var direction_method : String = ""
	## The name of the Leaderboard
	var name : String = ""
	## The type of the Leaderboard (Player / Generic)
	var type : String = ""
	## The integer id of this leaderboard
	var id : int = 0
	## The ulid for this leaderboard
	var ulid : String = ""
	## The id of the game that this leaderboard is on
	var game_id : int = 0
	## Whether this leaderboard allows writes from the game api
	var enable_game_api_writes : bool = false
	## Will the score be overwritten even if it was less than the original score
	var overwrite_score_on_submit : bool = false
	## Does the Leaderboard have metadata
	var has_metadata : bool = false
	## Schedule of the Leaderboard
	var schedule : _LL_LeaderboardScheduleDataDefinition
	## A List of rewards tied to the Leaderboard
	var rewards : Array[_LL_LeaderboardRewardDataDefinition] = []
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"schedule" : _LL_LeaderboardScheduleDataDefinition,
			"rewards" : _LL_LeaderboardRewardDataDefinition,
		}

## Response object for listing leaderboards
class _LL_ListLeaderboardsResponse extends LootLockerInternal_BaseResponse:
	## Pagination data for this request
	var pagination : _LL_LeaderboardPaginationDataDefinition
	## A list of leaderboard information objects
	var items : Array[_LL_ListLeaderboardsResponseItemsDataDefinition] = []
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"pagination" : _LL_LeaderboardPaginationDataDefinition,
			"items" : _LL_ListLeaderboardsResponseItemsDataDefinition,
		}

#endregion

#region Requests Bodies

## Internal request body object
class _LL_GetByListofMembersRequestBody extends LootLockerInternal_BaseRequest:
	## List of member ids
	var members : Array[String] = []

## Internal request body object
class _LL_SubmitScoreRequestBody extends LootLockerInternal_BaseRequest:
	## The id of the member to submit scores for. If the leaderboard is a player type leaderboard this should be the player id, if the leaderboard is a generic type leaderboard then this can be any string.
	var member_id : String = ""
	## The score to submit
	var score : int = 0
	## Metadata (if metadata is enabled for the leaderboard) to set for the submitted score
	var metadata : String = ""

#endregion

#region Requests

##Construct an HTTP Request in order to Get Member Rank[br]
##
##Used to get the rank (if any) of a specified leaderboard entry as identified by its member id from the specified leaderboard[br]
##For a player type leaderboard the member id is the player's id[br]
##For a generic type leaderboard the member id can be any string[br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.GetMemberRank.new(<leaderboard_key>, <member_id>).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class GetMemberRank extends LootLockerInternal_RequestDefinition:
	## [param leaderboard_key] - The key OR integer id of the leaderboard[br]
	## [param member_id] - The leaderboard identifier of an entry (a member of the leaderboard). For a player type leaderboard the member id is the player's id and for a generic type leaderboard the member id can be any string[br]
	func _init(leaderboard_key : String, member_id : String) -> void:
		responseType = _LL_GetMemberRankResponse

		var url = "/game/leaderboards/{leaderboard_key}/member/{member_id}"
		url = url.replace("{leaderboard_key}", leaderboard_key)
		url = url.replace("{member_id}", member_id)
		super._init(url, HTTPClient.Method.METHOD_GET, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_GetMemberRankResponse:
		await _send()
		return response

##Construct an HTTP Request in order to get leaderboard entries by a list of members[br]
##
##Used to get a list of ranks (if any) as identified by their member ids from the specified leaderboard[br]
##For a player type leaderboard the member id is the player's id[br]
##For a generic type leaderboard the member id can be any string[br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.GetByListofMembers(<leaderboard_key>, [list of member ids]).new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class GetByListofMembers extends LootLockerInternal_RequestDefinition:
	## [param leaderboard_key] - The key OR integer id of the leaderboard[br]
	## [param members] - List of leaderboard identifiers of entries (members of the leaderboard). For a player type leaderboard the member id is the player's id and for a generic type leaderboard the member id can be any string[br]
	func _init(leaderboard_key : String, members : Array[String]) -> void:
		responseType = _LL_GetByListofMembersResponse
		request = _LL_GetByListofMembersRequestBody.new()
		request.members = members

		var url = "/game/leaderboards/{leaderboard_key}/members"
		url = url.replace("{leaderboard_key}", leaderboard_key)
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_GetByListofMembersResponse:
		await _send()
		return response

##Construct an HTTP Request in order to Get Score List[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.GetScoreList(<leaderboard_key>).new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
##Optionally, if you are paginating through the leaderboard (fetching a set number of entries each time) you can use the [param count] and [param after] parameters like this:[br]
##[code]LL_Leaderboards.GetScoreList.new(<leaderboard_key>, <the number of items you wish to fetch, f.ex. 10>, <From which element to retreive the 10 elements>).send()[/code][br]
## So for example, to get elements 200-225 from a leaderboard with the key "level_2_high_score" you would do:[br]
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.GetScoreList.new("level_2_high_score", 25, 200).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class GetScoreList extends LootLockerInternal_RequestDefinition:
	## [param leaderboard_key] - The key OR integer id of the leaderboard[br]
	## (Optional) [param count] - The number of entries to retreive from the specified leaderboard[br]
	## (Optional) [param after] - Used when paginating requests. Which element from the leaderboard to retreive elements after. Most commonly you will set this to the value of `next_cursor` from a previous request (if any)[br]
	func _init(leaderboard_key : String, count : int = 10, after : int = -1) -> void:
		responseType = _LL_GetScoreListResponse

		var url = "/game/leaderboards/{leaderboard_key}/list"
		url = url.replace("{leaderboard_key}", leaderboard_key)
		url+="?count=" + str(count)
		if(after > -1):
			url+="&after=" + str(after)
		super._init(url, HTTPClient.Method.METHOD_GET, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_GetScoreListResponse:
		await _send()
		return response

##Construct an HTTP Request in order to Submit Score[br]
##
##Submit the specified score to the specified leaderboard on behalf of the specified member[br]
##[b]Note:[/b] Game API writes must be enabled for the leaderboard for this request to succeed. LootLocker recommends that that not be allowed, and instead a server component should be verifying scores before submit and *it* should submit the scores to LootLocker.[br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.SubmitScore(<leaderboard_key>, <score>, <member_id>).new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class SubmitScore extends LootLockerInternal_RequestDefinition:
	## [param leaderboard_key] - The key OR integer id of the leaderboard[br]
	## [param score] - The score to submit. Note that this is an integer[br]
	## [param member_id] - The leaderboard identifier to associate this score with. For a player type leaderboard the member id is the player's id and for a generic type leaderboard the member id can be any string[br]
	## (Optional) [param metadata] - If metadata is enabled for the leaderboard, you can optionally submit some metadata for the entry[br]
	func _init(leaderboard_key : String, score : int, member_id : String, metadata : String = "") -> void:
		responseType = _LL_SubmitScoreResponse
		request = _LL_SubmitScoreRequestBody.new()
		request.member_id = member_id
		request.score = score
		request.metadata = metadata

		var url = "/game/leaderboards/{leaderboard_key}/submit"
		url = url.replace("{leaderboard_key}", leaderboard_key)
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_SubmitScoreResponse:
		await _send()
		return response

##Construct an HTTP Request in order to Get Leaderboard Details[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.GetLeaderboardDetails(<leaderboard_key>).new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class GetLeaderboardDetails extends LootLockerInternal_RequestDefinition:
	## [param leaderboard_key] - The key OR integer id of the leaderboard[br]
	func _init(leaderboard_key : String) -> void:
		responseType = _LL_GetLeaderboardDetailsResponse

		var url = "/game/leaderboards/{leaderboard_key}/info"
		url = url.replace("{leaderboard_key}", leaderboard_key)
		super._init(url, HTTPClient.Method.METHOD_GET, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_GetLeaderboardDetailsResponse:
		await _send()
		return response

##Construct an HTTP Request in order to List Leaderboards with detailed information[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.ListLeaderboards(<count>).new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
##Optionally, if you are paginating through the leaderboards (fetching a set number of leaderboards each time) you can use the [param count] and [param after] parameters like this:[br]
##[code]LL_Leaderboards.ListLeaderboards.new(<the number of items you wish to fetch, f.ex. 10>, <From which element to retreive the 10 elements>).send()[/code][br]
##So for example, to get leaderboards nr 12-15 from your game you would do:[br]
##[codeblock lang=gdscript]
##var response = await LL_Leaderboards.ListLeaderboards.new(3, 12).new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class ListLeaderboards extends LootLockerInternal_RequestDefinition:
	## [param count] - The number of entries to retreive from the specified leaderboard[br]
	## (Optional) [param after] - Used when paginating requests. Which element from the leaderboard to retreive elements after. Most commonly you will set this to the value of `next_cursor` from a previous request (if any)[br]
	func _init(count : int, after : int = -1) -> void:
		responseType = _LL_ListLeaderboardsResponse

		var url = "/game/leaderboards"
		url+="?count=" + str(count)
		if(after > -1):
			url+="&after=" + str(after)
		super._init(url, HTTPClient.Method.METHOD_GET, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_ListLeaderboardsResponse:
		await _send()
		return response

#endregion
