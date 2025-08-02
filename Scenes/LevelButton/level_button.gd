@tool
extends TextureButton

@onready var level_label: Label = $MC/VB/LevelLabel
@onready var score_label: Label = $MC/VB/ScoreLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var _level : int = 1:
	set(new_level):
		_level = new_level
		if is_inside_tree():
			call_deferred("_set_level_label", new_level)
#@export var _default_score : int = 1000:
	#set(new_score):
		#_default_score = new_score
		#if is_inside_tree():
			#call_deferred("_set_score_label", new_score)


func _ready() -> void:
	level_label.text = "%d" % _level
	score_label.text = "%d" % ScoreManager.get_level_best("%d"%_level)


func _set_level_label(new_level) -> void:
	level_label.text = "%d" % [new_level]
	

func _set_score_label(new_score) -> void:
	score_label.text = "%d" % [new_score]


func _on_mouse_entered() -> void:
	animation_player.play("shimmy")


func _on_mouse_exited() -> void:
	animation_player.play("return")


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_%d.tscn" % [_level])
