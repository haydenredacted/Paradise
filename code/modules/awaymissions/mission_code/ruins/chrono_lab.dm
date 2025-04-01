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

// attack_action_types = list(/datum/action/innate/megafauna_attack/dash)
// telecomms_outpost.dmm on aurora

// old telecoms stuff, they don't actually do anything

/obj/machinery/tcomms/chrono_lab/broadcaster
	name = "broadcaster"
	desc = "A dish-shaped machine that was used to broadcast processed subspace signals. It looks old and worn out, looking like it could fall apart at any moment..."
	icon_state = "broadcaster"

/obj/machinery/tcomms/chrono_lab/reciever
	name = "subspace reciever"
	desc = "This machine has a dish-like shape and green lights. It was designed to detect and process radio activity. It looks old and worn out, looking like it could fall apart at any moment..."
	icon_state = "broadcast receiver"

/obj/machinery/tcomms/chrono_lab/server
	name = "telecommunications server"
	desc = "A machine that was used to store data and network statistics. It looks old and worn out, looking like it could fall apart at any moment..."
	icon_state = "comm_server"

/obj/machinery/tcomms/chrono_lab/bus
	name = "bus mainframe"
	desc = "A mighty piece of hardware that was used to send massive amounts of data quickly. It looks old and worn out, looking like it could fall apart at any moment..."
	icon_state = "bus"

/obj/machinery/tcomms/chrono_lab/hub
	name = "telecommunication hub"
	desc = "A mighty piece of hardware that was once used to send or receive massive amounts of data."
	icon_state = "hub"

/obj/machinery/tcomms/chrono_lab/processor
	name = "processor unit"
	desc = "This machine is was originally used to process large quantities of information."
	icon_state = "processor"

/obj/machinery/tcomms/chrono_lab/announcement_system // yea i don't think this is how it ORIGINALLY was but it's 2025 and i wasn't around
	name = "\improper Automated Announcement System"
	desc = "An automated announcement system that handles minor announcements over the radio. It looks old and worn out, looking like it could fall apart at any moment..."
	icon_state = "AAS_On"

// shadow person that disappears when you enter

