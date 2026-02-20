extends Button

var slot_number: int
signal onSlotInteract

func _on_pressed() -> void:
	emit_signal("onSlotInteract", slot_number)
