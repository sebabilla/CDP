## Fichier global pour gérer le contenu de la ressource section : classe, question
## les élèves et leurs affinites et leurs positions sur le plan.
## Une ressource section ouverte ne devrait pas être modifiée sans passer par
## une fonction de ce fichier.
## Toutes les fonctions devraient retourner une valeur interpretable.
extends Node

const TAILLE_TABLE: Vector2 = Vector2(128, 80)

var section: Section = Section.new()

func nouvelle_section(sec: Section):
	section = sec

# fonctions pour gerer la classe et la question
func set_nom_section(nom: String) -> bool:
	if nom.is_empty() or nom == section.classe:
		return false
	section.classe = nom
	_set_titre_fenetre()
	return true
	
func _set_titre_fenetre() -> void:
	var titre: String = tr("TITRE") + "    " + section.classe
	DisplayServer.window_set_title(titre)
	
func get_nom_section() -> String:
	return section.classe
		
func set_question(question: String) -> bool:
	if question.is_empty() or question == section.question:
		return false
	section.question = question
	return true
	
func get_question() -> String:
	return section.question
	
# functions pour gerer les eleves	
func get_nb_eleves() -> int:
	return section.eleves.size()
	
func ajouter_eleve(nom: String) -> bool:
	for eleve in section.eleves:
		if eleve.nom == nom: return false
	var nouveau: Eleve = Eleve.new()
	nouveau.nom = nom
	section.eleves.append(nouveau)
	return true
	
func enlever_dernier_eleve() -> bool:
	if section.eleves.is_empty():
		return false
	var nom_dernier: String = section.eleves.back().nom
	for i in get_nb_eleves():
		if positif_existe(i, nom_dernier):
			enlever_positif(i, nom_dernier)
		if negatif_existe(i, nom_dernier):
			enlever_negatif(i, nom_dernier)
	section.eleves.pop_back()
	return true
	
func enlever_tous_eleves() -> bool:
	if section.eleves.is_empty():
		return false
	section.eleves.clear()
	return true
	
func get_nom_eleve(indice: int) -> String:
	if indice < 0 or indice >= get_nb_eleves():
		return ""
	return section.eleves[indice].nom

func trouver_indice_eleve(nom: String) -> int:
	for i in get_nb_eleves():
		if section.eleves[i].nom == nom:
			return i
	return -1

# obtenir la liste des eleves de trois facons
func liste_eleves() -> Array[String]:
	var liste: Array[String] = []
	for i in get_nb_eleves():
		liste.append(section.eleves[i].nom)
	return liste
	
func tri_alphabet(az: bool = true) -> bool:
	if section.eleves.is_empty(): return false
	if az: 
		section.eleves.sort_custom(func(a,b): return a.nom < b.nom)
	else:
		section.eleves.sort_custom(func(a,b): return a.nom > b.nom)
	return true
	
# Fonctions pour gérér les affinites des eleves
func positif_existe(indice: int, nom: String) -> int:
	if nom in section.eleves[indice].positifs:
		return true
	return false		
	
func ajouter_positif(indice: int, nom: String) -> bool:
	if nom == "": return false
	section.eleves[indice].positifs.append(nom)
	return true
	
func enlever_positif(indice: int, nom: String) -> bool:
	var id: int = section.eleves[indice].positifs.find(nom)
	if id < 0 or id >= get_nb_eleves(): 
		return false
	section.eleves[indice].positifs.pop_at(id)
	return true
	
func negatif_existe(indice: int, nom: String) -> int:
	if nom in section.eleves[indice].negatifs:
		return true
	return false

func ajouter_negatif(indice: int, nom: String) -> bool:
	if nom == "": return false
	section.eleves[indice].negatifs.append(nom)
	return true
	
func enlever_negatif(indice: int, nom: String) -> bool:
	var id: int = section.eleves[indice].negatifs.find(nom)
	if id < 0 or id >= get_nb_eleves(): 
		return false
	section.eleves[indice].negatifs.pop_at(id)
	return true
	
func effacer_toutes_affinites() -> bool:
	if section.eleves.is_empty(): return false
	for eleve in section.eleves:
		eleve.positifs.clear()
		eleve.negatifs.clear()
	return true
	
