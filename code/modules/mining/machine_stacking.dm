/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	desc = "Controls a stacking machine... in theory."
	anchored = TRUE
	var/obj/machinery/mineral/stacking_machine/machine

/obj/machinery/mineral/stacking_unit_console/Initialize(mapload)
	. = ..()
	for(var/obj/machinery/mineral/stacking_machine/found_machine in range(1, src))
		machine = found_machine
		machine.console = src
		return

	CRASH("[src] failed to link to a stacking machine!")

/obj/machinery/mineral/stacking_unit_console/Destroy()
	if(machine)
		machine.console = null
	SStgui.close_uis(src)
	machine = null
	return ..()

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/mineral/stacking_unit_console/ui_data(mob/user)
	var/list/data = list()
	var/list/ores = list()
	if(src.machine)
		for(var/O in src.machine.stack_list)
			var/obj/item/stack/sheet/s = src.machine.stack_list[O]
			if(s.amount > 0)
				ores += list(list(
					"id" = "[O]",
					"name" = initial(s.name),
					"amount" = s.amount,
					"icon" = initial(s.icon),
					"icon_state" = initial(s.icon_state),
				))
	data["ores"] = ores
	return data

/obj/machinery/mineral/stacking_unit_console/ui_act(action, list/params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("release")
			if(!src.machine)
				return FALSE
			var/type = params["id"]
			if(!(text2path(type) in src.machine.stack_list))
				return FALSE
			var/obj/item/stack/sheet/inp = src.machine.stack_list[text2path(type)]
			var/obj/item/stack/sheet/out = new inp.type()
			out.amount = inp.amount
			inp.amount = 0
			src.machine.unload_mineral(out)
			add_fingerprint(usr)
		else
			return FALSE

/obj/machinery/mineral/stacking_unit_console/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/mineral/stacking_unit_console/ui_interact(mob/user, datum/tgui/ui = null)
	user.set_machine(src)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StackingConsole", name)
		ui.open()

/obj/machinery/mineral/stacking_unit_console/ui_assets(mob/user)
	return list()

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	desc = "A machine that automatically stacks acquired materials. Controlled by a nearby console."
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_unit_console/console
	var/list/stack_list = list() //Key: Type.  Value: Instance of type.
	var/stack_amt = 50 //ammount to stack before releassing
	input_dir = EAST
	output_dir = WEST
	speed_process = TRUE

/obj/machinery/mineral/stacking_machine/Destroy()
	QDEL_LIST_CONTENTS(stack_list)
	if(console)
		console.machine = null
	console = null
	return ..()

/obj/machinery/mineral/stacking_machine/process()
	var/turf/T = get_step(src, input_dir)
	if(T)
		for(var/obj/item/stack/sheet/S in T)
			process_sheet(S)
			CHECK_TICK

/obj/machinery/mineral/stacking_machine/proc/process_sheet(obj/item/stack/sheet/inp)
	if(!(inp.type in stack_list)) //It's the first of this sheet added
		var/obj/item/stack/sheet/s = new inp.type(src,0)
		s.amount = 0
		stack_list[inp.type] = s
	var/obj/item/stack/sheet/storage = stack_list[inp.type]
	storage.amount += inp.amount //Stack the sheets
	inp.loc = null //Let the old sheet garbage collect
	while(storage.amount > stack_amt) //Get rid of excessive stackage
		var/obj/item/stack/sheet/out = new inp.type()
		out.amount = stack_amt
		unload_mineral(out)
		storage.amount -= stack_amt
