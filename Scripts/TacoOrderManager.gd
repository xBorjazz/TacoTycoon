extends Node

#@onready var grill_manager = get_node("/root/Node2D/GrillManager")

# ✅ Detectar cuando un taco está listo
func verificar_taco():
	var taco_preparado = GrillManager.obtener_taco_preparado()

	for cliente in get_tree().get_nodes_in_group("Clientes"):
		cliente.verificar_taco_entregado(taco_preparado)
