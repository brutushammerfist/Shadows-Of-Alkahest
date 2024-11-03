extends Node

var unlocked_primum_essentia = {
	Enums.Reagents.NONE : true,
	Enums.Reagents.FIRE : false,
	Enums.Reagents.WATER : false,
	Enums.Reagents.AIR : false,
	Enums.Reagents.EARTH : false
}

func set_player_alch_reagent(reagent):
	get_tree().root.get_child(get_tree().root.get_child_count() - 1).get_node("Player").alch_reagent = reagent

func get_player_alch_reagent():
	return get_tree().root.get_child(get_tree().root.get_child_count() - 1).get_node("Player").alch_reagent

func is_void_available():
	return (
		unlocked_primum_essentia[Enums.Reagents.FIRE] and
		unlocked_primum_essentia[Enums.Reagents.WATER] and
		unlocked_primum_essentia[Enums.Reagents.AIR] and
		unlocked_primum_essentia[Enums.Reagents.EARTH]
	)
