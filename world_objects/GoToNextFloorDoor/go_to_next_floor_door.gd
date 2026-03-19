extends Node3D


func _on_player_enter(player: Player):
	if player != null:
		print("you win")
