// This is going to be used to make large structures similar to the big cargo containers on CM and probably other servers.
/obj/structure/cargo_container
	name = "cargo container"
	desc = "You shouldn't see this. The urge to report this to a higher power comes over you."
	icon = 'icons/obj/cargo_container.dmi'
	icon_state = ""
	density = TRUE
	anchored = TRUE
	max_integrity = 100

// The test UPP shipping container
/obj/structure/cargo_container/UPP_shipping_container
	name = "UPP shipping container"
	desc = "A large shipping container with a logo on it. You feel like it's originally from a different system..."
	icon = 'icons/obj/cargo_container.dmi'
	icon_state = "upp_m"
	density = TRUE
	anchored = TRUE
	max_integrity = 100

/obj/structure/cargo_container/UPP_shipping_container/left
	icon_state = "upp_l"

/obj/structure/cargo_container/UPP_shipping_container/middle
	icon_state = "upp_m"

/obj/structure/cargo_container/UPP_shipping_container/right
	icon_state = "upp_r"
