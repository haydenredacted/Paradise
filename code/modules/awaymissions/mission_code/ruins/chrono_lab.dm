// bluespace river, dusts on touch similar to the SM
/turf/simulated/floor/bluespace_river
	name = "bluespace river"
	icon = 'icons/turf/floors.dmi'
	icon_state = "bluespace_river-n"
	desc = "A river of bluespace energy."
	baseturf = /turf/simulated/floor/bluespace_river // no you can't crowbar up the vaporizing liquid
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
	emp_vulnerable = TRUE // it's an older, run down version of it and i'll show a BIT of kindness to explorers. can't belive i wrote that, i must be sick.

///obj/effect/step_trigger
///datum/spell/aoe/blindness
// attack_action_types = list(/datum/action/innate/megafauna_attack/dash)
// telecomms_outpost.dmm on aurora

// old telecoms stuff, they don't actually do anything
/obj/machinery/tcomms/broadcaster
	name = "subspace broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals. It looks old and worn out, looking like it could fall apart at any moment..."
	icon_state = "broadcaster"

// shadow person that disappears when you enter

