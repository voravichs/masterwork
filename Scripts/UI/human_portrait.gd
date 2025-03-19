extends TextureRect

var portrait_index: int

func set_portrait(index: int):
	var atlas: AtlasTexture = self.texture
	atlas.region = Rect2(Vector2(64 * index, 0), Vector2(64,64))
