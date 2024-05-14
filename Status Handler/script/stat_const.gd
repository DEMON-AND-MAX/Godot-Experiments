class_name StatConst
extends Stat

const error: String = "Trying to change a constant stat - check alt parameter."

func update_stat(val: float, b_alt: bool = false) -> void:
	if !b_alt:
		print(error)
		#assert(false, error)
		return
	stat_value += val
