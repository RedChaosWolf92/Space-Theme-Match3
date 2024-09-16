# File: Scripts/EvolutionManager.gd
extends Node2D

@onready var PointsManager = preload("res://Scripts/EvolutionManager/PointsManager.gd").new()
@onready var EvolutionPathways = $EvolutionPathways

var current_state = "Dust"
var UIManager = null

func initialize(ui_manager, points_manager):
	UIManager = ui_manager
	PointsManager = points_manager
	EvolutionPathways.initialize(UIManager, PointsManager)

func increase_player_points(resource_type: String, match_count: int):
	PointsManager.increase_player_points(resource_type, match_count)
	check_for_evolution_options()

func check_for_evolution_options():
	var points_needed = PointsManager.get_points_needed_for_next_stage(current_state)
	EvolutionPathways.check_for_evolution_options(current_state, points_needed)

func evolve_to_next_stage(chosen_option: String):
	EvolutionPathways.evolve_to_next_stage(chosen_option, current_state)
