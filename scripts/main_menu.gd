extends Control

@onready var generator_map_options = get_node("/root/GlobalSingleton")

@onready var menu_buttons: VBoxContainer = $MenuButtons
@onready var choose_map_menu: Panel = $ChooseMapMenu
@onready var current_map_label: Label = $MenuButtons/CurrentMapLabel
@onready var map_options: OptionButton = $ChooseMapMenu/MapOptions
@onready var start_button: Button = $MenuButtons/Start

var selected_map: int = 0
var available_maps: Array[String] = [] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_available_maps()
	
	start_button.grab_focus()
	menu_buttons.visible = true
	choose_map_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if available_maps.size() > 0 and selected_map < available_maps.size():
		current_map_label.text = "Current level: " + available_maps[selected_map]
	else:
		current_map_label.text = "Current level: None"

func _on_start_pressed() -> void:
	if available_maps.size() == 0:
		push_warning("No maps available.")
		return

	var map_file := available_maps[selected_map]
	var map_path = "res://maps/" + map_file  # save for game scene
	
	if selected_map == 0:
		generator_map_options.setMap(null)
		get_tree().change_scene_to_file("res://scenes/generator_game.tscn")
	elif selected_map == 1:
		generator_map_options.setMap(null)
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		generator_map_options.setMap(map_path)
		get_tree().change_scene_to_file("res://scenes/generator_game.tscn")

func _on_choose_map_pressed() -> void:
	menu_buttons.visible = false
	choose_map_menu.visible = true
	map_options.grab_focus()

func _on_select_map_pressed() -> void:
	selected_map = map_options.get_selected_id()
	menu_buttons.visible = true
	choose_map_menu.visible = false
	start_button.grab_focus()
	

func _on_quit_pressed() -> void:
	get_tree().quit()

# Loads all availble maps from res://maps folder
func load_available_maps() -> void:
	available_maps.clear()
	map_options.clear()

	var dir := DirAccess.open("res://maps/")
	if dir == null:
		push_error("Could not open maps folder")
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	# Add generated map and tutorial map options
	map_options.add_item("Generate Map")
	map_options.add_item("Tutorial Map")
	
	available_maps.append("Generate Map")
	available_maps.append("Tutorial Map")

	while file_name != "":
		if file_name.ends_with(".json"):
			available_maps.append(file_name)
			map_options.add_item(file_name)
		file_name = dir.get_next()

	dir.list_dir_end()

	# Auto-select first map if exists
	if available_maps.size() > 0:
		map_options.select(0)
		selected_map = 0
