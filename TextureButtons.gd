extends TextureButton

@onready var sound_player = get_node("/root/Node2D/CanvasLayer/PlusButtonPress_Sound")
@onready var buy_button = get_node("/root/Node2D/CanvasLayer/PanelContainer/Panel5/BuyButton")

# Cantidades a comprar por clic
var tortillas_small = 10
var tortillas_medium = 20
var tortillas_large = 30
var carne_small = 12
var carne_medium = 16
var carne_large = 20
var verdura_small = 5
var verdura_medium = 30
var verdura_large = 60
var cebollas_small = 10
var cebollas_medium = 30
var cebollas_large = 50
var salsa_small = 1
var salsa_medium = 1
var salsa_large = 1

const MEDIO_KILO = 0.5
const DineroInicial = 50

# FUNCIONES PARA COMPRAR TortillaES
func _on_ComprarTortillasButton_pressed() -> void:
	verify_sound()
	var cantidad = tortillas_small  # Cantidad comprada por clic
	Inventory.tortillas_total += cantidad
	Inventory.add_suministro("normal", "tortillas", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_tortillas("normal")

func _on_ComprarTortillasMediumButton_pressed() -> void:
	verify_sound()
	var cantidad = tortillas_medium  # Cantidad comprada por clic
	Inventory.tortillas_total += cantidad
	Inventory.add_suministro("medium", "tortillas", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_tortillas("medium")

func _on_ComprarTortillasLargeButton_pressed() -> void:
	verify_sound()
	var cantidad = tortillas_large  # Cantidad comprada por clic
	Inventory.tortillas_total += cantidad
	Inventory.add_suministro("large", "tortillas", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_tortillas("large")

# FUNCIONES PARA COMPRAR Carne
func _on_ComprarCarneButton_pressed() -> void:
	verify_sound()
	var cantidad = carne_small  # Cantidad comprada por clic
	Inventory.carne_total += cantidad	
	Inventory.add_suministro("normal", "carne", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_carne("normal")

func _on_ComprarCarneMediumButton_pressed() -> void:
	verify_sound()
	var cantidad = carne_medium  # Cantidad comprada por clic
	Inventory.carne_total += cantidad	
	Inventory.add_suministro("medium", "carne", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_carne("medium")

func _on_ComprarCarneLargeButton_pressed() -> void:
	verify_sound()
	var cantidad = carne_large  # Cantidad comprada por clic
	Inventory.carne_total += cantidad	
	Inventory.add_suministro("large", "carne", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_carne("large")

# FUNCIONES PARA COMPRAR HIELO
func _on_ComprarCebollasButton_pressed() -> void:
	verify_sound()
	var cantidad = cebollas_small  # Cantidad comprada por clic
	Inventory.cebolla_total += cantidad	
	Inventory.add_suministro("normal", "cebollas", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_cebollas("normal")

func _on_ComprarCebollasMediumButton_pressed() -> void:
	verify_sound()
	var cantidad = cebollas_medium  # Cantidad comprada por clic
	Inventory.cebolla_total += cantidad	
	Inventory.add_suministro("medium", "cebollas", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_cebollas("medium")

func _on_ComprarCebollasLargeButton_pressed() -> void:
	verify_sound()
	var cantidad = cebollas_large  # Cantidad comprada por clic
	Inventory.cebolla_total += cantidad	
	Inventory.add_suministro("large", "cebollas", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_cebollas("large")

# FUNCIONES PARA COMPRAR VASOS
func _on_ComprarSalsaButton_pressed() -> void:
	verify_sound()
	var cantidad =salsa_small  # Cantidad comprada por clic
	Inventory.salsa_total += cantidad	
	Inventory.add_suministro("normal", "salsa", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_salsa("normal")

func _on_ComprarSalsaMediumButton_pressed() -> void:
	verify_sound()
	var cantidad =salsa_medium  # Cantidad comprada por clic
	Inventory.salsa_total += cantidad	
	Inventory.add_suministro("medium", "salsa", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_salsa("medium")

func _on_ComprarSalsaLarge_pressed() -> void:
	verify_sound()
	var cantidad = salsa_large  # Cantidad comprada por clic
	Inventory.salsa_total += cantidad	
	Inventory.add_suministro("large", "salsa", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_salsa("large")
	
# FUNCIONES PARA COMPRAR VERDURA

func _on_ComprarVerduraButton_pressed() -> void:
	verify_sound()
	var cantidad =verdura_small  # Cantidad comprada por clic
	Inventory.verdura_total += cantidad	
	Inventory.add_suministro("normal", "verdura", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_verdura("normal")

func _on_ComprarVerduraMediumButton_pressed() -> void:
	verify_sound()
	var cantidad =verdura_medium  # Cantidad comprada por clic
	Inventory.verdura_total += cantidad	
	Inventory.add_suministro("medium", "verdura", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_verdura("medium")

func _on_ComprarVerduraLarge_pressed() -> void:
	verify_sound()
	var cantidad =verdura_large  # Cantidad comprada por clic
	Inventory.verdura_total += cantidad
	Inventory.add_suministro("large", "verdura", cantidad)  # Usamos 'Inventory' global
	SuppliesUi.actualizar_label_verdura("large")

# FUNCIONES PARA RESTAR Tortillas
func _on_RestarTortillasButton_pressed() -> void:
	if Inventory.tortillas_normal > 0:
		verify_sound()
		var cantidad = tortillas_small  # Cantidad comprada por clic
		Inventory.tortillas_total += cantidad
		Inventory.restar_suministro("normal", "tortillas", 10)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_tortillas("normal")
	else:
		print("No puedes restar Tortillas, el valor es 0.")

func _on_RestarTortillasMediumButton_pressed() -> void:
	if Inventory.tortillas_medium > 0:
		verify_sound()
		var cantidad = tortillas_medium  # Cantidad comprada por clic
		Inventory.tortillas_total += cantidad
		Inventory.restar_suministro("medium", "tortillas", 20)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_tortillas("medium")
	else:
		print("No puedes restar Tortillas medium, el valor es 0.")

func _on_RestarTortillasLargeButton_pressed() -> void:
	if Inventory.tortillas_large > 0:
		verify_sound()
		var cantidad = tortillas_large  # Cantidad comprada por clic
		Inventory.tortillas_total += cantidad
		Inventory.restar_suministro("large", "tortillas", 30)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_tortillas("large")
	else:
		print("No puedes restar Tortillas large, el valor es 0.")

# FUNCIONES PARA RESTAR Carne
func _on_RestarCarneButton_pressed() -> void:
	if Inventory.carne_normal > 0:
		verify_sound()
		var cantidad = carne_small  # Cantidad comprada por clic
		Inventory.carne_total += cantidad
		Inventory.restar_suministro("normal", "carne", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_carne("normal")
	else:
		print("No puedes restar azúcar, el valor es 0.")

func _on_RestarCarneMediumButton_pressed() -> void:
	if Inventory.carne_medium > 0:
		verify_sound()
		var cantidad = carne_medium  # Cantidad comprada por clic
		Inventory.carne_total += cantidad
		Inventory.restar_suministro("medium", "carne", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_carne("medium")
	else:
		print("No puedes restar azúcar medium, el valor es 0.")

func _on_RestarCarneLargeButton_pressed() -> void:
	if Inventory.carne_large > 0:
		verify_sound()
		var cantidad = carne_large  # Cantidad comprada por clic
		Inventory.carne_total += cantidad
		Inventory.restar_suministro("large", "carne", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_carne("large")
	else:
		print("No puedes restar azúcar large, el valor es 0.")

# FUNCIONES PARA RESTAR HIELOS
func _on_RestarCebollasButton_pressed() -> void:
	if Inventory.cebollas_normal > 0:
		verify_sound()
		var cantidad = cebollas_small  # Cantidad comprada por clic
		Inventory.cebolla_total += cantidad
		Inventory.restar_suministro("normal", "cebollas", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_cebollas("normal")
	else:
		print("No puedes restar cebollas, el valor es 0.")

func _on_RestarCebollasMediumButton_pressed() -> void:
	if Inventory.cebollas_medium > 0:
		verify_sound()
		var cantidad = cebollas_medium  # Cantidad comprada por clic
		Inventory.cebolla_total += cantidad
		Inventory.restar_suministro("medium", "cebollas", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_cebollas("medium")
	else:
		print("No puedes restar cebollas medium, el valor es 0.")

func _on_RestarCebollasLargeButton_pressed() -> void:
	if Inventory.cebollas_large > 0:
		verify_sound()
		var cantidad = cebollas_large  # Cantidad comprada por clic
		Inventory.cebolla_total += cantidad
		Inventory.restar_suministro("large", "cebollas", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_cebollas("large")
	else:
		print("No puedes restar cebollas large, el valor es 0.")

# FUNCIONES PARA RESTAR VASOS
func _on_RestarSalsaButton_pressed() -> void:
	if Inventory.salsa_normal > 0:
		verify_sound()
		var cantidad = salsa_small  # Cantidad comprada por clic
		Inventory.salsa_total += cantidad
		Inventory.restar_suministro("normal", "salsa", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_salsa("normal")
	else:
		print("No puedes restar salsa, el valor es 0.")

func _on_RestarSalsaMediumButton_pressed() -> void:
	if Inventory.salsa_medium > 0:
		verify_sound()
		var cantidad = salsa_medium  # Cantidad comprada por clic
		Inventory.salsa_total += cantidad
		Inventory.restar_suministro("medium", "salsa", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_salsa("medium")
	else:
		print("No puedes restar salsa medium, el valor es 0.")

func _on_RestarSalsaLargeButton_pressed() -> void:
	if Inventory.salsa_large > 0:
		verify_sound()
		var cantidad = salsa_large  # Cantidad comprada por clic
		Inventory.salsa_total += cantidad
		Inventory.restar_suministro("large", "salsa", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_salsa("large")
	else:
		print("No puedes restar salsa large, el valor es 0.")

# FUNCIONES PARA RESTAR VERDURA
func _on_RestarVerduraButton_pressed() -> void:
	if Inventory.verdura_normal > 0:
		verify_sound()
		var cantidad = verdura_small # Cantidad comprada por clic
		Inventory.verdura_total += cantidad
		Inventory.restar_suministro("normal", "verdura", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_verdura("normal")
	else:
		print("No puedes restar verdura, el valor es 0.")

func _on_RestarVerduraMediumButton_pressed() -> void:
	if Inventory.verdura_medium > 0:
		verify_sound()
		var cantidad = verdura_medium  # Cantidad comprada por clic
		Inventory.verdura_total += cantidad
		Inventory.restar_suministro("medium", "verdura", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_verdura("medium")
	else:
		print("No puedes restar verdura medium, el valor es 0.")

func _on_RestarVerduraLargeButton_pressed() -> void:
	if Inventory.verdura_large > 0:
		verify_sound()
		var cantidad = verdura_large  # Cantidad comprada por clic
		Inventory.verdura_total += cantidad
		Inventory.restar_suministro("large", "verdura", cantidad)  # Usamos 'Inventory' global
		SuppliesUi.actualizar_label_verdura("large")
	else:
		print("No puedes restar verdura large, el valor es 0.")

func _on_buy_button_pressed() -> void:
	if Inventory.player_money >= Inventory.buy_cost:
		Inventory.player_money -= Inventory.buy_cost
		Inventory.buy_cost = 0  # Reinicia el valor de buy_cost a 0 después de la compra
		SuppliesUi.actualizar_labels_dinero()
		SuppliesUi.resetear_labels_recursos()
		SuppliesUi.actualizar_inventario_total() 
	else:
		print("No tienes suficiente dinero.")

func _on_sell_button_pressed() -> void:
	Inventory.buy_cost=0
	SuppliesUi.actualizar_labels_dinero()
	SuppliesUi.resetear_labels_recursos()
	
func verify_sound() -> void:
	if sound_player:
		sound_player.play()
