extends Area2D

@onready var splash_sound: AudioStreamPlayer = $SplashSound


func _on_body_entered(_body: Node2D) -> void:
	splash_sound.play()
