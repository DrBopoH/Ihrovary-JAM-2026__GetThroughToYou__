class_name DialogueStep
extends Resource

export(Texture) var background_image

export(Resource) var character
export(CharacterData.Emotion) var emotion = CharacterData.Emotion.DEFAULT
export(Resource) var style_override

export(String, MULTILINE) var text = ""
export(Array, String) var choices = []

export(Array, Resource) var next_steps = []

export(String) var trigger_event = ""
