/obj/machinery/space_heater
	name = "space heater"
	desc = "A free-standing mobile space heater for heating rooms, featuring a temperature adjustment dial and an easy-swap power cell holder which are hidden behind a screwed-on panel."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	density = TRUE
	max_integrity = 250
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 100, FIRE = 80, ACID = 10)
	var/obj/item/stock_parts/cell/cell
	var/on = FALSE
	var/set_temperature = 50		// in celcius, add T0C for kelvin
	var/heating_power = 40000

/obj/machinery/space_heater/get_cell()
	return cell

/obj/machinery/space_heater/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/space_heater(null)
	component_parts += new /obj/item/stock_parts/capacitor(null)
	component_parts += new /obj/item/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stock_parts/cell(null)
	RefreshParts()
	update_icon()
	return

/obj/machinery/space_heater/RefreshParts()
	cell = null
	for(var/obj/item/stock_parts/cell/P in component_parts)
		cell = P
		return

/obj/machinery/space_heater/upgraded/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/micro_laser/quadultra(src)
	component_parts += new /obj/item/stock_parts/cell/bluespace(null)

/obj/machinery/space_heater/infinite/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/micro_laser/quadultra(src)
	component_parts += new /obj/item/stock_parts/cell/infinite(null)

/obj/machinery/space_heater/deconstruct(disassembled)
	if(cell)
		cell.forceMove(loc)
		cell = null
	return ..()

/obj/machinery/space_heater/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/machinery/space_heater/update_icon_state()
	icon_state = "sheater[on]"

/obj/machinery/space_heater/update_overlays()
	. = ..()
	if(panel_open)
		. += "sheater-open"

/obj/machinery/space_heater/examine(mob/user)
	. = ..()
	. += "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"]."
	if(panel_open)
		. += "The power cell is [cell ? "installed" : "missing"]."
	else
		. += "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"
	. += SPAN_NOTICE("You can <b>Alt-Click</b> [src] to toggle it [on ? "off" : "on"].")

/obj/machinery/space_heater/AltClick(mob/living/user)
	if(!can_use_shortcut(user))
		return
	if(panel_open)
		return
	on = !on
	user.visible_message(SPAN_NOTICE("[user] switches [on ? "on" : "off"] [src]."),
						SPAN_NOTICE("You switch [on ? "on" : "off"] [src]."))
	update_icon()

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(!istype(used, /obj/item/stock_parts/cell))
		return ..()

	if(!panel_open)
		to_chat(user, "The hatch must be open to insert a power cell.")
		return ITEM_INTERACT_COMPLETE

	if(cell)
		to_chat(user, "There is already a power cell inside.")
		return ITEM_INTERACT_COMPLETE

	// insert cell
	var/obj/item/stock_parts/cell/C = used
	if(!user.drop_item())
		to_chat(user, SPAN_WARNING("[used] is stuck to your hand!"))
		return ITEM_INTERACT_COMPLETE

	component_parts += C
	RefreshParts()
	cell.forceMove(src)
	C.add_fingerprint(user)
	user.visible_message(
		SPAN_NOTICE("[user] inserts a power cell into [src]."),
		SPAN_NOTICE("You insert the power cell into [src].")
	)
	return ITEM_INTERACT_COMPLETE

/obj/machinery/space_heater/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return

	panel_open = !panel_open
	if(panel_open)
		SCREWDRIVER_OPEN_PANEL_MESSAGE
		on = FALSE
	else
		SCREWDRIVER_CLOSE_PANEL_MESSAGE
	update_icon()
	if(!panel_open && user.machine == src)
		user << browse(null, "window=spaceheater")
		user.unset_machine()

/obj/machinery/space_heater/crowbar_act(mob/living/user, obj/item/I)
	if(panel_open && !on && default_deconstruction_crowbar(user, I))
		return TRUE

/obj/machinery/space_heater/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 0)
	return TRUE

/obj/machinery/space_heater/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	ui_interact(user)

/obj/machinery/space_heater/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/space_heater/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater", name)
		ui.open()

/obj/machinery/space_heater/ui_data(mob/user)
	var/list/data = list()
	data["on"] = on
	data["panel_open"] = panel_open
	data["set_temperature"] = set_temperature
	data["cell_present"] = !!cell
	data["cell_charge"] = cell ? round(cell.percent(), 1) : 0
	return data

/obj/machinery/space_heater/ui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	var/mob/user = ui.user
	if(!user)
		return TRUE

	add_fingerprint(user)

	switch(action)
		if("toggle_power")
			if(panel_open)
				return TRUE
			on = !on
			user.visible_message(SPAN_NOTICE("[user] switches [on ? "on" : "off"] [src]."),
								SPAN_NOTICE("You switch [on ? "on" : "off"] [src]."))
			update_icon()
			return TRUE

		if("temp")
			if(!panel_open)
				return TRUE
			var/value = text2num(params["value"])
			set_temperature = dd_range(0, 90, set_temperature + value)
			return TRUE

		if("remove_cell")
			if(!panel_open || !cell)
				return TRUE
			if(user.get_active_hand())
				to_chat(user, SPAN_WARNING("You need an empty hand to take the power cell out!"))
				return TRUE
			cell.update_icon()
			cell.forceMove(loc)
			if(Adjacent(user) && !issilicon(user))
				user.put_in_hands(cell)
			cell.add_fingerprint(user)
			for(var/obj/item/stock_parts/cell/C in component_parts)
				component_parts -= C
			cell = null
			RefreshParts()
			user.visible_message(
				SPAN_NOTICE("[user] removes the power cell from [src]."),
				SPAN_NOTICE("You remove the power cell from [src].")
			)
			return TRUE

		if("insert_cell")
			if(!panel_open || cell)
				return TRUE
			var/obj/item/stock_parts/cell/C = user.get_active_hand()
			if(!istype(C))
				return TRUE
			if(!user.drop_item())
				to_chat(user, SPAN_WARNING("[C] is stuck to your hand!"))
				return TRUE
			component_parts += C
			RefreshParts()
			C.forceMove(src)
			C.add_fingerprint(user)
			user.visible_message(
				SPAN_NOTICE("[user] inserts a power cell into [src]."),
				SPAN_NOTICE("You insert the power cell into [src].")
			)
			return TRUE
	return FALSE

/obj/machinery/space_heater/process()
	var/datum/milla_safe/space_heater_process/milla = new()
	milla.invoke_async(src)

/datum/milla_safe/space_heater_process

/datum/milla_safe/space_heater_process/on_run(obj/machinery/space_heater/heater)
	if(heater.on)
		if(heater.cell && heater.cell.charge > 0)
			var/turf/simulated/L = get_turf(heater)
			if(!istype(L))
				return
			var/datum/gas_mixture/env = get_turf_air(L)
			if(env.temperature() == heater.set_temperature + T0C)
				return
			var/transfer_moles = 0.25 * env.total_moles()

			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(!removed)
				return
			var/heat_capacity = removed.heat_capacity()

			if(heat_capacity)
				if(removed.temperature() < heater.set_temperature + T0C)
					removed.set_temperature(min(removed.temperature() + heater.heating_power / heat_capacity, 1000))
				else
					removed.set_temperature(max(removed.temperature() - heater.heating_power / heat_capacity, TCMB))
				heater.cell.use(heater.heating_power / 20000)
			env.merge(removed)
		else
			heater.on = FALSE
			heater.update_icon()
