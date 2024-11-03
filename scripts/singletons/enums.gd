extends Node

enum Reagents {
	NONE,
	FIRE,
	WATER,
	AIR,
	EARTH,
	STEAM,			# Fire + Water
	HEAT,			# Fire + Air
	LAVA,			# Fire + Earth
	CLOUD,			# Water + Air
	MUD,			# Water + Earth
	DUST			# Air + Earth
}
