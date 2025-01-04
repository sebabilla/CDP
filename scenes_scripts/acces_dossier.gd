extends Button

func _on_pressed() -> void:
	if OS.get_name() == "Linux":
		OS.shell_open(OS.get_data_dir() + "/Clan de place")
	elif OS.get_name() == "Windows":
		OS.shell_open(OS.get_data_dir() + "\\Clan de place")
	
