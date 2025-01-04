extends Node

signal maj_classe_question
signal nouveau_tableau_relations
signal maj_case_tableau_relations(indice: int)
signal nouveau_plan
signal nouvelle_sauvegarde
signal son_a_emettre(son: String)

const CHEMIN_SAUVEGARDE = "user://"

const AFFINITE_MAX := 3
const AFFINITE_MIN : = 2

var eleves = Eleves.new()
var nombre_eleves: int = eleves.noms.size()
var scores_individuels: Array[int]

func changer_nom_classe(nom: String) -> void:
	print(nom)
	if nom.length() > 0 and nom != eleves.classe:
		eleves.classe = nom
		son_a_emettre.emit("valider")
		maj_classe_question.emit()
		
func changer_question(question: String):
	print(question)
	if question.length() > 0 and question != eleves.question:
		eleves.question = question
		son_a_emettre.emit("valider")
		maj_classe_question.emit()	

# Ci-dessous fonctions pour ajouter et enlever des élèves
func ajouter_nom_eleve(nom: String) -> void:
	if nom in eleves.noms:
		return
	eleves.noms.append(nom)
	nombre_eleves = eleves.noms.size()
	agrandir_tableau()
	
func enlever_dernier_eleve() -> void:
	eleves.noms.pop_back()
	nombre_eleves = eleves.noms.size()
	if nombre_eleves >= 0 :
		reduire_tableau()
	
func enlever_tous_eleves() -> void:
	eleves.noms.clear()
	nombre_eleves = 0
	eleves.relations.clear()
	scores_individuels.clear()
	nouveau_tableau_relations.emit()
	son_a_emettre.emit("annuler")
	

# Ci-dessous fonctions pour créer et modifier tableau_relations et scores_individuels
func agrandir_tableau() -> void:
	for i in nombre_eleves - 1:
		eleves.relations.insert(i * nombre_eleves + nombre_eleves - 1, 0)
		eleves.relations.append(0)
	eleves.relations.append(0)
	scores_individuels.append(0)
	nouveau_tableau_relations.emit()
	son_a_emettre.emit("valider")
	
func reduire_tableau() -> void:
	for i in nombre_eleves:
		eleves.relations.pop_at(i * nombre_eleves + nombre_eleves)
		eleves.relations.pop_back()
	eleves.relations.pop_back()
	scores_individuels.pop_back()
	nouveau_tableau_relations.emit()
	son_a_emettre.emit("annuler")

func creer_tableau_relations_initial() -> void:
	eleves.relations.clear()
	eleves.relations.resize(nombre_eleves * nombre_eleves)
	eleves.relations.fill(0)

func creer_scores_individuels_initial() -> void:
	scores_individuels.clear()
	scores_individuels.resize(nombre_eleves)
	scores_individuels.fill(0)

func changer_affinite(indice: int) -> void:
	var a_changer = eleves.relations[indice]
	a_changer += 1
	if a_changer > AFFINITE_MAX:
		a_changer = -AFFINITE_MIN
	eleves.relations[indice] = a_changer
	calculer_score_individuel(indice)
	maj_case_tableau_relations.emit(indice)
	son_a_emettre.emit("valider")

func calculer_score_individuel(indice: int) -> void:
	var place = indice % nombre_eleves
	scores_individuels[place] = 0
	for i in range(place, nombre_eleves * nombre_eleves, nombre_eleves):
		scores_individuels[place] += eleves.relations[i]
		
func vider_les_cases() -> void:
	creer_tableau_relations_initial()
	creer_scores_individuels_initial()
	nouveau_tableau_relations.emit()
	son_a_emettre.emit("annuler")

# ci dessous fonctions pour gérer le plan de classe
func plan_de_classe(plan: PackedVector3Array) -> void:
	eleves.plan.clear()
	eleves.plan.append_array(plan)
	nouveau_plan.emit()

# Ci dessous fonctions pour sauvegarder ou ouvrir les .csv contenant:
# la question posée, la classe, la liste des élèves et les affinités déclarées
func sauvegarder_tableau() -> void:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + eleves.classe + ".tres"
	var sauvegarde = ResourceSaver.save(eleves, nom_sauvegarde)
	assert(sauvegarde == OK)
	nouvelle_sauvegarde.emit()
	son_a_emettre.emit("important")
		
func ouvrir_tableau(nom_fichier: String) -> void:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + nom_fichier
	if ResourceLoader.exists(nom_sauvegarde):
		var eleves_charges = ResourceLoader.load(nom_sauvegarde)
		if eleves_charges is Eleves:
			eleves = eleves_charges
			print(eleves.classe)
		else:
			return
	nombre_eleves = eleves.noms.size()
	creer_scores_individuels_initial()
	for i in range(nombre_eleves):
		calculer_score_individuel(i)				
	maj_classe_question.emit()
	nouveau_tableau_relations.emit()
	son_a_emettre.emit("important")
