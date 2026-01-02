extends Node

var current_frequency: float = 750.0
const max_freq: float = 800.0
const min_freq: float = 700.0

func change_frequency_by(amount: float):
	current_frequency += amount
	cap_freq()

func cap_freq(): ## Make circular?
	current_frequency = clamp(current_frequency, min_freq, max_freq)
