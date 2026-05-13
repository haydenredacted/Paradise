/mob/living/basic/hivebot
	name = "Hivebot"
	desc = "A small robot."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	basic_mob_flags = DEL_ON_DEATH
	step_type = FOOTSTEP_MOB_CLAW
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC

	health = 15
	maxHealth = 15
	melee_damage_lower = 2
	melee_damage_upper = 3
	melee_attack_cooldown_min = 1.5 SECONDS
	melee_attack_cooldown_max = 2.5 SECONDS

	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	speak_emote = list("states")
	bubble_icon = "machine"
	gold_core_spawnable = HOSTILE_SPAWN
	loot = list(/obj/effect/decal/cleanable/blood/gibs/robot)
	faction = list("hivebot")
	death_message = "blows apart!"

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minimum_survivable_temperature = 0
	ai_controller = /datum/ai_controller/basic_controller/hivebot
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, STAMINA = 0, OXY = 1)
	ai_controller = /datum/ai_controller/basic_controller/hivebot
	projectile_type = /obj/projectile/hivebotbullet
	projectile_sound = 'sound/weapons/gunshots/gunshot.ogg'
	///does this type do range attacks?
	is_ranged = FALSE
	/// How often can we shoot?
	var/ranged_attack_cooldown = 3 SECONDS

/mob/living/basic/hivebot/Initialize(mapload)
	. = ..()
	// AddComponent(/datum/component/appearance_on_aggro, overlay_icon = icon, overlay_state = "[initial(icon_state)]_attack")
	if(!is_ranged)
		return
	AddComponent(/datum/component/ranged_attacks, /obj/item/ammo_casing/hivebot, cooldown_time = ranged_attack_cooldown)

/mob/living/basic/hivebot/death(gibbed)
	// Only execute the below if we successfully died
	. = ..(gibbed)
	if(!.)
		return FALSE
	do_sparks(3, 1, src)

/mob/living/basic/hivebot/range
	name = "Hivebot"
	desc = "A smallish robot, this one is armed!"
	icon_state = "ranged"
	icon_living = "ranged"
	icon_dead = "ranged"
	is_ranged = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/ranged

/mob/living/basic/hivebot/rapid
	icon_state = "ranged"
	icon_living = "ranged"
	icon_dead = "ranged"
	is_ranged = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/ranged/rapid
	ranged_attack_cooldown = 1.5 SECONDS

/mob/living/basic/hivebot/strong
	name = "Strong Hivebot"
	icon_state = "strong"
	icon_living = "strong"
	icon_dead = "strong"
	desc = "A robot, this one is armed and looks tough!"
	health = 80
	maxHealth = 80
	is_ranged = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/ranged

/mob/living/basic/hivebot/mechanic
	name = "Hivebot Mechanic"
	icon_state = "strong"
	icon_living = "strong"
	icon_dead = "strong"
	desc = "A robot built for base upkeep, intended for use inside hivebot colonies."
	health = 60
	maxHealth = 60
	gold_core_spawnable = HOSTILE_SPAWN
	is_ranged = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/mechanic
	///cooldown to repair machines
	COOLDOWN_DECLARE(repair_cooldown)

/mob/living/basic/hivebot/mechanic/Initialize(mapload)
	. = ..()
	var/list/innate_actions = (
		/datum/spell/aoe/conjure/build/wall/foam_wall
	)
	grant_actions_by_list(innate_actions)

/mob/living/basic/hivebot/mechanic/early_melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if(!.)
		return FALSE

	if(ismachinery(target))
		repair_machine(target)
		return FALSE

	if(istype(target, /mob/living/basic/hivebot))
		repair_hivebot(target)
		return FALSE

/mob/living/basic/hivebot/mechanic/proc/repair_machine(obj/machinery/fixable)
	if(fixable.obj_integrity >= fixable.max_integrity)
		to_chat(src, SPAN_WARNING("Diagnostics indicate that this machine is at peak integrity."))
		return
	if(!COOLDOWN_FINISHED(src, repair_cooldown))
		to_chat(src, SPAN_WARNING("Recharging!"))
		return
	fixable.max_integrity = fixable.max_integrity - fixable.obj_integrity
	do_sparks(3, TRUE, fixable)
	to_chat(src, SPAN_WARNING("Repairs complete!"))
	COOLDOWN_START(src, repair_cooldown, 50 SECONDS)

/mob/living/basic/hivebot/mechanic/proc/repair_hivebot(mob/living/basic/bot_target)
	if(bot_target.health >= bot_target.maxHealth)
		to_chat(src, SPAN_WARNING("Diagnostics indicate that this unit is at peak integrity."))
		return
	if(!COOLDOWN_FINISHED(src, repair_cooldown))
		to_chat(src, SPAN_WARNING("Recharging!"))
		return
	bot_target.revive()
	do_sparks(3, TRUE, bot_target)
	to_chat(src, SPAN_WARNING("Repairs complete!"))
	COOLDOWN_START(src, repair_cooldown, 50 SECONDS)

/mob/living/basic/hivebot/tele // Hivebot Telebeacon
	name = "Beacon"
	desc = "Some odd beacon thing."
	icon_state = "def_radar-off"
	icon_living = "def_radar-off"
	health = 200
	maxHealth = 200
	status_flags = 0
	anchored = TRUE
	ai_controller = /datum/ai_controller/basic_controller/beacon
	/// The total number of hivebots to spawn
	var/bot_amt = 10

/obj/structure/hivebot_beacon
	name = "beacon"
	desc = "Some odd beacon thing."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "def_radar-off"
	// anchored = TRUE
	ai_controller = /datum/ai_controller/basic_controller/beacon
	density = TRUE
	var/bot_type = "norm"
	var/bot_amt = 10

/mob/living/basic/hivebot/tele/Initialize(mapload)
	. = ..()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(5, FALSE, loc)
	smoke.start()
	visible_message(SPAN_DANGER("[src] warps in!"))
	playsound(src.loc, 'sound/effects/empulse.ogg', 25, 1)

/mob/living/basic/hivebot/tele/proc/warpbots()
	icon_state = "def_radar"
	visible_message(SPAN_WARNING("[src] turns on!"))
	while(bot_amt > 0)
		bot_amt--
		if(bot_amt > 3)
			var/mob/living/basic/hivebot/H = new /mob/living/basic/hivebot(get_turf(src))
			H.faction = faction
		else if(bot_amt > 0)
			var/mob/living/basic/hivebot/range/R = new /mob/living/basic/hivebot/range(get_turf(src))
			R.faction = faction
		else
			var/mob/living/basic/hivebot/rapid/F = new /mob/living/basic/hivebot/rapid(get_turf(src))
			F.faction = faction
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), 100)
	do_sparks(3, 1, src)
	return


/obj/item/ammo_casing/hivebot
	name = "hivebot bullet casing"
	projectile_type = /obj/projectile/hivebotbullet

/obj/projectile/hivebotbullet
	damage = 20
	damage_type = BRUTE
