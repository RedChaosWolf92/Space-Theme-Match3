# File: Scripts/UIManager.gd
extends Control

# Variables to reference the UI elements, for example labels and popups
@onready var EvolutionChoicePopup = $EvolutionChoicePopup
@onready var StarStateLabel = $StarStateLabel
@onready var NebulaStateLabel = $NebulaStateLabel
@onready var SystemTypeLabel = $SystemTypeLabel
@onready var CompanionStarsLabel = $CompanionStarsLabel

# Displays the evolution options to the player, e.g., evolving to a star or a nebula.
func show_evolution_choice(option1: String, option2: String):
	EvolutionChoicePopup.set_options(option1, option2)
	EvolutionChoicePopup.show()

# Updates the nebula state on the UI when the player evolves to a new nebula state.
func update_nebula_state(state: String):
	NebulaStateLabel.text = "Current State: " + state

# Updates the UI to show the current state of the star system (e.g., type, tier, and system type).
# If the system has companion stars (binary or trinary), it also updates that information.
func update_star_state(star_type: String, star_tier: int, star_system: String, companion_stars: Array = []):
	StarStateLabel.text = "Star Type: " + star_type + " | Tier: " + str(star_tier)
	SystemTypeLabel.text = "System Type: " + star_system

	if companion_stars.size() > 0:
		var companions_text = "Companions: "
		for companion in companion_stars:
			companions_text += companion["type"] + " Tier " + str(companion["tier"]) + ", "
		CompanionStarsLabel.text = companions_text.strip_edges(", ")
	else:
		CompanionStarsLabel.text = ""
