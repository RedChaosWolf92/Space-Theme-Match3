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
	if chosen_option == "Evolve to Medium Nebula":
		current_state = "Medium Nebula"
	elif chosen_option == "Evolve to Large Nebula":
		current_state = "Large Nebula"
	elif current_state == "Evolve to Star":
		EvolutionPathways.evolve_to_star(current_state)# Handle star evolution
		return
	# Pass the updated current_state to EvolutionPathways for further processing	
	EvolutionPathways.evolve_to_nebula(current_state)
