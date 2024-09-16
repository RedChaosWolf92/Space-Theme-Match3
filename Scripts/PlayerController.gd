# File: Scripts/PlayerController.gd
extends Node2D

var grid_capacity = 25
var collected_resources = []

func _process(delta):
	handle_movement(delta)
	check_for_resources()

func handle_movement(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	position += direction.normalized() * delta * 100

func check_for_resources():
	for resource in get_tree().get_nodes_in_group("resources"):
		if position.distance_to(resource.position) < 50:
			collect_resource(resource.type)
			resource.queue_free()

func collect_resource(resource_type: String):
	if collected_resources.size() < grid_capacity:
		collected_resources.append(resource_type)
	else:
		notify_grid_full()

func notify_grid_full():
	UIManager.show_grid_full_notification()
