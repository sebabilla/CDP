extends ColorRect

func _ready() -> void:
	hide()
	process_mode = PROCESS_MODE_DISABLED

## Ouvre le popup de message et affiche le texte dans un label (pas de format BBcode)
func ouverture(texte: String) -> void:
	process_mode = PROCESS_MODE_INHERIT
	%Message.text = texte
	show()
	%Oui.grab_focus()

func _on_oui_pressed() -> void:
	hide()
	process_mode = PROCESS_MODE_DISABLED
