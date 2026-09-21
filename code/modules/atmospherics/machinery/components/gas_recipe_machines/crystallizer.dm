
#define CRYSTALLIZER_MIN_PROGRESS 3
#define CRYSTALLIZER_MIN_DEVIATION 0.90
#define CRYSTALLIZER_MAX_DEVIATION 1.1
#define CRYSTALLIZER_CONDUCTIVITY 0.95

/obj/machinery/atmospherics/binary/crystallizer
	name = "crystallizer"
	desc = "Used to crystallize or solidify gases."
	icon = 'icons/obj/atmospherics/machines.dmi'
	icon_state = "crystallizer-off"
	density = TRUE
	max_integrity = 300
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, RAD = 0, FIRE = 80, ACID = 30)
	can_unwrench = TRUE

	var/datum/gas_mixture/internal
	var/gas_input = 0
	var/progress_bar = 0
	var/quality_loss = 0
	var/datum/gas_recipe/selected_recipe
	var/total_recipe_moles = 0

/obj/machinery/atmospherics/binary/crystallizer/Initialize(mapload)
	. = ..()
	internal = new
	internal.volume = 200
	internal.set_temperature(T20C)

/obj/machinery/atmospherics/binary/crystallizer/on_deconstruction()
	var/turf/local_turf = get_turf(loc)
	if(local_turf && internal.total_moles())
		local_turf.blind_release_air(internal.remove(internal.total_moles()))

/obj/machinery/atmospherics/binary/crystallizer/screwdriver_act(mob/user, obj/item/tool)
	if(on)
		return TRUE
	return default_deconstruction_screwdriver(user, "crystallizer-open", "crystallizer-off", tool)

/obj/machinery/atmospherics/binary/crystallizer/wrench_act(mob/user, obj/item/tool)
	return default_change_direction_wrench(user, tool)

/obj/machinery/atmospherics/binary/crystallizer/crowbar_act(mob/user, obj/item/tool)
	if(panel_open)
		return default_deconstruction_crowbar(user, tool)
	return FALSE

/obj/machinery/atmospherics/binary/crystallizer/CtrlClick(mob/living/user)
	if(can_use_shortcut(user) && !panel_open)
		on = !on
		update_icon()
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
	return ..()

/obj/machinery/atmospherics/binary/crystallizer/update_icon_state()
	if(panel_open)
		icon_state = "crystallizer-open"
	else
		icon_state = "crystallizer-[on ? "on" : "off"]"

/obj/machinery/atmospherics/binary/crystallizer/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "pipe", layer = GAS_PIPE_VISIBLE_LAYER)

/obj/machinery/atmospherics/binary/crystallizer/proc/update_pipenet()
	if(parent1)
		parent1.update = TRUE
	if(parent2)
		parent2.update = TRUE

/obj/machinery/atmospherics/binary/crystallizer/proc/get_gas_moles(datum/gas_mixture/mix, gas_type)
	var/gas_path = "[gas_type]"
	if(findtext(gas_path, "oxygen"))
		return mix.oxygen()
	if(findtext(gas_path, "nitrogen"))
		return mix.nitrogen()
	if(findtext(gas_path, "carbon_dioxide"))
		return mix.carbon_dioxide()
	if(findtext(gas_path, "plasma") || findtext(gas_path, "toxins"))
		return mix.toxins()
	if(findtext(gas_path, "nitrous_oxide") || findtext(gas_path, "sleeping_agent"))
		return mix.sleeping_agent()
	if(findtext(gas_path, "bz") || findtext(gas_path, "agent_b"))
		return mix.agent_b()
	if(findtext(gas_path, "hydrogen"))
		return mix.hydrogen()
	if(findtext(gas_path, "water_vapor"))
		return mix.water_vapor()
	return 0

/obj/machinery/atmospherics/binary/crystallizer/proc/set_gas_moles(datum/gas_mixture/mix, gas_type, amount)
	var/gas_path = "[gas_type]"
	if(findtext(gas_path, "oxygen"))
		mix.set_oxygen(amount)
	if(findtext(gas_path, "nitrogen"))
		mix.set_nitrogen(amount)
	if(findtext(gas_path, "carbon_dioxide"))
		mix.set_carbon_dioxide(amount)
	if(findtext(gas_path, "plasma") || findtext(gas_path, "toxins"))
		mix.set_toxins(amount)
	if(findtext(gas_path, "nitrous_oxide") || findtext(gas_path, "sleeping_agent"))
		mix.set_sleeping_agent(amount)
	if(findtext(gas_path, "bz") || findtext(gas_path, "agent_b"))
		mix.set_agent_b(amount)
	if(findtext(gas_path, "hydrogen"))
		mix.set_hydrogen(amount)
	if(findtext(gas_path, "water_vapor"))
		mix.set_water_vapor(amount)

