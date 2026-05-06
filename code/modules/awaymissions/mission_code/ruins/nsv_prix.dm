
// MARK: TELECOMS
/obj/machinery/tcomms/relay/pirx
	network_id = "PIRX-RELAY"
	autolink_id = "STATION-CORE"

// MARK: ATMOSPHERIC DEVICES
/obj/machinery/atmospherics/air_sensor/pirx
	autolink_id = "pirx_exterior"

/obj/machinery/atmospherics/air_sensor/n2
	autolink_id = "pirx_n2"

/obj/machinery/atmospherics/air_sensor/o2
	autolink_id = "pirx_o2"

/obj/machinery/computer/general_air_control/large_tank_control/pirx
	name = "NSV Pirx Environmetal Analysis"
	autolink_sensors = list("pirx_exterior")

/obj/machinery/computer/general_air_control/large_tank_control/pirx_air
	name = "NSV Pirx Air Storage Monitor"
	autolink_sensors = list("pirx_n2", "pirx_o2")

// MARK: AREAS
/area/ruin/space/pirx/
	requires_power = TRUE

/area/ruin/space/pirx/bridge
	name = "NSV Pirx Bridge"

/area/ruin/space/pirx/main_chamber
	name = "NSV Pirx Main Chamber"

/area/ruin/space/pirx/eva
	name = "NSV Pirx EVA Storage"

/area/ruin/space/pirx/medical
	name = "NSV Pirx Medical Bay"

/area/ruin/space/pirx/engineering
	name = "NSV Pirx Engineering"

/area/ruin/space/pirx/atmospherics
	name = "NSV Pirx Atmopsherics"

/area/ruin/space/pirx/cryo
	name = "NSV Pirx Cryogenics"

/area/ruin/space/pirx/exit
	name = "NSV Pirx Exit"

// MARK: CAMERA NETWORK
/obj/machinery/computer/security/telescreen
	network = list("PIRX")

/obj/machinery/camera
	network = list("PIRX")

// MARK: EXPEDITION TOOLS
/obj/machinery/suit_storage_unit/industrial/pirx
	name = "NSV Pirx modsuit storage unit"
	mask_type = /obj/item/clothing/mask/gas/explorer
	suit_type = /obj/item/mod/control/pre_equipped/standard/explorer
