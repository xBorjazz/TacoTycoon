# GameProgress.gd
extends Resource
class_name GameProgress

const SAVE_PATH := "user://game_progress.tres"

@export var dinero_actual: int = 150
@export var dia_actual: int = 1
@export var ventas_totales: int = 0
@export var perdidas_totales: int = 0
@export var promedio: float = 0.0
@export var buenas_resenas: int = 0
@export var puntaje_acumulado: int = 0
@export var tutorial_completado := false  # 🆕 Nueva variable
@export var nivel_actual: int = 0  # Nuevo: guarda el índice del nivel
@export var tortillas_total: int = 0  # Nuevo: guarda el índice del nivel
@export var carne_total: int = 0  # Nuevo: guarda el índice del nivel
@export var verdura_total: int = 0  # Nuevo: guarda el índice del nivel
@export var salsa_total: int = 0  # Nuevo: guarda el índice del nivel
@export var taco_coins: int = 0  # Nuevo: guarda el índice del nivel
@export var nivel_no_se_ha_cambiado = true


func guardar() -> void:
	ResourceSaver.save(self, SAVE_PATH)
	
static func cargar() -> GameProgress:
	if ResourceLoader.exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH) as GameProgress
	return GameProgress.new()

# Referencia al cliente Nakama
var client: NakamaClient
var session: NakamaSession

func inicializar_nakama(nakama_client: NakamaClient, nakama_session: NakamaSession) -> void:
	client = nakama_client
	session = nakama_session

func guardar_en_nakama() -> int:
	if client == null or session == null:
		print("❌ Error: Cliente o sesión de Nakama no inicializados.")
		return ERR_UNCONFIGURED

	var data = {
		"dinero_actual": dinero_actual,
		"dia_actual": dia_actual,
		"ventas_totales": ventas_totales,
		"perdidas_totales": perdidas_totales,
		"promedio": promedio,
		"buenas_resenas": buenas_resenas,
		"puntaje_acumulado": puntaje_acumulado,
		"taco_coins": taco_coins
	}

	var json_data := JSON.stringify(data)
	print("📤 Guardando en Nakama:", json_data)

	var write_result = await client.write_storage_objects_async(session, [{

		"collection": "game_progress",
		"key": "player_data",
		"value": json_data,
		"permission_read": 2,   # 2 = sólo el usuario puede leer
		"permission_write": 1   # 1 = sólo el usuario puede escribir
	}])

	if write_result.acks.size() > 0:

		print("✅ Progreso guardado correctamente en Nakama.")
		return OK
	else:
		print("❌ Error: No se guardó nada en Nakama.")
		return FAILED

	print("🧾 Usuario autenticado:", session.user_id)
	print("Guardando en Nakama:", json_data)


	
	return OK  # ✅ ¡Ahora devuelve un valor usable!


#func cargar_desde_nakama() -> void:
	#var response = await client.read_storage_objects_async(session, [{
		#"collection": "game_progress",
		#"key": "player_data"
	#}])
#
	#if response.size() > 0:
		##var json_data = response[0].value
		#
		#var json = JSON.new()
		#var parse_result = json.parse(json_data)
		#
		#if parse_result == OK:
			#var data = json.get_data()
			#dinero_actual = data.get("dinero_actual", 150)
			#dia_actual = data.get("dia_actual", 1)
			#ventas_totales = data.get("ventas_totales", 0)
			#perdidas_totales = data.get("perdidas_totales", 0)
			#promedio = data.get("promedio", 0.0)
			#buenas_resenas = data.get("buenas_resenas", 0)
			#puntaje_acumulado = data.get("puntaje_acumulado", 0)
			#taco_coins = data.get("taco_coins", 0)
			#
			#print("Progreso cargado desde Nakama.")
		#else:
			#print("Error al parsear el JSON recibido.")
	#else:
		#print("No se encontró progreso en Nakama.")