/obj/machinery/atmospherics/binary/crystallizer/proc/transfer_gas(datum/gas_mixture/source, datum/gas_mixture/destination, gas_type, amount)
	var/available = get_gas_moles(source, gas_type)
	var/transferred = min(available, amount)
	if(transferred <= 0)
		return 0
	set_gas_moles(source, gas_type, available - transferred)
	set_gas_moles(destination, gas_type, get_gas_moles(destination, gas_type) + transferred)
	return transferred

/obj/machinery/atmospherics/binary/crystallizer/proc/check_temp_requirements()
	return internal.temperature() >= selected_recipe.min_temp * CRYSTALLIZER_MIN_DEVIATION && internal.temperature() <= selected_recipe.max_temp * CRYSTALLIZER_MAX_DEVIATION

/obj/machinery/atmospherics/binary/crystallizer/proc/inject_gases()
	for(var/gas_type in selected_recipe.requirements)
		var/required = selected_recipe.requirements[gas_type]
		if(get_gas_moles(internal, gas_type) >= required * 2)
			continue
		transfer_gas(air2, internal, gas_type, get_gas_moles(air2, gas_type) * gas_input)

/obj/machinery/atmospherics/binary/crystallizer/proc/internal_check()
	for(var/gas_type in selected_recipe.requirements)
		if(get_gas_moles(internal, gas_type) < selected_recipe.requirements[gas_type])
			return FALSE
	return TRUE

/obj/machinery/atmospherics/binary/crystallizer/proc/heat_calculations()
	var/progress_amount_to_quality = CRYSTALLIZER_MIN_PROGRESS * 4.5 / round(log(10, total_recipe_moles * 0.1), 0.01)
	if((internal.temperature() >= selected_recipe.min_temp * CRYSTALLIZER_MIN_DEVIATION && internal.temperature() <= selected_recipe.min_temp) || (internal.temperature() >= selected_recipe.max_temp && internal.temperature() <= selected_recipe.max_temp * CRYSTALLIZER_MAX_DEVIATION))
		quality_loss = min(quality_loss + progress_amount_to_quality, 100)
	var/median_temperature = (selected_recipe.max_temp + selected_recipe.min_temp) / 2
	if(internal.temperature() >= median_temperature * CRYSTALLIZER_MIN_DEVIATION && internal.temperature() <= median_temperature * CRYSTALLIZER_MAX_DEVIATION)
		quality_loss = max(quality_loss - progress_amount_to_quality, -85)
	internal.set_temperature(max(internal.temperature() + selected_recipe.energy_release / internal.heat_capacity(), TCMB))
	update_pipenet()

/obj/machinery/atmospherics/binary/crystallizer/proc/heat_conduction()
	if(!air1.total_moles() || !internal.total_moles())
		return
	var/coolant_temperature_delta = air1.temperature() - internal.temperature()
	var/cooling_heat_capacity = air1.heat_capacity()
	var/internal_heat_capacity = internal.heat_capacity()
	var/cooling_heat_amount = CRYSTALLIZER_CONDUCTIVITY * coolant_temperature_delta * (cooling_heat_capacity * internal_heat_capacity / (cooling_heat_capacity + internal_heat_capacity))
	air1.set_temperature(max(air1.temperature() - cooling_heat_amount / cooling_heat_capacity, TCMB))
	internal.set_temperature(max(internal.temperature() + cooling_heat_amount / internal_heat_capacity, TCMB))
	update_pipenet()

/obj/machinery/atmospherics/binary/crystallizer/proc/moles_calculations()
	total_recipe_moles = 0
	for(var/gas_type in selected_recipe.requirements)
		total_recipe_moles += selected_recipe.requirements[gas_type]

/obj/machinery/atmospherics/binary/crystallizer/proc/dump_gases()
	var/datum/gas_mixture/removed = internal.remove(internal.total_moles())
	if(removed)
		air2.merge(removed)

