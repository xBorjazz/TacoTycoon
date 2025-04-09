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
