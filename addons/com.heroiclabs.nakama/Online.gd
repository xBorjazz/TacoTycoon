#extends Node
#
## Preload directo al script de Nakama
#const NakamaScene := preload("res://addons/com.heroiclabs.nakama/Nakama.gd")
#
## Creamos una instancia al inicio
#var NakamaInstance: Node
#
## Configuración del Cliente
#var nakama_server_key: String = "defaultkey"
#var nakama_host: String = "localhost"
#var nakama_port: int = 7350
#var nakama_scheme: String = "http"
#
## Variables accesibles desde otros scripts
#var nakama_client: NakamaClient:
	#get:
		#return get_nakama_client()
	#set(value):
		#nakama_client = value
#
#var nakama_session: NakamaSession:
	#get:
		#return get_nakama_session()
	#set(value):
		#nakama_session = value
#
#var nakama_socket: NakamaSocket:
	#get:
		#return get_nakama_socket()
	#set(value):
		#nakama_socket = value
#
## Interna para saber si se está conectando el socket
#var _nakama_socket_connecting := false
#
## Señales que puedes conectar a otros nodos
#signal session_changed(nakama_session)
#signal session_connected(nakama_session)
#signal socket_connected(nakama_socket)
#
#func _ready() -> void:
	## Instancia manual de Nakama.gd
	#NakamaInstance = NakamaScene.new()
	#add_child(NakamaInstance)
	#NakamaInstance._ready() # asegura que el adapter se cree
#
#func get_nakama_client() -> NakamaClient:
	#if nakama_client == null:
		#var http_adapter: NakamaHTTPAdpter = NakamaInstance.get_client_adapter()
		#nakama_client = NakamaClient.new(
			#http_adapter,
			#nakama_server_key,
			#nakama_scheme,
			#nakama_host,
			#nakama_port,
			#10.0 # timeout
		#)
	#return nakama_client
#
#func get_nakama_session() -> NakamaSession:
	#return nakama_session
#
#func get_nakama_socket() -> NakamaSocket:
	#return nakama_socket
