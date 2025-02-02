extends Node

@onready var jouer: Texture = preload("res://images/media-playback-start.svg")
@onready var suspendre: Texture = preload("res://images/media-playback-pause.svg")

const T_INIT: int = 2500
const T_STABLE: int = 10000
const T_MAX: int = 150000
const V_SEUIL: float = 15

var simulation: bool = false
var vitesse_minimum: float = 1000
var tick_debut_sim: int = 0
var tick_dernier_minimum: int = 100000
var memoire_positions: Array[Vector2] = []

func _process(_delta: float) -> void:
	if simulation:
		var temps: int = Time.get_ticks_msec()
		if temps - tick_debut_sim > T_INIT:
			if temps - tick_dernier_minimum > T_STABLE and vitesse_minimum < V_SEUIL:				
				_simuler_ou_arreter(); return		
			var vm: Array[float]
			for e in %PorteEtiquettes.get_children():
				vm.append(e.linear_velocity.length())
			var longueur: int = vm.size()
			if longueur == 0: return
			var somme: float = vm.reduce(func(accum: float, number: float): return accum + number, 0)
			var vitesse_moyenne: float = (somme/longueur)
			if vitesse_moyenne < vitesse_minimum:
				vitesse_minimum = vitesse_moyenne
				tick_dernier_minimum = temps
				memoire_positions = Globals.section.get_pos_tous_eleves()
			Noeuds.info_carto.maj_etats(vitesse_moyenne, vitesse_minimum)
		if temps - tick_debut_sim > T_MAX:
			_simuler_ou_arreter()
			Reactions.echec(tr("S4_ECHEC_SIM"))
			
func _input(event: InputEvent) -> void:
	if simulation:
		if event.is_action_pressed("Forcer"): 
			Noeuds.info_carto.self_modulate.a = 0 if Noeuds.info_carto.self_modulate.a == 1 else 1
	
func _on_simulation_pressed() -> void:
	%Simulation.release_focus()
	if Globals.section.get_nb_eleves() == 0: 
		Reactions.echec(); return
	_simuler_ou_arreter()
	
func _simuler_ou_arreter() -> void:
	simulation = not simulation
	if simulation: _simuler()		
	else: get_tree().process_frame.connect(_arreter, CONNECT_ONE_SHOT)
	for e in %PorteEtiquettes.get_children():
		e.demarrer_arreter()

func _simuler() -> void:
	vitesse_minimum = 1000
	tick_debut_sim = Time.get_ticks_msec()
	tick_dernier_minimum = 100000
	%Simulation.icon = suspendre
	_definir_limites()		
	Noeuds.info_carto.initialiser()
	Noeuds.info_carto.show()
		
func _arreter() -> void:
	%Simulation.icon = jouer
	Globals.section.set_pos_tous_eleves(memoire_positions)
	get_tree().process_frame.connect(Noeuds.info_carto.hide, CONNECT_ONE_SHOT)
	
func arret_force() -> void:
	if simulation:
		simulation = false
		%Simulation.icon = jouer
		for e in %PorteEtiquettes.get_children():
			e.demarrer_arreter()

func _definir_limites() -> void:
	%Limites.polygon[1].x = Noeuds.sociogramme.size.x - 20
	%Limites.polygon[2] = Noeuds.sociogramme.size - Vector2(20, 20)
	%Limites.polygon[3].y = Noeuds.sociogramme.size.y - 20
