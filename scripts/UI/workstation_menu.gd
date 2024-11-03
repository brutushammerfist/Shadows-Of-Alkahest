class_name WorkstationMenu
extends Control

@onready var reagent_one_dropdown = $Background/ReagentBackground/ReagentOne
@onready var reagent_two_dropdown = $Background/ReagentBackground/ReagentTwo
@onready var curr_reagent_label = $Background/CurrReagentBackground/ReagentLabel

func _on_close_button_pressed():
	SceneDirector.player_left_menu()
	visible = false

func _on_visibility_changed():
	if self.visible:
		############################################
		## Populate Dropdowns w/ Unlocked Options ##
		############################################
		
		reagent_one_dropdown.clear()
		reagent_two_dropdown.clear()
		
		if GameDirector.unlocked_primum_essentia[Enums.Reagents.NONE]:
			reagent_one_dropdown.add_item("None", 0)
			reagent_two_dropdown.add_item("None", 0)
		if GameDirector.unlocked_primum_essentia[Enums.Reagents.FIRE]:
			reagent_one_dropdown.add_item("Fire", 1)
			reagent_two_dropdown.add_item("Fire", 1)
		if GameDirector.unlocked_primum_essentia[Enums.Reagents.WATER]:
			reagent_one_dropdown.add_item("Water", 2)
			reagent_two_dropdown.add_item("Water", 2)
		if GameDirector.unlocked_primum_essentia[Enums.Reagents.AIR]:
			reagent_one_dropdown.add_item("Air", 3)
			reagent_two_dropdown.add_item("Air", 3)
		if GameDirector.unlocked_primum_essentia[Enums.Reagents.EARTH]:
			reagent_one_dropdown.add_item("Earth", 4)
			reagent_two_dropdown.add_item("Earth", 4)
			
		###############################
		## Label for Current Reagent ##
		###############################
		update_curr_reagent_label()

func _on_imbue_button_pressed():
	var selection_one = reagent_one_dropdown.get_selected_id()
	var selection_two = reagent_two_dropdown.get_selected_id()
	
	if selection_one == selection_two:
		# Selected the same...act as if only one was selected...
		GameDirector.set_player_alch_reagent(selection_one)
	else:
		match selection_one:
			Enums.Reagents.NONE:
				# If first option is None....default to second option...
				GameDirector.set_player_alch_reagent(selection_two)
			Enums.Reagents.FIRE:
				match selection_two:
					Enums.Reagents.NONE:
						GameDirector.set_player_alch_reagent(Enums.Reagents.FIRE)
					Enums.Reagents.WATER:
						GameDirector.set_player_alch_reagent(Enums.Reagents.STEAM)
					Enums.Reagents.AIR:
						GameDirector.set_player_alch_reagent(Enums.Reagents.HEAT)
					Enums.Reagents.EARTH:
						GameDirector.set_player_alch_reagent(Enums.Reagents.LAVA)
			Enums.Reagents.WATER:
				match selection_two:
					Enums.Reagents.FIRE:
						GameDirector.set_player_alch_reagent(Enums.Reagents.STEAM)
					Enums.Reagents.NONE:
						GameDirector.set_player_alch_reagent(Enums.Reagents.WATER)
					Enums.Reagents.AIR:
						GameDirector.set_player_alch_reagent(Enums.Reagents.CLOUD)
					Enums.Reagents.EARTH:
						GameDirector.set_player_alch_reagent(Enums.Reagents.MUD)
			Enums.Reagents.AIR:
				match selection_two:
					Enums.Reagents.FIRE:
						GameDirector.set_player_alch_reagent(Enums.Reagents.HEAT)
					Enums.Reagents.WATER:
						GameDirector.set_player_alch_reagent(Enums.Reagents.CLOUD)
					Enums.Reagents.NONE:
						GameDirector.set_player_alch_reagent(Enums.Reagents.AIR)
					Enums.Reagents.EARTH:
						GameDirector.set_player_alch_reagent(Enums.Reagents.DUST)
			Enums.Reagents.EARTH:
				match selection_two:
					Enums.Reagents.FIRE:
						GameDirector.set_player_alch_reagent(Enums.Reagents.LAVA)
					Enums.Reagents.WATER:
						GameDirector.set_player_alch_reagent(Enums.Reagents.MUD)
					Enums.Reagents.AIR:
						GameDirector.set_player_alch_reagent(Enums.Reagents.DUST)
					Enums.Reagents.NONE:
						GameDirector.set_player_alch_reagent(Enums.Reagents.EARTH)
	
	update_curr_reagent_label()

func update_curr_reagent_label():
	var curr_reagent = GameDirector.get_player_alch_reagent()
		
	match curr_reagent:
		Enums.Reagents.NONE:
			curr_reagent_label.text = "None"
		Enums.Reagents.FIRE:
			curr_reagent_label.text = "Fire"
		Enums.Reagents.WATER:
			curr_reagent_label.text = "Water"
		Enums.Reagents.AIR:
			curr_reagent_label.text = "Air"
		Enums.Reagents.EARTH:
			curr_reagent_label.text = "Earth"
		Enums.Reagents.STEAM:
			curr_reagent_label.text = "Steam"
		Enums.Reagents.HEAT:
			curr_reagent_label.text = "Heat"
		Enums.Reagents.LAVA:
			curr_reagent_label.text = "Lava"
		Enums.Reagents.CLOUD:
			curr_reagent_label.text = "Cloud"
		Enums.Reagents.MUD:
			curr_reagent_label.text = "Mud"
		Enums.Reagents.DUST:
			curr_reagent_label.text = "Dust"
