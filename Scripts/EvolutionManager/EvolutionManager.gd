# File: Scripts/EvolutionManager.gd
extends Node

@onready var PointsManager = preload("res://Scripts/EvolutionManager/PointsManager.gd").new()
@onready var EvolutionPathways = preload("res://Scripts/EvolutionManager/EvolutionPathways.gd").new()

var current_state = "Dust"

func increase_player_points(resource_type: String, match_count: int):
	PointsManager.increase_player_points(resource_type, match_count)

func check_for_evolution_options():
	var points_needed = PointsManager.get_points_needed_for_next_stage(current_state)
	EvolutionPathways.check_for_evolution_options(current_state, points_needed)

func evolve_to_next_stage(chosen_option: String):
	EvolutionPathways.evolve_to_next_stage(chosen_option, current_state)
