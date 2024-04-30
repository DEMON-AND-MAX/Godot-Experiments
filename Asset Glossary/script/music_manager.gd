class_name MusicManager
extends Runnable

"""
MUSIC MANAGER
Generates a dictionary containing all music used within the current level,
including layered music which can easily be accessed and used within the game,
seamlessly integrated with non-layered music players.

Quick tip
	Keep "b_retrieve_unoptimal" true until the end of production session,
	turn it off when the project needs tightening and compression to
	easily gauge what files can be converted to smaller, faster file
	types.

Export variables
	music_dict_key:
		string identifier for music dictionary
	
	extension_list: 
		list of extensions used for by this manager
	
	b_retrieve_unoptimal:
		if files with unoptimal extensions should be retrieved from asset glossary
	
	b_print_warnings:
		if warning messages should be printed
"""

@onready var asset_glossary = $"../Asset Glossary"
"""remove this shit^^^^"""

@export var music_dict_key: String = "music"

@export var extension_list: Array[String] = [
	"wav", "mp3", "ogg"
]

@export var b_retrieve_unoptimal: bool = true
@export var b_print_warnings: bool = true

var music_player_dict: Dictionary

var unoptimal_extension_list: Array[String]

func run():
	if b_retrieve_unoptimal:
		_retrieve_unoptimal_extension_list()
		
		if b_print_warnings:
			print("WARNING: You are loading unoptimal file types, " +
			"consider converting to a different file type!")
			print(unoptimal_extension_list)
	
	_generate_music_dict()

func _retrieve_unoptimal_extension_list() -> void:
	for extension in extension_list:
		if extension in asset_glossary.unoptimal_extension_list:
			unoptimal_extension_list.append(extension)

func _generate_music_dict() -> void:
	var current_dict = asset_glossary.asset_glossary
	
	for extension in extension_list:
		if extension not in current_dict.keys():
			continue
		
		if extension in unoptimal_extension_list:
			continue
		
		current_dict = current_dict[extension]
		
		if music_dict_key not in current_dict.keys():
			continue
		
		current_dict = current_dict[music_dict_key]
		
		for song in current_dict:
			music_player_dict[song] = _parse_song(current_dict[song])

func _parse_song(song_path):
	match typeof(song_path):
		TYPE_STRING:
			return _generate_player(song_path)
		TYPE_DICTIONARY:
			assert(!song_path.keys().is_empty(), 
			"Song contains no layers, cannot load song.")
			
			var song_dict: Dictionary
			
			for layer in song_path:
				song_dict[layer] = _generate_player(song_path[layer])
			
			return song_dict
		_:
			assert(false, 
			"Unrecognized file type in function _parse_song, cannot create music dictionary.")

func _generate_player(song_path: String) -> AudioStreamPlayer:
	assert(song_path != "", 
	"Song path empty, cannot load song.")
	
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.stream = load(song_path)
	
	return audio_stream_player