/obj/machinery/atmospherics/binary/crystallizer/process_atmos()
	if(!on || (stat & (NOPOWER | BROKEN)) || !selected_recipe)
		return
	inject_gases()
	if(!internal.total_moles())
		return
	heat_conduction()
	if(internal_check())
		if(check_temp_requirements())
			heat_calculations()
			progress_bar = min(progress_bar + CRYSTALLIZER_MIN_PROGRESS * 5 / round(log(10, total_recipe_moles * 0.1), 0.01), 100)
		else
			quality_loss = min(quality_loss + 0.5, 100)
			progress_bar = max(progress_bar - 1, 0)
	if(progress_bar != 100)
		update_pipenet()
		return
	progress_bar = 0
	for(var/gas_type in selected_recipe.requirements)
		var/required_gas_moles = selected_recipe.requirements[gas_type]
		var/amount_consumed = required_gas_moles + required_gas_moles * (quality_loss * 0.01)
		if(get_gas_moles(internal, gas_type) < amount_consumed)
			quality_loss = min(quality_loss + 10, 100)
		transfer_gas(internal, air2, gas_type, amount_consumed)

	for(var/path in selected_recipe.products)
		for(var/i in 1 to selected_recipe.products[path])
			var/obj/creation = new path(get_step(src, SOUTH))
			if(selected_recipe.dangerous)
				investigate_log("has been created in the crystallizer.", INVESTIGATE_ATMOS)
				message_admins("[src] has been created in the crystallizer [ADMIN_JMP(src)].")
	quality_loss = 0
	update_pipenet()

/obj/machinery/atmospherics/binary/crystallizer/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/atmospherics/binary/crystallizer/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/atmospherics/binary/crystallizer/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/atmospherics/binary/crystallizer/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Crystallizer", name)
		ui.open()

/obj/machinery/atmospherics/binary/crystallizer/ui_static_data(mob/user)
	var/list/data = list("selected_recipes" = list(list("name" = "Nothing", "id" = "")))
	for(var/path in GLOB.gas_recipe_meta)
		var/datum/gas_recipe/recipe = GLOB.gas_recipe_meta[path]
		if(recipe.machine_type == "Crystallizer")
			data["selected_recipes"] += list(list("name" = recipe.name, "id" = recipe.id))
	return data

/obj/machinery/atmospherics/binary/crystallizer/ui_data(mob/user)
	var/list/data = list("on" = on, "selected" = selected_recipe ? selected_recipe.id : "")
	var/list/gas_data = list()
	for(var/gas_type in list("oxygen", "nitrogen", "carbon_dioxide", "toxins", "sleeping_agent", "agent_b", "hydrogen", "water_vapor"))
		gas_data += list(list("name" = gas_type, "id" = gas_type, "amount" = round(get_gas_moles(internal, gas_type), 0.01)))
	data["internal_gas_data"] = gas_data
	var/list/requirements
	if(!selected_recipe)
		requirements = list("Select a recipe to see the requirements")
	else
		requirements = list("To create [selected_recipe.name] you will need:")
		for(var/gas_type in selected_recipe.requirements)
			requirements += "-[selected_recipe.requirements[gas_type]] moles of [gas_type]"
		requirements += "In a temperature range between [selected_recipe.min_temp] K and [selected_recipe.max_temp] K"
		requirements += "The crystallization reaction will be [selected_recipe.energy_release ? (selected_recipe.energy_release > 0 ? "exothermic" : "endothermic") : "thermally neutral"]"
	data["requirements"] = requirements.Join("\n")
	data["internal_temperature"] = internal.total_moles() ? internal.temperature() : 0
	data["progress_bar"] = progress_bar
	data["gas_input"] = gas_input
	return data

/obj/machinery/atmospherics/binary/crystallizer/ui_act(action, list/params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			update_icon()
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			return TRUE
		if("recipe")
			selected_recipe = null
			if(internal.total_moles())
				dump_gases()
			quality_loss = 0
			progress_bar = 0
			var/datum/gas_recipe/recipe = GLOB.gas_recipe_meta[params["mode"]]
			if(recipe && recipe.id != "")
				selected_recipe = recipe
				moles_calculations()
			update_pipenet()
			return TRUE
		if("gas_input")
			gas_input = clamp(text2num(params["gas_input"]), 0, 250)
			return TRUE

#undef CRYSTALLIZER_MIN_PROGRESS
#undef CRYSTALLIZER_MIN_DEVIATION
#undef CRYSTALLIZER_MAX_DEVIATION
#undef CRYSTALLIZER_CONDUCTIVITY
