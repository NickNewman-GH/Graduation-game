class_name ParticleFactory

const ParticleScene = preload("res://Element Particle/Particle.tscn")

static func create(size, color):
	var particle = ParticleScene.instance()
	particle.apply_color(color)
	particle.resize(size)
	return particle
