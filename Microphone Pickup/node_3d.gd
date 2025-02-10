extends Node3D

var effx: AudioEffectSpectrumAnalyzerInstance

func _ready():
	effx = AudioServer.get_bus_effect_instance(1, 1)

func _process(delta):
	print(effx.get_magnitude_for_frequency_range(0, 20000, 1))
