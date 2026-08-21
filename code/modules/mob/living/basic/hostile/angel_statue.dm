/datum/ai_controller/basic_controller/statue
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	// ai_movement = /datum/ai_movement/basic_avoidance
	ai_movement = /datum/ai_movement/jps
	planning_subtrees = list(
		// /datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/find_and_hunt_target/look_for_light_fixtures,
	)

/mob/living/basic/hostile/statue
	name = "statue" // matches the name of the statue with the flesh-to-stone spell
	desc = "An incredibly lifelike marble carving. Its eyes seems to follow you.." // same as an ordinary statue with the added "eye following you" description
	icon = 'icons/obj/statue.dmi'
	icon_state = "angel"
	icon_living = "angel"
	icon_dead = "angel"
	gender = NEUTER
	a_intent = INTENT_HARM
	mob_biotypes = MOB_HUMANOID
	ai_controller = /datum/ai_controller/basic_controller/statue

	speed = -1
	maxHealth = 50000
	health = 50000
	healable = FALSE

	harm_intent_damage = 35
	obj_damage = 100
	melee_damage_lower = 34
	melee_damage_upper = 42
	attack_verb_simple = "scratches"
	attack_verb_continuous = "scratches"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	unsuitable_atmos_damage = 0

	faction = list("statue")
	// move_to_delay = 0 // Very fast

	animate_movement = NO_STEPS // Do not animate movement, you jump around as you're a scary statue.

	see_in_dark = 8

	// search_objects = 1 // So that it can see through walls
	#warn XRAY HAX BAN HE

	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS
	move_force = MOVE_FORCE_EXTREMELY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	pull_force = MOVE_FORCE_EXTREMELY_STRONG
	status_flags = GODMODE // Cannot push also

	var/cannot_be_seen = TRUE
	var/mob/living/creator = null

/mob/living/basic/hostile/statue/Initialize(mapload, mob/living/creator)
	. = ..()
	// Give spells
	AddSpell(new /datum/spell/aoe/flicker_lights(null))
	AddSpell(new /datum/spell/aoe/blindness(null))
	AddSpell(new /datum/spell/night_vision(null))

	// Set creator
	if(creator)
		src.creator = creator

/mob/living/basic/hostile/statue/Destroy()
	creator = null
	return ..()

/mob/living/simple_animal/hostile/statue/Move(turf/NewLoc)
	if(can_see(NewLoc))
		if(client)
			to_chat(src, SPAN_WARNING("You cannot move, there are eyes on you!"))
		return 0
	return ..()