func liste_positifs(indice: int) -> Array[String]:
	if indice < 0 or indice >= get_nb_eleves(): return []
	return section.eleves[indice].positifs.duplicate()
	
func liste_negatifs(indice: int) -> Array[String]:
	if indice < 0 or indice >= get_nb_eleves(): return []
	return section.eleves[indice].negatifs.duplicate()

func popularite_eleve(nom: String) -> int:
	var popu: int = 0
	for eleve in section.eleves:
		popu += int(nom in eleve.positifs)
		popu -= int(nom in eleve.negatifs)
	return popu

# fonctions pour definir ou lire les positions des eleves dans le viewport	
# set_pos_eleve et get_pos_eleve sont appelée plein de fois à chaque frame alors pas de test??
func set_pos_eleve(indice: int, pos: Vector2) -> void:
	section.eleves[indice].pos = pos

func get_pos_eleve(indice: int) -> Vector2:
	return section.eleves[indice].pos

func set_angle_eleve(indice: int, angle_degres: float) -> void:
	section.eleves[indice].angle = angle_degres
	
func get_angle_eleve(indice: int) -> float:
	return section.eleves[indice].angle

func set_pos_eleves_sym_c(centre: Vector2) -> void:
	for eleve in section.eleves:
		eleve.pos = 2 * centre - eleve.pos
	
func set_nouvelles_pos() -> bool:
	var lignes: int = floor(sqrt(get_nb_eleves()))
	if lignes == 0: return false
	for i in range(get_nb_eleves()):
		var nv_pos: Vector2 = Vector2(i / lignes * TAILLE_TABLE.x, i % lignes * TAILLE_TABLE.y) + 2*TAILLE_TABLE
		set_pos_eleve(i, nv_pos)
	return true

# https://fr.wikipedia.org/wiki/Tournoi_toutes_rondes
func pos_paires_tournantes() -> Array[Array]:
	if get_nb_eleves() <= 2:
		return []
	var positions: Array = []
	for eleve in section.eleves:
		positions.append(eleve.pos)
	var tirages: Array[Array] = []
	for  i in (get_nb_eleves() - 1):
		tirages.append(positions)
		positions = [positions[0]] + [positions[-1]] + positions.slice(1, -1)
	return tirages
	
func set_pos_tous_eleves(positions: Array) -> bool:
	if positions.size() != get_nb_eleves():
		return false
	for i in get_nb_eleves():
		set_pos_eleve(i, positions[i])
	return true
	
# gerer les tables vierges
func get_nb_tables_vierges() -> int:
	return  section.tables_vierges_pos.size()

func ajouter_table_vierge() -> void:
	var decalage: int = get_nb_tables_vierges()
	section.tables_vierges_pos.append( 2 * TAILLE_TABLE + Vector2(1,3) * decalage)
	section.tables_vierges_angle.append(0)

func enlever_derniere_table_vierge() -> void:
	if section.tables_vierges_pos.is_empty() : return
	section.tables_vierges_pos.pop_back()
	section.tables_vierges_angle.pop_back()
	
func set_pos_table_vierge(indice: int, pos: Vector2) -> void:
	section.tables_vierges_pos[indice] = pos
	
func get_pos_table_vierge(indice: int) -> Vector2:
	return section.tables_vierges_pos[indice]
	
func set_angle_table_vierge(indice: int, angle_degres: float) -> void:
	section.tables_vierges_angle[indice] = angle_degres
	
func get_angle_table_vierge(indice: int) -> float:
	return section.tables_vierges_angle[indice]
	
func set_pos_tables_sym_c(centre: Vector2) -> void:
	for i in get_nb_tables_vierges():
		section.tables_vierges_pos[i] = 2 * centre - section.tables_vierges_pos[i]

func get_pos_min_max() -> Rect2:
	if section.eleves.is_empty() and section.tables_vierges.is_empty():
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	var x: Array[float]
	var y: Array[float]
	for eleve in section.eleves:
		x.append(eleve.pos.x)
		y.append(eleve.pos.y)
	for table in section.tables_vierges_pos:
		x.append(table.x)
		y.append(table.y)
	return Rect2(x.min(), y.min(), x.max() - x.min(), y.max() - y.min())	
