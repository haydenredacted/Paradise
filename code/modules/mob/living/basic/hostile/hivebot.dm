// /mob/living/basic/hivebot/tele // Hivebot Telebeacon
// 	name = "Beacon"
// 	desc = "Some odd beacon thing."
// 	icon_state = "def_radar-off"
// 	icon_living = "def_radar-off"
// 	health = 200
// 	maxHealth = 200
// 	status_flags = 0
// 	anchored = TRUE
// 	ai_controller = /datum/ai_controller/basic_controller/beacon
// 	/// The total number of hivebots to spawn
// 	var/bot_amt = 10

// /mob/living/basic/hivebot/tele/Initialize(mapload)
// 	. = ..()
// 	var/datum/effect_system/smoke_spread/smoke = new
// 	smoke.set_up(5, FALSE, loc)
// 	smoke.start()
// 	visible_message(SPAN_DANGER("[src] warps in!"))
// 	playsound(src.loc, 'sound/effects/empulse.ogg', 25, 1)

// /mob/living/basic/hivebot/tele/proc/warpbots()
// 	icon_state = "def_radar"
// 	visible_message(SPAN_WARNING("[src] turns on!"))
// 	while(bot_amt > 0)
// 		bot_amt--
// 		if(bot_amt > 3)
// 			var/mob/living/basic/hivebot/H = new /mob/living/basic/hivebot(get_turf(src))
// 			H.faction = faction
// 		else if(bot_amt > 0)
// 			var/mob/living/basic/hivebot/range/R = new /mob/living/basic/hivebot/range(get_turf(src))
// 			R.faction = faction
// 		else
// 			var/mob/living/basic/hivebot/rapid/F = new /mob/living/basic/hivebot/rapid(get_turf(src))
// 			F.faction = faction
// 	spawn(100)
// 		qdel(src)
// 	return
