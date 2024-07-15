extends Node

class_name Sounds

static func play_sound_effect(sound: AudioStream):
	var audio_stream_player = AudioStreamPlayer.new()
	Engine.get_main_loop().current_scene.add_child(audio_stream_player)
	audio_stream_player.set_stream(sound)
	audio_stream_player.play()
