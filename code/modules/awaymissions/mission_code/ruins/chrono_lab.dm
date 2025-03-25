// bluespace river, dusts on touch similar to the SM
/turf/simulated/floor/bluespace_river
	name = "bluespace river"
	icon = 'icons/turf/floors.dmi'
	icon_state = "bluespace_river-n"
	desc = "A river of bluespace energy."
	baseturf = /turf/simulated/floor/bluespace_river // no you can't crowbar up the vaporizing liquid
	slowdown = 2
	light_range = 2
	light_power = 0.75
	light_color = LIGHT_COLOR_PURE_BLUE
	real_layer = PLATING_LAYER

/turf/simulated/floor/bluespace_river/south
	icon_state = "bluespace_river-s"

/turf/simulated/floor/bluespace_river/east
	icon_state = "bluespace_river-e"

/turf/simulated/floor/bluespace_river/west
	icon_state = "bluespace_river-w"

// custom weaponry
/obj/machinery/porta_turret/syndicate/chrono_lab
	name = "laser turret"
	desc = "An older, modified version of a syndicate turret designed to fire laser shots instead of bullets. However this modification has given it a weakness that other energy weapons posess..."
	projectile = /obj/item/projectile/beam/laser
	eprojectile = /obj/item/projectile/beam/laser
	shot_sound = 'sound/weapons/laser.ogg'
	eshot_sound = 'sound/weapons/laser.ogg'
	emp_vulnerable = TRUE // it's an older, run down version of it and i'll be SLIGHTLY kind to explorers. can't belive i wrote that, i must be sick.

///obj/effect/step_trigger
///datum/spell/aoe/blindness
// attack_action_types = list(/datum/action/innate/megafauna_attack/dash)

// step triggers, basically the horror stuff


/obj/effect/step_trigger/thrower/chrono_lab/north_three
	direction = NORTH
	tiles = 3	// if 0: forever until atom hits a stopper

/obj/effect/step_trigger/thrower/chrono_lab/north_three
    direction = NORTH
    tiles = 3 // if 0: forever until atom hits a stopper
    var/triggered = FALSE // Flag to track if it has been triggered

/obj/effect/step_trigger/thrower/chrono_lab/north_three/Trigger(atom/movable/AM)
	if (triggered)
		return
	triggered = TRUE
	..()


// shadow person that disappears when you enter
/mob/living/carbon/human/shadow/chrono_lab
	name = "shadow person"
	desc = "A shadowy figure that seems to be watching you. It disappears as you approach."
	var/visible = TRUE
	var/datum/proximity_monitor/proximity_monitor

/mob/living/carbon/human/shadow/chrono_lab/Initialize(mapload)
	. = ..()
	proximity_monitor = new(src, 6)

/mob/living/carbon/human/shadow/chrono_lab/HasProximity(atom/movable/AM)
	if(!ishuman(AM) || visible) // No simple mobs or borgs setting this off.
		return
	var/mob/living/carbon/human/H = AM
	disappear(H)

/mob/living/carbon/human/shadow/chrono_lab/proc/disappear(mob/living/carbon/human/H)
	visible = FALSE
	QDEL_NULL(proximity_monitor)
	qdel(/mob/living/carbon/human/shadow/chrono_lab, H)
