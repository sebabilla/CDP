extends VBoxContainer

signal generer_presse

var binomes_positifs: Array[Array]
var binomes_negatifs: Array[Array]

# Ci-dessous, fonctions pour générer une liste de binomes à favoriser et une 
# liste de binômes à éviter
func _on_generer_binomes_pressed() -> void:
	_generer_binomes()
	_afficher_goupes()
	generer_presse.emit()
	
func _generer_binomes() -> void:
	binomes_positifs.clear()
	binomes_negatifs.clear()
	for i in range(Globals.nombre_eleves - 1):
		for j in range(i + 1, Globals.nombre_eleves):
			var aff1: int = Globals.tableau_relations[i * Globals.nombre_eleves + j]
			var aff2: int = Globals.tableau_relations[j * Globals.nombre_eleves + i]
			if aff1 < 0 or aff2 < 0:
				binomes_negatifs.append([i, aff1, j, aff2])
			elif aff1 > 0 or aff2 > 0:
				binomes_positifs.append([i, aff1, j, aff2])
	binomes_negatifs.sort_custom(func(a, b): return a[1] + a[3] < b[1] + b[3])
	binomes_positifs.sort_custom(func(a, b): return a[1] + a[3] > b[1] + b[3])

# fonctions d'affichage des binomes positifs et négatifs à gauche
func _afficher_goupes() -> void:
	%GroupesPositifs.text = ""
	%GroupesNegatifs.text = ""
	var positif: String = ""
	var negatif: String = ""
	for b in binomes_positifs:
		positif +=Globals.noms_eleves[b[0]] + " " + str(b[1]) + " " +Globals.noms_eleves[b[2]] + " " + str(b[3]) + "\n"
	for b in binomes_negatifs:
		negatif +=Globals.noms_eleves[b[0]] + " " + str(b[1]) + " " +Globals.noms_eleves[b[2]] + " " + str(b[3]) + "\n"
	%GroupesPositifs.text = "[color=#b8e994]" + positif + "[/color]"
	%GroupesNegatifs.text = "[color=#e58e26]" + negatif + "[/color]"
	%GroupesNegatifs.cacher()
	%GroupesPositifs.cacher()
