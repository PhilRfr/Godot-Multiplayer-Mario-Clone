extends Node

var tracks = {}
var music = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_music("boss-battle")
	load_music("caves")
	load_music("character-select-intro", true)
	load_music("character-select-loop")
	load_music("level-intro", true)
	load_music("overworld")
	load_music('life-lost')
	load_music('game-over')
	
	load_sound('boss-hit', 'boss-hit')
	load_sound('coin', 'coin')
	load_sound('ennemy-dies', 'ennemy-dies')
	load_sound('hawkmouth-close', 'hawkmouth-close')
	load_sound('jar-in', 'jar-in')
	load_sound('jump-charge', 'jump-charge')
	load_sound('pickup', 'pickup')
	load_sound('pull-ground', 'pull-ground')
	load_sound('spring', 'spring')
	load_sound('throwing', 'throwing')
	load_sound('climb-up', 'climb-up')
	load_sound('door-appears', 'door-appears')
	load_sound('explosion', 'explosion')
	load_sound('hawkmouth-open', 'hawkmouth-open')
	load_sound('jar-out', 'jar-out')
	load_sound('phanto', 'phanto')
	load_sound('pow', 'pow')
	load_sound('select-character', 'select-character')
	load_sound('taking-damage', 'taking-damage')
	load_sound('transformation', 'transformation')


func stop_VFX(name):
	if name in tracks:
		for track in tracks[name]:
			track.stop()

func intro_finished():
	play_music(music_loop)

func load_music(name : String, is_intro : bool = false):
	var path = "res://music/" + name + ".ogg"
	var stream : AudioStreamPlayer = AudioStreamPlayer.new()
	stream.bus = "Music"
	stream.stream = load(path)
	music[name] = stream
	if is_intro:
		stream.connect("finished", self, "intro_finished")
	add_child(stream)

func load_sound(name : String, filename : String):
	var stream : AudioStreamPlayer = AudioStreamPlayer.new()
	stream.bus = "SFX"
	stream.stream = load("res://fx/" + filename + ".wav")
	add_child(stream)
	if not(name in tracks):
		var streams = []
		tracks[name] = streams
	tracks[name].append(stream)

var music_loop = ""

func play_music_with_intro(intro_name, music_loop):
	self.music_loop = music_loop
	play_music(intro_name)

func play_music(name : String):
	stop_music()
	if name in music:
		music[name].play()

func stop_music():
	for track in music:
		music[track].stop()

func play_FX(name : String):
	if name in tracks:
		var all_tracks = tracks[name]
		all_tracks = all_tracks.duplicate()
		all_tracks.shuffle()
		for track in all_tracks:
			if not track.playing:
				track.play()
				return
