extends Node

var w1: float = 0.0
var w2: float = 0.0
var w3: float = 0.0
var b: float = 0.0
var learning_rate: float = 0.01

# Array para guardar la pérdida de cada iteración
var loss_values: Array = []

func _ready():
	randomize()
	w1 = randf_range(0, 1)
	w2 = randf_range(0, 1)
	w3 = randf_range(0, 1)
	b  = randf_range(0, 1)

func predict(carne: float, salsa: float, tortilla: float) -> float:
	# Modelo lineal simple
	return w1 * carne + w2 * salsa + w3 * tortilla + b

func train(data: Array, real_ganancias: Array, epochs: int = 1000):
	var n = data.size()
	loss_values.clear()

	for epoch in range(epochs):
		var dw1 = 0.0
		var dw2 = 0.0
		var dw3 = 0.0
		var db  = 0.0
		var loss = 0.0

		for i in range(n):
			var x1 = data[i][0]  # carne
			var x2 = data[i][1]  # salsa
			var x3 = data[i][2]  # tortilla
			var y_real = real_ganancias[i]
			var y_pred = predict(x1, x2, x3)

			var error = y_pred - y_real
			loss += error * error

			# Derivadas parciales
			dw1 += (2 * error * x1) / n
			dw2 += (2 * error * x2) / n
			dw3 += (2 * error * x3) / n
			db  += (2 * error)      / n

		# Actualizar pesos
		w1 -= learning_rate * dw1
		w2 -= learning_rate * dw2
		w3 -= learning_rate * dw3
		b  -= learning_rate * db

		# Guardar la pérdida promedio de esta época
		var mse = loss / n
		loss_values.append(mse)

		# (Opcional) Mostrar log cada cierto número de épocas
		# if epoch % 100 == 0:
		#     print("Época: %d, Pérdida: %f" % [epoch, mse])
		
func restart_ready():
	print("Reejecutando _ready() con call_deferred()")
	call_deferred("_ready")  # Esto ejecutará _ready() en el siguiente frame
