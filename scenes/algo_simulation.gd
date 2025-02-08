extends Node

const T_INIT: int = 2000
const T_STABLE: int = 5000
const T_MAX: int = 150000
const V_SEUIL: float = 10

var N: int = 0
var simulation: bool = false
var vitesses_moyennes: Array = []
var vitesse_minimum: float = 1000
var tick_debut_sim: int = 0
var tick_dernier_minimum: int = 100000
var memoire_positions: Array = []

func _process(_delta: float) -> void:
	if simulation:
		var temps: int = Time.get_ticks_msec()
		if temps - tick_debut_sim > T_INIT:
			if temps - tick_dernier_minimum > T_STABLE and vitesse_minimum < V_SEUIL:				
				_arreter_simulation(); return
			vitesses_moyennes = %PorteEtiquettes.get_children().map(func(e): return e.linear_velocity.length())		
			var vitesse_moyenne: float = vitesses_moyennes.reduce(func(accum: float, number: float): return accum + number, 0) / N
			if vitesse_moyenne < vitesse_minimum:
				vitesse_minimum = vitesse_moyenne
				tick_dernier_minimum = temps
				memoire_positions = Globals.section.get_pos_tous_eleves()
			Noeuds.info_carto.maj_etats(vitesse_moyenne, vitesse_minimum)
		if temps - tick_debut_sim > T_MAX:
			_arreter_simulation()
			Reactions.echec(tr("S4_ECHEC_SIM"))
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Forcer"): 
		Noeuds.info_carto.self_modulate.a = 0 if Noeuds.info_carto.self_modulate.a == 1 else 1
	
func _on_simulation_pressed() -> void:
	if Globals.section.get_nb_eleves() == 0: 
		Reactions.echec(); return
	Noeuds.info_carto.initialiser()
	Noeuds.sociogramme.tracer_cercles(false)
	Noeuds.sociogramme.ouverture()
	await get_tree().create_timer(0.1).timeout
	_lancer_simulation()

func _lancer_simulation() -> void:
	simulation = true
	N = %PorteEtiquettes.get_child_count()
	vitesse_minimum = 1000
	tick_debut_sim = Time.get_ticks_msec()
	tick_dernier_minimum = 100000
	_definir_limites()
	for e in %PorteEtiquettes.get_children():
		e.demarrer_arreter()		
		
func _arreter_simulation() -> void:
	Globals.section.set_pos_tous_eleves(memoire_positions)
	get_tree().process_frame.connect(Noeuds.info_carto.hide, CONNECT_ONE_SHOT)
	_arret()
	
func _arret() -> void:
	simulation = false
	for e in %PorteEtiquettes.get_children():
		e.demarrer_arreter()
		
func arret_force() -> void:
	if simulation:
		_arret()

func _definir_limites() -> void:
	%Limites.polygon[1].x = Noeuds.sociogramme.size.x - 20
	%Limites.polygon[2] = Noeuds.sociogramme.size - Vector2(20, 20)
	%Limites.polygon[3].y = Noeuds.sociogramme.size.y - 20
