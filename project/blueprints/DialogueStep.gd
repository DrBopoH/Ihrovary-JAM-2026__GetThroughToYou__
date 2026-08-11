class_name DialogueStep
extends Resource

export(Resource) var speaker
export(Resource) var style_override

export(String, MULTILINE) var text = ""
export(Array, String) var choices = []

export(Array, Resource) var next_steps = []

export(String) var trigger_event = ""
