extends ColorRect

const COULEURS = [Color("FF9100"), Color("EFEBE9"), Color("76FF03")]

var donneur : int
var receveur : int
var couleur : int
var depart: Vector2 = Vector2.ZERO
var arrivee: Vector2 = Vector2.ZERO
var epaisseur_max : float
var shader_ligne = load("res://shaders/ligne.gdshader")

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = shader_ligne
	material.set_shader_parameter("color2", Color(0, 0, 0, 0))
	material.set_shader_parameter("speed", 5)
	material.set_shader_parameter("direction", -1)
	
func _process(_delta: float) -> void:
	depart = Gestion.get_pos_eleve(donneur)
	global_position = depart
	arrivee = Gestion.get_pos_eleve(receveur)
	_def_forme()
	
func initialiser(don: int, rec: int, col: int) -> void:
	donneur = don
	receveur = rec
	couleur = col
	depart = Gestion.get_pos_eleve(donneur)
	global_position = depart
	arrivee = Gestion.get_pos_eleve(receveur)
	epaisseur_max = log(max(get_viewport_rect().size.x, get_viewport_rect().size.y))
	material.set_shader_parameter("color1", COULEURS[couleur + 1])
	_def_forme()
	set_process(false)
	
func _def_forme() -> void:
	size.x = depart.distance_to(arrivee)
	rotation = depart.angle_to_point(arrivee)
	var epaisseur: float = (epaisseur_max - log(size.x + 0.001)) * 2
	size.y = epaisseur
	material.set_shader_parameter("frequency", 300 / epaisseur)
	
func maj_col_arret(col: int) -> void:
	if col == 0 or col == couleur:
		material.set_shader_parameter("color1", COULEURS[couleur + 1])
	else:
		material.set_shader_parameter("color1", Color(0, 0, 0, 0))
		
func maj_mvmt(indice: int, col: int) -> void:
	if indice == -1:
		maj_col_arret(col)
		set_process(false)
		return
	if indice != donneur and indice != receveur:
		material.set_shader_parameter("color1", Color(0, 0, 0, 0))
	else:
		set_process(true)
