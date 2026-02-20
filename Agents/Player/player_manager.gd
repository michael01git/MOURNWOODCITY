extends Node

var starting_max_inventory_size: int = 6

var player_inventory: Array[Item]
var player_health: int = 6

func _ready() -> void:
	player_inventory.resize(starting_max_inventory_size)
	player_inventory.fill(null)

## Replace item in item array. Returns a boolean on success/failure.
func add_item_at(item: Item, at_index: int) -> bool:
	if (player_inventory.size() - 1) >= at_index:
		player_inventory[at_index] = item
		return true
	else:
		return false
		
## Adds item to first empty slot in item array. Returns a boolean on success/failure.
func add_item_force(item: Item) -> bool:
	var first_null = player_inventory.find(null)
	if first_null != -1:
		player_inventory[first_null] = item
		return true
	else:
		return false

func use_item(index: int):
	if (player_inventory.size() - 1) >= index:
		var item_at_index = get_item(index)
		if item_at_index != null:
			figure_out_item_data_and_use_it(item_at_index)
			delete_item(index)
			return true
	
	return false

func figure_out_item_data_and_use_it(item: Item):
	print("You used "+item.item_name)
	
	player_health += item.heal_amount

func get_item(index: int) -> Item:
	return player_inventory.get(index)

## Remove item from inventory at index at.
func delete_item(index: int):
	if (player_inventory.size() - 1) >= index:
		player_inventory[index] = null
