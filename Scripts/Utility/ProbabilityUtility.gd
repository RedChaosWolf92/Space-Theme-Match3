# File: Scripts/Utility/ProbabilityUtility.gd
extends Node

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
