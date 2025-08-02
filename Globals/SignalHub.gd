extends Node

signal _on_bird_died
signal _on_attempt_made
signal _on_cup_detroyed(num_cups_remaining: int)
signal _cast_level_name(level_name: String)

func emit_on_bird_died() -> void:
	_on_bird_died.emit()
	
	
func emit_on_attempt_made() -> void:
	_on_attempt_made.emit()
	
	
func emit_on_cup_detroyed(num_cups_remaining: int) -> void:
	_on_cup_detroyed.emit(num_cups_remaining)
	

func emit_cast_level_name(level_name: String) -> void:
	_cast_level_name.emit(level_name)
