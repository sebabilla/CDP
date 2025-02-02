extends RigidBody2D

signal mouvement(indice: int) #-1 arret, sinon indice eleve

const COEF_FORCE: float = 5000

var eleve_indice: int = -1
var eleve_nom: String = ""
var positifs: Array[int] = []
var negatifs: Array[int] = []
var coin_hg: Vector2
var coin_bd: Vector2
var physique: bool = false
var souris: bool = false

func _ready() -> void:
	$Rond.mouse_filter = Control.MOUSE_FILTER_STOP
	
func _physics_process(_delta: float) -> void:
	if souris:
		global_position = get_global_mouse_position()
	if physique:
		var force: Vector2 = Vector2.ZERO
		for p in positifs:
			force += global_position.direction_to(Globals.section.get_pos_eleve(p)) / global_position.distance_to(Globals.section.get_pos_eleve(p))
		for n in negatifs:
			force -= 1.1 * global_position.direction_to(Globals.section.get_pos_eleve(n)) / global_position.distance_to(Globals.section.get_pos_eleve(n))
		apply_central_force(COEF_FORCE * force)
	global_position = global_position.clamp(coin_hg, coin_bd)
	Globals.section.set_pos_eleve(eleve_indice, global_position)
	
## indice de l'élève de l'étiquette
func initialiser(indice: int, limites: Rect2) -> void:
	global_position = Globals.section.get_pos_eleve(indice)
	eleve_indice = indice
	eleve_nom = Globals.section.get_nom_eleve(indice)
	$Label.text = eleve_nom
	_determiner_qui_force(indice)
	coin_hg = limites.position + Vector2(10,40)
	coin_bd = limites.end - Vector2(10,10)
	physique = false
	souris = false
	sleeping = true

func _determiner_qui_force(indice: int) -> void:
	for e in Globals.section.liste_positifs(indice):
		positifs.append(Globals.section.trouver_indice_eleve(e))
	for e in Globals.section.liste_negatifs(indice):
		negatifs.append(Globals.section.trouver_indice_eleve(e))

func demarrer_arreter() -> void:
	linear_velocity = Vector2.ZERO
	physique = not physique
	sleeping = physique
	
func _on_rond_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				souris = true
				mouvement.emit(eleve_indice)
			else:
				souris = false
				linear_velocity = Vector2.ZERO
				mouvement.emit(-1)
