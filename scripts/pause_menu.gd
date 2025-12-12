extends Control
@onready var resume_button: Button = $PanelContainer/VBoxContainer/Resume

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	hide()

func _process(delta: float) -> void:
	testEsc()

func _exit_tree() -> void:
	get_tree().paused = false

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show()

func testEsc():
	if Input.is_action_just_pressed("escape") and not get_tree().paused:
		pause()
		resume_button.grab_focus()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
