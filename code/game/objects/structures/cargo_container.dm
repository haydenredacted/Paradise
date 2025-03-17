// This is going to be used to make large structures similar to the big cargo containers on CM and probably other servers.
/obj/structure/cargo_container
	name = "cargo container"
	desc = "You shouldn't see this. The urge to report this to a higher power comes over you."
	icon = 'icons/obj/cargo_container.dmi'
	icon_state = ""
	density = TRUE
	anchored = TRUE
	max_integrity = 100

/obj/structure/cargo_container/althland_shipping_container
	name = "Althland Shipping Container"
	desc = "A large shipping container with the words 'Althland Mining Company: Farragus Mining and Research' painted on the side. It looks rusted and it hasn't been touched in years."
	icon = 'icons/obj/cargo_container.dmi'
	icon_state = "alth_m"
	density = TRUE
	anchored = TRUE
	max_integrity = 100

/obj/structure/cargo_container/althland_shipping_container/left
	icon_state = "alth_l"

/obj/structure/cargo_container/althland_shipping_container/middle
	icon_state = "alth_m"

/obj/structure/cargo_container/althland_shipping_container/right
	icon_state = "alth_r"
