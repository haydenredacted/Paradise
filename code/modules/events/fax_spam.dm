/datum/event/fax_spam
	name = "Fax Spam"

	var/obj/item/paper/spam/spam_type

/datum/event/fax_spam/setup()
	spam_type = pick(subtypesof(/obj/item/paper/spam))

/datum/event/fax_spam/start()
	for(var/obj/machinery/photocopier/faxmachine/F in GLOB.allfaxes)
		if(!(F.department in GLOB.admin_departments) && !(F.department in GLOB.hidden_admin_departments))
			var/obj/item/paper/spam/spam_message = new spam_type

			var/datum/fax/A = new
			A.name = spam_message.name
			A.from_department = "Junk Mail"
			A.to_department = F.department
			A.origin = null
			A.message = spam_message
			A.sent_by = null
			A.sent_at = world.time

			F.receivefax(A)

/obj/item/paper/spam
	name = "advertisement"

/obj/item/paper/spam/examine(mob/user)

/obj/item/paper/spam/AltClick(mob/user)

// /obj/item/paper/spam/test
// 	name = "ARGHHHH"

/obj/item/paper/spam/freighter
	name = "Voidhopper of Nexus Shipping Manifest"
	icon_state = "paper_words"
	desc = "A seemingly harmless shipping manifest"
