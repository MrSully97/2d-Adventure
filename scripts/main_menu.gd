extends Control

@onready var menu_buttons: VBoxContainer = $MenuButtons
@onready var choose_map_menu: Panel = $ChooseMapMenu
@onready var current_map_label: Label = $MenuButtons/CurrentMapLabel
@onready var map_options: OptionButton = $ChooseMapMenu/MapOptions
@onready var start_button: Button = $MenuButtons/Start

var selected_map: int = 0  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.grab_focus()
	menu_buttons.visible = true
	choose_map_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_map_label.text = "Current level: " + map_options.get_item_text(selected_map)
	pass

func _on_start_pressed() -> void:
	if selected_map == 0:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	elif selected_map == 1:
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
