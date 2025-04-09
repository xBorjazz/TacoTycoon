#extends Node
#
## Parámetros configurables
#var min_players := 2
#var max_players := 4
#var client_version := "dev"
#
## Internas reales
#var _nakama_socket: NakamaSocket
#var _my_session_id: String = ""
#var _match_id: String = ""
#var _matchmaker_ticket: String = ""
#var _my_peer_id: int = 0
#var _match_state: int = MatchState.LOBBY
#var _match_mode: int = MatchMode.NONE
#
## Variables expuestas con get
#var nakama_socket: NakamaSocket setget _set_readonly_variable, get_nakama_socket
#var my_session_id: String setget _set_readonly_variable, get_my_session_id
#var match_id: String setget _set_readonly_variable, get_match_id
#var matchmaker_ticket: String setget _set_readonly_variable, get_matchmaker_ticket
#var my_peer_id: int setget _set_readonly_variable, get_my_peer_id
#var match_state: int setget _set_readonly_variable, get_match_state
#var match_mode: int setget _set_readonly_variable, get_match_mode
#
#
## Diccionario de jugadores y contador
#var players: Dictionary = {}
#var _next_peer_id: int = 1
#
#
#func _get_nakama_socket() -> NakamaSocket:
	#return nakama_socket
#
#func _get_my_session_id() -> String:
	#return my_session_id
#
#func _get_match_id() -> String:
	#return match_id
#
#func _get_matchmaker_ticket() -> String:
	#return matchmaker_ticket
#
#func _get_my_peer_id() -> int:
	#return my_peer_id
#
#func _get_match_state() -> int:
	#return match_state
#
#func _get_match_mode() -> int:
	#return match_mode
#
#func _set_readonly_variable(value) -> void:
	## Esto es obligatorio para setget, aunque no hagas nada.
	#pass
#
#
## Diccionario de jugadores y contador
#var players: Dictionary = {}
#var _next_peer_id: int = 1
#
## Estados de partida
#enum MatchState {
	#LOBBY = 0,
	#MATCHING = 1,
	#CONNECTING = 2,
	#WAITING_FOR_ENOUGH_PLAYERS = 3,
	#READY = 4,
	#PLAYING = 5,
#}
#
## Modos de conexión
#enum MatchMode {
	#NONE = 0,
	#CREATE = 1,
	#JOIN = 2,
	#MATCHMAKER = 3,
#}
#
## Estado de jugadores
#enum PlayerStatus {
	#CONNECTING = 0,
	#CONNECTED = 1,
#}
#
## Opcodes de mensajes
#enum MatchOpCode {
	#CUSTOM_RPC = 9001,
	#JOIN_SUCCESS = 9002,
	#JOIN_ERROR = 9003,
#}
#
#
#signal error(message)
#signal disconnected()
#signal match_created(match_id)
#signal match_joined(match_id)
#signal matchmaker_matched(players)
#signal player_joined(player)
#signal player_left(player)
#signal player_status_changed(player, status)
#signal match_ready(players)
#signal match_not_ready()
#
#class Player:
	#var session_id: String
	#var peer_id: int
	#var username: String
#
	#func _init(_session_id: String, _username: String, _peer_id: int) -> void:
		#session_id = _session_id
		#username = _username
		#peer_id = _peer_id
#
	#static func from_presence(presence: NakamaRTAPI.UserPresence, _peer_id: int) -> Player:
		#return Player.new(presence.session_id, presence.username, _peer_id)
#
	#static func from_dict(data: Dictionary) -> Player:
		#return Player.new(data["session_id"], data["username"], int(data["peer_id"]))
#
	#func to_dict() -> Dictionary:
		#return {
			#"session_id": session_id,
			#"username": username,
			#"peer_id": peer_id
		#}
#
#static func serialize_players(_players: Dictionary) -> Dictionary:
	#var result := {}
	#for key in _players:
		#result[key] = _players[key].to_dict()
	#return result
#
#static func unserialize_players(_players: Dictionary) -> Dictionary:
	#var result := {}
	#for key in _players:
		#result[key] = Player.from_dict(_players[key])
	#return result
#
#func _set_readonly_variable(_value) -> void:
	#pass
#
#func _set_nakama_socket(_nakama_socket: NakamaSocket) -> void:
	#if nakama_socket == _nakama_socket:
		#return
#
	#if nakama_socket:
		#nakama_socket.disconnect("closed", self, "_on_nakama_closed")
		#nakama_socket.disconnect("received_error", self, "_on_nakama_error")
		#nakama_socket.disconnect("received_match_state", self, "_on_nakama_match_state")
		#nakama_socket.disconnect("received_match_presence", self, "_on_nakama_match_presence")
		#nakama_socket.disconnect("received_matchmaker_matched", self, "_on_nakama_matchmaker_matched")
#
	#nakama_socket = _nakama_socket
#
	#if nakama_socket:
		#nakama_socket.connect("closed", self, "_on_nakama_closed")
		#nakama_socket.connect("received_error", self, "_on_nakama_error")
		#nakama_socket.connect("received_match_state", self, "_on_nakama_match_state")
		#nakama_socket.connect("received_match_presence", self, "_on_nakama_match_presence")
		#nakama_socket.connect("received_matchmaker_matched", self, "_on_nakama_matchmaker_matched")
#
#func create_match(_nakama_socket: NakamaSocket) -> void:
	#leave()
	#_set_nakama_socket(_nakama_socket)
	#match_mode = MatchMode.CREATE
#
	#var data = await nakama_socket.create_match_async()
	#if data.is_exception():
		#leave()
		#emit_signal("error", "Failed to create match: " + str(data.get_exception().message))
	#else:
		#_on_nakama_match_created(data)
#
#func join_match(_nakama_socket: NakamaSocket, _match_id: String) -> void:
	#leave()
	#_set_nakama_socket(_nakama_socket)
	#match_mode = MatchMode.JOIN
#
	#var data = await nakama_socket.join_match_async(_match_id)
	#if data.is_exception():
		#leave()
		#emit_signal("error", "Unable to join match")
	#else:
		#_on_nakama_match_join(data)
#
#func start_matchmaking(_nakama_socket: NakamaSocket, data: Dictionary = {}) -> void:
	#leave()
	#_set_nakama_socket(_nakama_socket)
	#match_mode = MatchMode.MATCHMAKER
#
	#data["min_count"] = max(min_players, data.get("min_count", min_players))
	#data["max_count"] = min(max_players, data.get("max_count", max_players))
#
	#if client_version != "":
		#data["string_properties"] = data.get("string_properties", {})
		#data["string_properties"]["client_version"] = client_version
		#data["query"] = data.get("query", "") + " +properties.client_version:" + client_version
#
	#match_state = MatchState.MATCHING
	#var result = await nakama_socket.add_matchmaker_async(
		#data.get("query", "*"),
		#data["min_count"],
		#data["max_count"],
		#data.get("string_properties", {}),
		#data.get("numeric_properties", {})
	#)
#
	#if result.is_exception():
		#leave()
		#emit_signal("error", "Unable to join matchmaking pool")
	#else:
		#matchmaker_ticket = result.ticket
