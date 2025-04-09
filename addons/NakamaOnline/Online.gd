extends Node

# Configuración del cliente
var nakama_server_key: String = "defaultkey"
var nakama_host: String = "localhost"
var nakama_port: int = 7350
var nakama_scheme: String = "http"

# Variables accesibles desde otros scripts
var nakama_client: NakamaClient:
	get: get_nakama_client
	set(value): nakama_client = value

var nakama_session: NakamaSession:
	get: get_nakama_session
	set(value): nakama_session = value

var nakama_socket: NakamaSocket:
	get: get_nakama_socket
	set(value): nakama_socket = value

# Interna para saber si se está conectando el socket
var _nakama_socket_connecting := false

# Señales que puedes conectar a otros nodos
signal session_changed(nakama_session)
signal session_connected(nakama_session)
signal socket_connected(nakama_socket)

# Función para obtener el cliente (si no existe, se crea)
func get_nakama_client() -> NakamaClient:
	if nakama_client == null:
		nakama_client = Nakama.create_client(
			nakama_server_key,
			nakama_host,
			nakama_port,
			nakama_scheme
		)
	return nakama_client

func get_nakama_session() -> NakamaSession:
	return nakama_session

func get_nakama_socket() -> NakamaSocket:
	return nakama_socket

# Para que Nakama siga funcionando aunque el juego esté pausado
func _ready() -> void:
	Nakama.pause_mode = Node.PAUSE_MODE_PROCESS
