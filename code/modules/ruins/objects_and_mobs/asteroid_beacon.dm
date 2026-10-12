GLOBAL_LIST_EMPTY(asteroid_beacons)

/// A buried locator beacon that can be mapped into asteroid ruins. Track it with a [/obj/item/pinpointer/asteroid_beacon], dig it up if it's buried, and defuse it for a reward.
/obj/structure/asteroid_beacon
	name = "locator beacon"
	desc = "A faintly humming beacon transmitting a repeating locator signal. A beacon pinpointer could shut it down."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	anchored = TRUE
	density = FALSE
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	/// Is this beacon currently buried under asteroid sand?
	var/buried = FALSE
	/// Assoc list of item type -> amount spawned when the beacon is defused.
	var/list/rewards = list(
		/obj/item/stack/sheet/mineral/diamond = 5,
		/obj/item/stack/sheet/mineral/gold = 15,
		/obj/item/stack/sheet/mineral/uranium = 15,
		/obj/item/stack/sheet/mineral/titanium = 20,
		/obj/item/stack/sheet/mineral/plasma = 20,
	)

/obj/structure/asteroid_beacon/Initialize(mapload)
	. = ..()
	GLOB.asteroid_beacons += src
	var/turf/simulated/floor/plating/asteroid/sand = loc
	if(istype(sand) && !sand.dug)
		bury()

/obj/structure/asteroid_beacon/Destroy()
	GLOB.asteroid_beacons -= src
	return ..()

/obj/structure/asteroid_beacon/proc/bury()
	buried = TRUE
	invisibility = INVISIBILITY_MAXIMUM

/// Called when the sand above the beacon has been dug away.
/obj/structure/asteroid_beacon/proc/unearth()
	if(!buried)
		return
	buried = FALSE
	invisibility = initial(invisibility)
	visible_message(SPAN_NOTICE("[src] is uncovered from the sand!"))

/obj/structure/asteroid_beacon/proc/defuse(mob/user)
	var/turf/T = get_turf(src)
	do_sparks(3, TRUE, T)
	playsound(T, 'sound/machines/defib_success.ogg', 50, TRUE)
	visible_message(SPAN_NOTICE("[src] emits a final chirp and shuts down, ejecting its payload."))
	var/reward_type = pick(rewards)
	var/amount = rewards[reward_type]
	if(ispath(reward_type, /obj/item/stack))
		new reward_type(T, amount)
	else
		for(var/i in 1 to amount)
			new reward_type(T)
	SSblackbox.record_feedback("tally", "asteroid_beacons_defused", 1, "[type]")
	qdel(src)
