extends Node2D

#var numberOfPlayersText
#var numberOfPlayers

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_confirm_button_pressed():
	if $MainMenuContainer/TextEdit.text == "":
		$RichTextLabel.visible = false
		print("string is null, defaulting to 3")
		Globals.player_count = 3
		get_tree().change_scene_to_file("res://Scenes/labyrinth_scene.tscn")
	elif $MainMenuContainer/TextEdit.text == "2" || $MainMenuContainer/TextEdit.text == "3" || $MainMenuContainer/TextEdit.text == "4" || $MainMenuContainer/TextEdit.text == "5" || $MainMenuContainer/TextEdit.text == "6":
		$RichTextLabel.visible = false
		print("string NOT null: ", $MainMenuContainer/TextEdit.text)
		Globals.player_count = int($MainMenuContainer/TextEdit.text)
		get_tree().change_scene_to_file("res://Scenes/labyrinth_scene.tscn")
	else:
		$RichTextLabel.visible = true

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu_scene.tscn")
