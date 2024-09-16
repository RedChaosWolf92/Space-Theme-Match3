# File: Scripts/PointsManager.gd
extends Object

var evolution_points = 0
var plasma_points = 0
var base_points_needed = 150
var evolution_factor = 1.8

var evolution_stages = ["Dust", "Small Nebula", "Medium Nebula", "Large Nebula", "Star"]
var current_state = "Dust"

#fixed max points for Dust -> Small Nebula Evolution
var points_for_dust_to_small_nebula = base_points_needed

func increase_player_points(resource_type: String, match_count: int):
	var points_to_add = calculate_points(resource_type, match_count)
	evolution_points += points_to_add

func calculate_points(resource_type: String, match_count: int) -> int:
	var points = 0
	match resource_type:
		"dust":
			points = match_count * 1
		"gas":
			points = match_count * 2
		"energy":
			points = match_count * 4
		"plasma":
			points = match_count * 10

			var max_plasma_points = get_max_plasma_points()
			if plasma_points + points > max_plasma_points:
				points = max(0, max_plasma_points - plasma_points)
			
			plasma_points += points

	return points

func get_max_plasma_points() -> int:
	var points_needed = get_points_needed_for_next_stage(current_state)
	return points_needed * 0.5  # Cap plasma contribution at 50%

func get_points_needed_for_next_stage(current_state: String) -> int:
	var current_stage_index = evolution_stages.find(current_state)
	var next_stage_index = current_stage_index + 1
	
	#Fixed Points for Dust -> Small Nebula evolution
	if current_state == "Dust":
		return points_for_dust_to_small_nebula
		
	#For Small Nebula onwards, scaling formula is applied	
	return int(base_points_needed * pow(next_stage_index, evolution_factor))
