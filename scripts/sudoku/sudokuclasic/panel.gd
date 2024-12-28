extends Panel

func _draw():
	var cell_size = Vector2(56, 56)  # Size of each grid cell
	var thickness = 2  # Thickness of the lines
	var padding = 5  # Extra padding to extend lines beyond the grid
	var extra_gap = 2  # Extra spacing between sectors
	var first_line_adjustment = -1  # Adjust the first horizontal line slightly upward
	var line_reduction_v = 3  # Shorten vertical lines
	var line_reduction_h = 7  # Shorten horizontal lines
	var vertical_extend = 1  # Extend vertical lines downward

	for i in range(1, 3):  # Draw at 3rd and 6th positions
		var offset_x = i * 3 * cell_size.x
		var offset_y = i * 3 * cell_size.y + (i - 1) * extra_gap

		# Apply the adjustment only to the first horizontal line
		if i == 1:
			offset_y += first_line_adjustment

		# Vertical lines with extra downward extension
		draw_rect(Rect2(
			Vector2(offset_x - thickness / 2, -padding + line_reduction_v),  # Start lower
			Vector2(thickness, cell_size.y * 9 + 2 * padding - 2 * line_reduction_v + vertical_extend)  # Extended downward
		), Color.BLACK)

		# Horizontal lines with shorter width
		draw_rect(Rect2(
			Vector2(-padding + line_reduction_h, offset_y - thickness / 2),  # Start inward
			Vector2(cell_size.x * 9 + 2 * padding - 2 * line_reduction_h, thickness)  # Shortened width
		), Color.BLACK)
