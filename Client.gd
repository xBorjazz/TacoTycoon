extends Node

@onready var label_my_score = get_node("/root/Node2D/CanvasLayer/Client/LabelMyScore")
@onready var label_opponent_score = get_node("/root/Node2D/CanvasLayer/Client/LabelOpponentScore")

const SERVER_IP = "192.168.1.4"  # ⚠️ Reemplaza con la IP real del host en la LAN
const PORT = 9999
var udp_client = PacketPeerUDP.new()
var player_id = str(randi() % 10000)  # Generar ID único para cada jugador
var opponent_money = 0  

func _ready():
	udp_client.set_dest_address(SERVER_IP, PORT)  # 🔥 Enviar paquetes al servidor
	print("🔵 Conectado al servidor UDP en", SERVER_IP, ":", PORT)

	# 🔄 Notificar al servidor que este jugador está en línea
	udp_client.put_packet(("JOIN:" + player_id).to_utf8_buffer())

func _process(delta):
	# 🔄 Recibir datos del servidor
	while udp_client.get_available_packet_count() > 0:
		var packet = udp_client.get_packet().get_string_from_utf8()
		var parts = packet.split(":")

		if parts[0] == "SYNC":
			var sender_id = parts[1]
			var money = int(parts[2])

			if sender_id != player_id:
				opponent_money = money  # 🔄 Guardar dinero del oponente correctamente
				label_opponent_score.text = "Dinero Rival: $" + str(opponent_money)
				#print("🏆 Dinero del rival actualizado:", opponent_money)  # 🔥 Debug

	# 🔄 Mostrar dinero del jugador actual
	var my_money = Inventory.player_money
	label_my_score.text = "Mi Dinero: $" + str(my_money)

	# 🔄 Enviar dinero al servidor UDP
	udp_client.put_packet(("MONEY:" + player_id + ":" + str(my_money)).to_utf8_buffer())
