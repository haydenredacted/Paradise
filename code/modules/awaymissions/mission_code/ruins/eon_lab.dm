// everything below is for the eon_lab.dmm ruin


/obj/structure/environmental_storytelling_holopad/eon_lab //the base for all the holopads in the ruin so they look nice in StrongDMM is good
	name = "testholopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "holopad0"
	anchored = TRUE
	layer = HOLOPAD_LAYER
	plane = FLOOR_PLANE
	max_integrity = 300
	speaking_name = "Hayden"

/obj/structure/environmental_storytelling_holopad/eon_lab/entrance
	things_to_say = list("W-wait, a visitor?! If I knew I'd have visitors I'd turn off that turret... maybe.", "This place offers nothing of use to you. This is not a place of pride, but rather shame.")
	loop_sleep_time = 5 SECONDS

/obj/structure/environmental_storytelling_holopad/eon_lab/office
	things_to_say = list("Welcome to my office. This is where I got most of my paperwork done. Higher-ups wanted lots of reports for funding, I'm sure you understand.", "Now, hopefully you'll respect my privacy and leave my humble domicile.")
	loop_sleep_time = 5 SECONDS

// custom weaponry
/obj/machinery/porta_turret/syndicate/eon_lab
	name = "laser turret"
	desc = "An old, modified version of a syndicate turret designed to fire laser shots instead of bullets. However this modification has given it a weakness that other energy weapons posess..."
	projectile = /obj/item/projectile/beam/laser
	eprojectile = /obj/item/projectile/beam/laser
	shot_sound = 'sound/weapons/laser.ogg'
	eshot_sound = 'sound/weapons/laser.ogg'
	emp_vulnerable = TRUE // it's an older, run down version of it and i'll be SLIGHTLY kind to explorers. can't belive i wrote that, i must be sick.

// paper
/obj/item/paper/fluff/ruins/eon_lab/
