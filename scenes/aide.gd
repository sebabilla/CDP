extends RichTextLabel

var ouvert: bool = false

func _ready() -> void:
	_set_taille()
	position.x = get_viewport_rect().size.x + 1
	
func ouverture_fermeture() -> void:
	if ouvert: _fermeture()
	else: _ouverture()
	ouvert = not ouvert
	
func _ouverture() -> void:
	_maj_textes()
	_set_taille()
	var tween: Tween = create_tween()
	var ouv: float = get_viewport_rect().size.x - size.x -30
	var ferm: float = get_viewport_rect().size.x + 1
	tween.tween_property(self, "position:x", ouv, 0.2).from(ferm)
		
func _fermeture() -> void:
	position.x = get_viewport_rect().size.x + 1
	var tween: Tween = create_tween()
	var ouv: float = get_viewport_rect().size.x - size.x - 30
	var ferm: float = get_viewport_rect().size.x + 1
	tween.tween_property(self, "position:x", ferm, 0.2).from(ouv)

func _set_taille() -> void:
	size.x = get_viewport_rect().size.x / 4
	size.y = get_viewport_rect().size.y

func _maj_textes() -> void:
	var t1 = _aide()
	var t2 = _a_propos()
	text = t1 + t2
	
func _aide() -> String:
	var aide: Array[String] = [
		" ",
		"[b]" + tr("TITRE") + "[/b]" + tr("A1_INTRO"),
		" ",
		tr("A1_JAMAIS"),
		" ",
		tr("A1_SAUVEGARDES"),
		" ",
		"[i]" + tr("O0_CLASSE_ELEVES") + "[/i]",
		tr("A1_CLASSE_ELEVES"),
		" ",
		"[i]" + tr("O1_AFFINITES") + "[/i]",
		tr("A1_AFFINITES"),
		" ",
		"[i]" + tr("O2_SOCIOGRAMME") + "[/i]",
		tr("A1_SOCIOGRAMME"),
		" ",
		"[i]" + tr("O3_PLAN") + "[/i]",
		tr("A1_PLAN1"),
		tr("A1_PLAN2"),
		tr("A1_PLAN3"),
		tr("A1_CAPTURE")]
	var texte: String = ""
	for a in aide:
		texte += "[p]" + a + "[/p]"
	return texte

func _a_propos() -> String:
	var aide: Array[String] = [
		" ",
		"[b]" + tr("TITRE") + "[/b]" + tr("A2_AUTEUR"),
		tr("A2_INSPIRATION"),
		" ",
		"[font_size=14]" + tr("A2_LICENCE") + "[/font_size]"]
	var texte: String = ""
	for a in aide:
		texte += "[p]" + a + "[/p]"
	return texte

func _on_meta_clicked(meta: Variant) -> void:
	if str(meta).contains("~/.local/") and OS.get_name() == "Linux":
		OS.shell_open(OS.get_data_dir() + "/Clan de place")
	elif str(meta).contains("%APPDATA%") and OS.get_name() == "Windows":
		OS.shell_open(OS.get_data_dir() + "\\Clan de place")
	else:
		OS.shell_open(str(meta))
		
func _on_mouse_exited() -> void:
	if get_global_mouse_position().x < get_viewport_rect().size.x * 0.75:
		ouverture_fermeture()
		
