extends Button

func _on_pressed() -> void:
	if OS.get_name() == "Linux":
		OS.shell_open(OS.get_data_dir() + "/Plan de classe")
	elif OS.get_name() == "Windows":
		OS.shell_open(OS.get_data_dir() + "\\Plan de classe")
	
