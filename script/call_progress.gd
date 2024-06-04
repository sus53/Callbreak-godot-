extends TextureProgressBar

const DURATION = 15
var elapsed_time = 0.0

func _ready():
	self.value = self.max_value

func _process(delta):
	elapsed_time += delta

	var progress = max_value * (1.0 - elapsed_time / DURATION)
	self.value = clamp(progress, 0, max_value)

	if elapsed_time >= DURATION:
		set_process(false)
		
	if self.value == 0:
		get_tree().quit()
