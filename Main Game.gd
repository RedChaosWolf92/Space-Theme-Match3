# File: Scripts/Main.gd
extends Node2D

@onready var InventoryManager = $InventoryManager
@onready var TileManager = $TileManager
@onready var Match3Manager = $Match3Manager
@onready var EvolutionManager = $EvolutionManager
@onready var UIManager = $Control  # Reference the Control node with UIManager.gd attached

func _ready():
	# Initialize EvolutionPathways with UIManager
	EvolutionManager.initialize(UIManager, EvolutionManager.PointsManager)

	# Connect signals and initialize other managers
	#Match3Manager.connect("match_completed", EvolutionManager, "_on_points_earned")
	#InventoryManager.connect("inventory_full", self, "_on_inventory_full")
	#InventoryManager.connect("inventory_updated", self, "_on_inventory_updated")
	#EvolutionManager.connect("evolution_progress", UIManager, "_on_evolution_progress")
