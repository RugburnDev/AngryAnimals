extends Control

const MAIN = preload("res://Scenes/Main/main.tscn")

@onready var num_attempts: Label = $MarginContainer/VBoxContainer/HBoxContainer2/NumAttempts
@onready var v_box_game_over: VBoxContainer = $MarginContainer/CenterContainer/VBoxGameOver
@onready var music: AudioStreamPlayer2D = $Music
@onready var level_num: Label = $MarginContainer/VBoxContainer/HBoxContainer/LevelNum


var _num_attempts : int = 0
var _level_name: String

func _ready() -> void:
	pass


func _enter_tree() -> void:
	SignalHub._on_attempt_made.connect(_on_attempt_made)
	SignalHub._on_cup_detroyed.connect(_on_cup_detroyed)
	SignalHub._cast_level_name.connect(_set_level)
	
func _on_attempt_made() -> void:
	_num_attempts += 1
	num_attempts.text = "%s" % [_num_attempts]
	
	
func _on_cup_detroyed(num_cups_remaining: int) -> void:
	if num_cups_remaining == 0:
		music.play()
		v_box_game_over.show()
		ScoreManager.set_score_for_level(_level_name, _num_attempts)
		
		
func _set_level(level_name: String) -> void:
	_level_name = level_name
	level_num.text = "%s" % [level_name]
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("continue") and v_box_game_over.visible:
		get_tree().change_scene_to_packed(MAIN)
		
