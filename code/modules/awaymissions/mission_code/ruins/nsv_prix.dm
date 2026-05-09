
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
/area/shuttle/pirx/
	requires_power = TRUE
	icon_state = "shuttle"

/area/shuttle/pirx/bridge
	name = "NSV Pirx Bridge"

/area/shuttle/pirx/main_chamber
	name = "NSV Pirx Main Chamber"

/area/shuttle/pirx/eva
	name = "NSV Pirx EVA Storage"

/area/shuttle/pirx/medical
	name = "NSV Pirx Medical Bay"

/area/shuttle/pirx/engineering
	name = "NSV Pirx Engineering"

/area/shuttle/pirx/atmospherics
	name = "NSV Pirx Atmopsherics"

/area/shuttle/pirx/cryo
	name = "NSV Pirx Cryogenics"

/area/shuttle/pirx/exit
	name = "NSV Pirx Exit"

/obj/docking_port/stationary/pirx/planet
	id = "pirx_planet"
	name = "Icy planet dock"
	dir = WEST

/obj/docking_port/stationary/pirx/station
	id = "pirx_station"
	name = "Station dock"
	dir = WEST

/obj/docking_port/mobile/pirx_shuttle
	dir = WEST
	dwidth = 11
	height = 30
	id = "pirx"
	name = "pirx shuttle"
	width = 22
	preferred_direction = EAST
	timid = TRUE

/obj/machinery/computer/shuttle/pirx
	name = "NSV Pirx shuttle console"
	shuttleId = "pirx"
	possible_destinations = "pirx_station;pirx_planet"
	resistance_flags = INDESTRUCTIBLE
	flags = NODECONSTRUCT

// MARK: CAMERA NETWORK
/obj/machinery/computer/security/telescreen/pirx
	network = list("PIRX")

/obj/machinery/camera
	network = list("PIRX")

// MARK: EXPEDITION TOOLS
/obj/machinery/suit_storage_unit/industrial/pirx
	name = "NSV Pirx modsuit storage unit"
	mask_type = /obj/item/clothing/mask/gas/explorer
	suit_type = /obj/item/mod/control/pre_equipped/standard/explorer
