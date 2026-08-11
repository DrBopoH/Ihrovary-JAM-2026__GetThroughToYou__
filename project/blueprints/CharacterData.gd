class_name CharacterData
extends Resource

enum Emotion {
	DEFAULT,
	JOY,
	ANGER,
	SAD,
	SURPRISE,
	DISGUST,
	ACCEPTANCE
}

export(String) var character_name = ""
export(Color) var name_color = Color.white

export(Texture) var default_portrait
export(Texture) var joy_portrait
export(Texture) var anger_portrait
export(Texture) var sad_portrait
export(Texture) var surprise_portrait
export(Texture) var disgust_portrait
export(Texture) var acceptance_portrait

func get_portrait(emotion: int) -> Texture:
	match emotion:
		Emotion.JOY:
			return joy_portrait if joy_portrait else default_portrait
		Emotion.ANGER:
			return anger_portrait if anger_portrait else default_portrait
		Emotion.SAD:
			return sad_portrait if sad_portrait else default_portrait
		Emotion.SURPRISE:
			return surprise_portrait if surprise_portrait else default_portrait
		Emotion.DISGUST:
			return disgust_portrait if disgust_portrait else default_portrait
		Emotion.ACCEPTANCE:
			return acceptance_portrait if acceptance_portrait else default_portrait
		_:
			return default_portrait
