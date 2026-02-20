extends Control

var active: bool = false

@export var shrink_view: AnimationPlayer

var itemSlotArray: Array[Node]
var active_slot: int

@export var slot: PackedScene
@onready var inventory: GridContainer = $MiddleSplit/VBoxContainer2/Inventory
@onready var interaction_buttons: Array[Node] = $MiddleSplit/VBoxContainer/HBoxContainer/Interactions/Interactions.get_children()
@onready var health_bar: ProgressBar = $MiddleSplit/VBoxContainer/HBoxContainer/Health/HealthBar

func _ready() -> void:
	for i in PlayerManager.player_inventory.size():
		var newSlot = slot.instantiate()
		inventory.add_child(newSlot)
		newSlot.slot_number = i
		newSlot.connect("onSlotInteract", on_slot_interact)
		itemSlotArray.append(newSlot)
	

func on_slot_interact(slot_number: int):
	active_slot = slot_number
	print(slot_number)
	toggle_interactable()
	toggle_slots()
	interaction_buttons[0].grab_focus()

func _on_use_pressed() -> void:
	PlayerManager.use_item(active_slot)
	
	toggle_interactable()
	toggle_slots()
	
	refresh()
	itemSlotArray[0].grab_focus()



func toggle_slots():
	for i in itemSlotArray:
		i.disabled = !i.disabled
		if i.focus_mode == 0:
			i.focus_mode = 2
		elif i.focus_mode == 2:
			i.focus_mode = 0

func toggle_interactable():
	for i in interaction_buttons:
		i.disabled = !i.disabled
		if i.focus_mode == 0:
			i.focus_mode = 2
		elif i.focus_mode == 2:
			i.focus_mode = 0

func open():
	for i in itemSlotArray:
		i.disabled = false
		i.focus_mode = 2
	for i in interaction_buttons:
		i.disabled = true
		i.focus_mode = 0
	
	refresh()
	
	itemSlotArray[0].grab_focus()
	shrink_view.play("shrink")
	active = true

func refresh():
	for i in itemSlotArray:
		var i_item = PlayerManager.get_item(i.get_index())
		if i_item != null:
			i.text = i_item.item_name
		else:
			i.text = "Empty"
	
	health_bar.value = PlayerManager.player_health

func close():
	active = false
	shrink_view.play_backwards("shrink")

func _process(delta: float) -> void:
	if !active:
		return
