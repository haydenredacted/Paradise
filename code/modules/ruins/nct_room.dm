/obj/effect/mob_spawn/human/alive/nct
	name = "Nanotrasen Career Trainer"
	role_name = "Nanotrasen Career Trainer"
	permanent = TRUE
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper-open"
	important_info = "Don't randomly attack people in the ghost bar, stay inside the ghost bar. You will still be able to roll for ghost roles."
	description = "Relax, get a beer, watch the station destroy itself and burst into flames."
	flavour_text = "You are a ghost bar occupant. You've gotten sick of being dead and decided to meet up with some of your fellow haunting brothers. Take a seat, grab a beer, and chat it out."
	assignedrole = "Ghost Bar Occupant"
	restrict_antagban = FALSE
	restrict_respawnability = FALSE
	restrict_ahud = FALSE
	outfit = /datum/outfit/job/nct

/obj/effect/mob_spawn/human/alive/nct/create(ckey, flavour = TRUE, name, mob/user = usr) // So divorced from the normal proc it's just being overriden
	var/datum/character_save/save_to_load
	if(tgui_alert(user, "Would you like to use one of your saved characters in your character creator?", "Nanotrasen Career Trainer", list("Yes", "No")) == "Yes")
		var/list/our_characters_names = list()
		var/list/our_character_saves = list()
		for(var/index in 1 to length(user.client.prefs.character_saves))
			var/datum/character_save/saves = user.client.prefs.character_saves[index]
			var/slot_name = "[saves.real_name] (Slot #[index])"
			our_characters_names += slot_name
			our_character_saves += list("[slot_name]" = saves)

		var/character_name = tgui_input_list(user, "Select a character", "Character selection", our_characters_names)
		if(!character_name)
			return
		if(QDELETED(user))
			return
		save_to_load = our_character_saves[character_name]
	else
		if(QDELETED(user))
			return
		save_to_load = new
		save_to_load.randomise()
	var/mob/living/carbon/human/human = new(get_turf(src))
	human.speaks_ooc = TRUE

	save_to_load.copy_to(human)
	human.dna.species.before_equip_job(/datum/job/assistant, human)
	human.job = assignedrole
	if(outfit)
		human.equipOutfit(outfit)
	human.dna.species.remains_type = /obj/effect/decal/cleanable/ash
	for(var/gear in save_to_load.loadout_gear)
		var/datum/gear/G = GLOB.gear_datums[text2path(gear) || gear]
		if(isnull(G))
			continue
		if(G.allowed_roles) // Fix due to shitty HUD code
			continue
		if(G.slot)
			if(human.equip_to_slot_or_del(G.spawn_item(human, save_to_load.get_gear_metadata(G)), G.slot, TRUE))
				to_chat(human, SPAN_NOTICE("Equipping you with [G.display_name]!"))
		else
			human.equip_or_collect(G.spawn_item(null, save_to_load.get_gear_metadata(G)))

	human.dna.ready_dna(human)
	human.mind_initialize()
	human.mind.assigned_role = assignedrole
	human.mind.special_role = assignedrole
	human.mind.offstation_role = TRUE
	// ADD_TRAIT(human, GHOST_ROLE)
	if(isobserver(user))
		var/mob/dead/observer/ghost = user
		if(ghost.ghost_flags & GHOST_CAN_REENTER)
			ADD_TRAIT(human, TRAIT_RESPAWNABLE, GHOST_ROLE)

	human.key = ckey
	human.dna.species.after_equip_job(/datum/job/assistant, human)
	if(isgrey(human))
		var/obj/item/organ/internal/cyberimp/brain/speech_translator/implant = new
		implant.insert(human)
	log_game("[ckey] has become a Nanotrasen Career Trainer")
	playsound(src, 'sound/machines/airlock_open.ogg', 50)
	var/mob/old_mob = GLOB.occupants_by_key["[human.ckey]"]
	if(old_mob)
		qdel(old_mob)
	GLOB.occupants_by_key["[human.ckey]"] = human
	RegisterSignal(human, COMSIG_PARENT_QDELETING, PROC_REF(clear_references_to_owner))
	return human

/obj/effect/mob_spawn/human/alive/nct/proc/clear_references_to_owner(mob/mob_to_obliterate)
	SIGNAL_HANDLER  // COMSIG_PARENT_QDELETING
	GLOB.occupants_by_key -= mob_to_obliterate.ckey

/obj/item/paper/fluff/nct_implants
	name = "Message to any Nanotrasen Career Trainers"
	info = {"
		<h3>To any Nanotrasen Career Trainers Using Implants:</h3>
		<hr />
		While the NAS Trurl is granting you a massive favor by allowing you to use these implants to help assist newer hires, we fully expect you to NOT use them in any way outside of teaching.<br>
		These implants should also not fall into anyone's hands other than yours so if you are in a perilous situtation, use your implanted bio-chip to extract yourself to ensure this implant is not stolen.
	"}
	icon_state = "paper_words"
