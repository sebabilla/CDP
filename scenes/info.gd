extends ColorRect

var ouvert: bool = false

func _ready() -> void:
	_set_taille()
	position.x = 4000

## déclenche l'ouverture ou la fermeture de l'écran d'info selon l'état précédent
func ouverture_fermeture() -> void:
	if ouvert: _fermeture()
	else: _ouverture()
	ouvert = not ouvert
	
func _ouverture() -> void:
	process_mode = PROCESS_MODE_INHERIT
	_maj_textes()
	_set_taille()
	var tween: Tween = create_tween()
	var ouv: float = get_viewport_rect().size.x - size.x - 30
	var ferm: float = get_viewport_rect().size.x + 10
	tween.tween_property(self, "position:x", ouv, 0.2).from(ferm)
		
func _fermeture() -> void:
	position.x = get_viewport_rect().size.x + 1
	var tween: Tween = create_tween()
	var ouv: float = get_viewport_rect().size.x - size.x - 30
	var ferm: float = get_viewport_rect().size.x + 10
	tween.tween_property(self, "position:x", ferm, 0.2).from(ouv)
	tween.finished.connect(func(): process_mode = PROCESS_MODE_DISABLED)
	

func _set_taille() -> void:
	size.x = get_viewport_rect().size.x * 0.25
	size.y = get_viewport_rect().size.y

func _maj_textes() -> void:
	var t1 = _aide()
	var t2 = _a_propos()
	$RichTextLabel.text = t1 + t2
	
func _aide() -> String:
	var aide: Array[String] = [
		" ",
		"[b][center]" + tr("M4_INFO") + "[/center][/b]",
		" ",
		"[b]" + tr("TITRE") + "[/b]" + tr("A1_INTRO"),
		" ",
		tr("A1_DEBUTER"),
		" ",
		"[i]" + tr("M0_MENU") + "[/i]",
		tr("A1_MENU"),
		" ",
		"[i]" + tr("C0_CLASSE_ELEVES") + "[/i]",
		tr("A1_CLASSE_ELEVES"),
		" ",
		"[i]" + tr("P0_PLAN") + "[/i]",
		"[ul]" + tr("A1_PLAN1") + "[/ul]",
		"[ul]" + tr("A1_PLAN2") + "[/ul]",
		"[ul]" + tr("A1_PLAN3") + "[/ul]",
		"[ul]" + tr("A1_CAPTURE") + "[/ul]",
		"[ul]" + tr("A1_VIDEO") + " " + tr("A1_VIDEO_IMPAIRE") + "[/ul]",
		"[ul]" +tr("A1_MDP") + "[/ul]",
		" ",
		"[i]" + tr("T0_AFFINITES") + "[/i]",
		tr("A1_QUESTION"),
		tr("A1_AFFINITES"),
		" ",
		"[i]" + tr("S0_SOCIOGRAMME") + "[/i]",
		tr("A1_JAMAIS"),
		tr("A1_SOCIOGRAMME"),
		tr("A1_POPULARITE"),
		tr("A1_SIMULATION")
		]
	var texte: String = ""
	for a in aide:
		texte += "[p]" + a + "[/p]"
	return texte

func _a_propos() -> String:
	var aide: Array[String] = [
		" ",
		"[b]" + tr("TITRE") + "[/b]" + tr("A2_AUTEUR"),
		tr("A2_INSPIRATION"),
		tr("A2_CREDITS"),
		" ",
		"[font_size=14]" + tr("A2_LICENCE") + "[/font_size]"]
	var texte: String = ""
	for a in aide:
		texte += "[p]" + a + "[/p]"
	return texte

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

# fermeture automatique
func _on_rich_text_label_mouse_exited() -> void:
	if get_global_mouse_position().x < get_viewport_rect().size.x * 0.75:
		ouverture_fermeture()
