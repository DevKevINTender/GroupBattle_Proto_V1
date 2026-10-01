extends Control
export(Resource) var selection_channel

func _on_TextureButton_pressed():
	selection_channel.request_change_direction()
