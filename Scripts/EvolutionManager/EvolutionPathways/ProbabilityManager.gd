# File: Scripts/ProbabilityManager.gd
extends Node

# Helper function to calculate log base 10
func log10(value: float) -> float:
	return log(value) / log(10)

func determine_star_system(star_type: String, star_tier: int) -> String:
	var system_type = "Singular"

	match star_type:
		"Yellow":
			if star_tier <= 2:
				system_type = "Singular"
			else:
				var binary_prob = log10(star_tier) * 100
				system_type = choose_with_probability({"Singular": 100 - binary_prob, "Binary": binary_prob})
		"White":
			var binary_prob = log10(star_tier) * 100
			var trinary_prob = log10(star_tier - 3) * 50 if star_tier >= 4 else 0  # Proper ternary syntax in GDScript
			system_type = choose_with_probability({"Singular": 100 - binary_prob - trinary_prob, "Binary": binary_prob, "Trinary": trinary_prob})
		"Blue":
			var singular_prob = 10  # Very low chance of a singular system
			var binary_prob = max(60 - (star_tier - 1) * 10, 10)  # Decreases with higher tiers
			var trinary_prob = 100 - singular_prob - binary_prob  # Increases with higher tiers
			system_type = choose_with_probability({"Singular": singular_prob, "Binary": binary_prob, "Trinary": trinary_prob})

	return system_type

func choose_with_probability(options: Dictionary) -> String:
	var total_prob = 0.0
	for prob in options.values():
		total_prob += prob

	var random_value = randf() * total_prob
	var cumulative_prob = 0.0

	for key in options.keys():
		cumulative_prob += options[key]
		if random_value < cumulative_prob:
			return key

	return options.keys()[0]  # Fallback
