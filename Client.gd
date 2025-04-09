extends Control
class_name NakamaMultiplayer

var session : NakamaSession
var client: NakamaClient
var socket: NakamaSocket


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	session = await client.authenticate_email_async("test@gmail.com", "password")
	socket = Nakama.create_socket_from(client)
	
	await socket.connect_async(session)
	
	socket.connected.connect(onSocketConnected)
	socket.closed.connect(onSocketClosed)
	socket.received_error.connect(onSocketReceivedConnection)
	
	socket.received_match_presence.connect(onMatchPresence)
	socket.received_match_state.connect(onMatchState)
	
func onSocketConnected():
	print("Socket Connected ")
	
func onSocketClosed():
	print("Socket CLOSED ")
	
func onSocketReceivedConnection():
	print("Socket RECEIVED_CONNECTION ")

func onMatchPresence():
	print("Socket PRESENCEMATCH")

func onMatchState():
	print("Socket STATE:MATCH ")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
