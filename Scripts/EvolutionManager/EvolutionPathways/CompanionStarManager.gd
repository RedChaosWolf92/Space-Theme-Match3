# File: Scripts/CompanionStarManager.gd
extends Node

@onready var ProbabilityManager = preload("res://Scripts/EvolutionManager/EvolutionPathways/ProbabilityManager.gd").new()

# Helper function to calculate log base 10
func log10(value: float) -> float:
	return log(value) / log(10)

func determine_companion_stars(star_type: String, star_tier: int, star_system: String) -> Array:
	var companion_stars = []

	if star_system == "Binary":
		companion_stars.append(determine_companion_star_for_binary(star_type, star_tier))
	elif star_system == "Trinary":
		companion_stars.append(determine_companion_star_for_binary(star_type, star_tier))
		companion_stars.append(determine_companion_star_for_trinary(star_type, star_tier))

	return companion_stars

func determine_companion_star_for_binary(star_type: String, star_tier: int) -> Dictionary:
	var companion_type = "Yellow"
	var companion_tier = 1

	match star_type:
		"Yellow":
			companion_type = "Yellow"
			companion_tier = 1  # Always Tier 1 Yellow Star
		"White":
			if star_tier == 1:
				companion_type = "Yellow"
				companion_tier = 3  # Tier 3 Yellow Star
			else:
				var yellow_prob = 50 + (log10(star_tier) * 10)  # Using custom log10() helper function
				companion_type = ProbabilityManager.choose_with_probability({"Yellow": yellow_prob, "White": 100 - yellow_prob})
				companion_tier = ProbabilityManager.choose_with_probability({"3": 30, "4": 40, "5": 30}) if companion_type == "Yellow" else star_tier - 1
		"Blue":
			var white_prob = pow(2, star_tier)  # Exponential increase for White star
			var yellow_prob = 100 - (log10(star_tier) * 50)  # Using custom log10() helper function
			companion_type = ProbabilityManager.choose_with_probability({"White": white_prob, "Yellow": yellow_prob})
			companion_tier = ProbabilityManager.choose_with_probability({"3": 25, "4": 35, "5": 40}) if companion_type == "Yellow" else star_tier - 1

	return {"type": companion_type, "tier": companion_tier}

func determine_companion_star_for_trinary(star_type: String, star_tier: int) -> Dictionary:
	var companion_type = "Yellow"
	var companion_tier = 1

	match star_type:
		"White":
			if star_tier >= 4:
				companion_type = "Yellow"
				companion_tier = 2  # Second star: Tier 2 Yellow Star
				var tier_2_prob = 100 - (log10(star_tier) * 50)  # Using custom log10() helper function
				companion_type = ProbabilityManager.choose_with_probability({
					"Yellow": tier_2_prob, 
					"White": 100 - tier_2_prob
				})
				companion_tier = 2 if companion_type == "Yellow" else 1

				# Third star: Tier 1 Yellow Star, decreasing log10 probability to Tier 5 Yellow Star
				companion_type = "Yellow"
				companion_tier = ProbabilityManager.choose_with_probability({
					"1": 60, "2": 20, "3": 10, "4": 7, "5": 3
				})

		"Blue":
			if star_tier == 1:
				companion_type = "Yellow"
				companion_tier = 5  # Second star: Tier 5 Yellow Star
			else:
				var white_prob = 100 - (log10(star_tier) * 60)  # Rapid decreasing log10() for White Star
				companion_type = ProbabilityManager.choose_with_probability({
					"White": white_prob, 
					"Yellow": 100 - white_prob
				})
				companion_tier = ProbabilityManager.choose_with_probability({
					"3": 25, "4": 35, "5": 40
				}) if companion_type == "Yellow" else 1

				# Third star: Decreasing log10() probability of higher-tier Yellow Star from Tier 1
				companion_type = "Yellow"
				companion_tier = ProbabilityManager.choose_with_probability({
					"1": 50, "2": 25, "3": 15, "4": 7, "5": 3
				})

	return {"type": companion_type, "tier": companion_tier}
