extends ColorRect

enum {ORANGE, VERT}
const COULEURS: Array[Color] = [Color("FFA726"), Color("00E676")]
const SHADER: String = "res://shaders/ligne.gdshader"

var donneur : int
var receveur : int
var couleur : int
@onready var longueur_max : float = get_viewport_rect().size.length()

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = load(SHADER)
	material.set_shader_parameter("color2", Color(0, 0, 0, 0))
	material.set_shader_parameter("speed", 5)
	material.set_shader_parameter("direction", -1)
	
func _process(_delta: float) -> void:
	global_position = Globals.section.get_pos_eleve(donneur)
	_def_forme()

## Chaque flèche a besoin de savoir quels élèves elle relie (donneur et receveur)
## et la couleur de relation à afficher, ORANGE ou VERT
func initialiser(don: int, rec: int, col: int) -> void:
	donneur = don
	receveur = rec
	couleur = col
	global_position = Globals.section.get_pos_eleve(donneur)
	material.set_shader_parameter("color1", COULEURS[couleur])
	_def_forme()
	
func _def_forme() -> void:
	var mem_x: float = size.x
	var arrivee: Vector2 = Globals.section.get_pos_eleve(receveur)
	size.x = global_position.distance_to(arrivee)
	if mem_x != size.x:
		rotation = global_position.angle_to_point(arrivee)
		size.y = min(longueur_max / max(size.x, 1.0) / 2, 10)
		material.set_shader_parameter("frequency", size.x / 5) # phase du sinus du shader constante

## Cache toutes les fleches non raccordées à l'étiquette en mouvement
func maj_mvmt(indice: int) -> void:
	if indice == -1:
		modulate.a = 1.0
	elif indice != donneur and indice != receveur:
		modulate.a = 0.0
	else:
		longueur_max = get_viewport_rect().size.length()

## Qd l'utilisateur ne veut voir qu'une couleur, ORANGE ou VERT
func maj_col_arret(col: int) -> void:
	if couleur == col:
		if material.get_shader_parameter("color1") == Color(0, 0, 0, 0):
			material.set_shader_parameter("color1", COULEURS[couleur])
		else:
			material.set_shader_parameter("color1", Color(0, 0, 0, 0))
