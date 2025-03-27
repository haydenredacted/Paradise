/mob/living/simple_animal/hostile/ash_walker
	name = "Ash Walker"
	desc = "A local of Lavaland, always seeking new sacrifices for the Necropolis."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "ashwalker"
	icon_living = "ashwalker"
	turns_per_move = 5
	response_help = "pokes the"
	response_disarm = "shoves the"
	response_harm = "hits the"
	speed = 1.5
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	obj_damage = 20
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "stabs"
	attack_sound = 'sound/weapons/swordhit.ogg'
	minbodytemp = 0
	a_intent = INTENT_HARM
	unsuitable_atmos_damage = 15
	faction = list("lavaland")
	status_flags = CANPUSH
	loot = list(
		/obj/item/spear/bonespear
	)
	sentience_type = SENTIENCE_OTHER
	footstep_type = FOOTSTEP_MOB_SHOE
