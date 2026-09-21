///Global list of recipes for atmospheric machines to use
GLOBAL_LIST_INIT(gas_recipe_meta, gas_recipes_list())

/*
 * Global proc to build the gas recipe global list
 */
/proc/gas_recipes_list()
	. = list()
	for(var/recipe_path in subtypesof(/datum/gas_recipe))
		var/datum/gas_recipe/recipe = new recipe_path()

		.[recipe.id] = recipe

/datum/gas_recipe
	///Id of the recipe for easy identification in the code
	var/id = ""
	///What machine the recipe is for
	var/machine_type = ""
	///Displayed name of the recipe
	var/name = ""
	///Minimum temperature for the recipe
	var/min_temp = TCMB
	///Maximum temperature for the recipe
	var/max_temp = INFINITY
	/**
	 * Amount of thermal energy released/consumed by the reaction.
	 * Positive numbers make the reaction release energy (exothermic) while negative numbers make the reaction consume energy (endothermic).
	 */
	var/energy_release = 0
	var/dangerous = FALSE
	///Gas required for the recipe to work
	var/list/requirements
	///Products made from the recipe
	var/list/products

/datum/gas_recipe/crystallizer
	machine_type = "Crystallizer"

/datum/gas_recipe/crystallizer/metallic_hydrogen
	id = "metal_h"
	name = "Metallic hydrogen"
	min_temp = 50000
	max_temp = 150000
	energy_release = -2500000
	//requirements = list("hydrogen" = 300, "agent_b" = 50)
	requirements = list("hydrogen" = 300)
	products = list(/obj/item/stack/sheet/mineral/metal_hydrogen = 1)

/datum/gas_recipe/crystallizer/diamond
	id = "diamond"
	name = "Diamond"
	min_temp = 10000
	max_temp = 30000
	energy_release = 9500000
	requirements = list("carbon_dioxide" = 1500)
	products = list(/obj/item/stack/sheet/mineral/diamond = 1)

/datum/gas_recipe/crystallizer/plasma_sheet
	id = "plasma_sheet"
	name = "Plasma sheet"
	min_temp = 10
	max_temp = 50
	energy_release = 3500000
	requirements = list("plasma" = 450)
	products = list(/obj/item/stack/sheet/mineral/plasma = 1)

// /datum/gas_recipe/crystallizer/crystal_foam
// 	id = "crystal_foam"
// 	name = "Crystal foam grenade"
// 	energy_release = 140000
// 	requirements = list("carbon_dioxide" = 150, "nitrous_oxide" = 100, "water_vapor" = 25)
// 	products = list(/obj/item/grenade/gas_crystal/crystal_foam = 1)
