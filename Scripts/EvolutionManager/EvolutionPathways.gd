# File: Scripts/EvolutionPathways.gd
extends Node

@onready var ProbabilityManager = preload("res://Scripts/ProbabilityManager.gd").new()
@onready var CompanionStarManager = preload("res://Scripts/CompanionStarManager.gd").new()

func check_for_evolution_options(current_state: String, points_needed: int):
	match current_state:
		"Small Nebula":
			if PointsManager.evolution_points >= points_needed:
				UIManager.show_evolution_choice("Evolve to Medium Nebula", "Evolve to Star")
		"Medium Nebula":
			if PointsManager.evolution_points >= points_needed * 0.6:
				UIManager.show_evolution_choice("Evolve to Large Nebula", "Keep Collecting Points")
			elif PointsManager.evolution_points >= points_needed:
				UIManager.show_evolution_choice("Evolve to Large Nebula", "Evolve to Star")
		"Large Nebula":
			UIManager.show_evolution_choice("Evolve to Star", "Keep Collecting Points")

func evolve_to_next_stage(chosen_option: String, current_state: String):
	if chosen_option == "Evolve to Star":
		evolve_to_star(current_state)
	elif chosen_option == "Evolve to Medium Nebula":
		evolve_to_nebula("Medium Nebula")
	elif chosen_option == "Evolve to Large Nebula":
		evolve_to_nebula("Large Nebula")

func evolve_to_star(current_state: String):
	var star_type = determine_star_type(current_state)
	var star_tier = determine_star_tier(star_type, current_state)
	var star_system = ProbabilityManager.determine_star_system(star_type, star_tier)
	
	if star_system == "Binary" or star_system == "Trinary":
		var companion_stars = CompanionStarManager.determine_companion_stars(star_type, star_tier, star_system)
		UIManager.update_star_state(star_type, star_tier, star_system, companion_stars)
	else:
		UIManager.update_star_state(star_type, star_tier, star_system)

func determine_star_type(current_state: String) -> String:
	if current_state == "Small Nebula":
		return "Yellow"
	elif current_state == "Medium Nebula":
		return ProbabilityManager.choose_with_probability({"Yellow": 50, "White": 50})
	elif current_state == "Large Nebula":
		return ProbabilityManager.choose_with_probability({"White": 50, "Blue": 50})
	return "Yellow"

func determine_star_tier(star_type: String, current_state: String) -> int:
	var tier_options = {}

	match current_state:
		"Small Nebula":
			tier_options = {1: 75, 2: 25}
		"Medium Nebula":
			if star_type == "Yellow":
				tier_options = {3: 40, 4: 40, 5: 20}
			elif star_type == "White":
				tier_options = {1: 40, 2: 30, 3: 30}
		"Large Nebula":
			if star_type == "White":
				tier_options = {4: 50, 5: 50}
			elif star_type == "Blue":
				tier_options = {1: 10, 2: 20, 3: 20, 4: 25, 5: 25}

	return ProbabilityManager.choose_with_probability(tier_options)

func evolve_to_nebula(next_state: String):
	current_state = next_state
	PointsManager.evolution_points = 0
	PointsManager.plasma_points = 0
	GridManager.expand_grid(current_state)
	UIManager.update_nebula_state(current_state)
