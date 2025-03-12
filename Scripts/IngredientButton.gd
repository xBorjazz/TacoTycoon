extends Button

# Tipo de ingrediente (se asigna en cada botón en el inspector)
@export var ingredient_type: String = ""

# Referencia al nodo `GrillManager`
@onready var grill_manager = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel6/Taco-Grill")
# Nodo temporal del ingrediente flotante
var floating_ingredient = null

# ✅ Se activa cuando el jugador PRESIONA el botón (crea el sprite flotante)
func _pressed():
	if floating_ingredient == null:
		floating_ingredient = Sprite2D.new()
		floating_ingredient.texture = self.texture_normal  # Usa la textura del botón
		floating_ingredient.scale = Vector2(0.6, 0.6)  # Ajusta el tamaño
		floating_ingredient.z_index = 10  # Asegura que se dibuje encima de todo

		get_tree().current_scene.add_child(floating_ingredient)

# ✅ Se activa en cada frame y sigue el cursor (para que se mueva con el mouse/touch)
func _process(delta):
	if floating_ingredient != null:
		floating_ingredient.position = get_global_mouse_position()

# ✅ Se activa cuando el jugador SUELTA el botón (intenta colocar el ingrediente)
func _button_released():
	if floating_ingredient != null:
		grill_manager.soltar_ingrediente(ingredient_type, floating_ingredient.position)
		floating_ingredient.queue_free()  # Elimina el sprite flotante
		floating_ingredient = null  # Reinicia la variable
