// everything below is for the eon_lab.dmm ruin


/obj/structure/environmental_storytelling_holopad/eon_lab //the base for all the holopads in the ruin so they look nice in StrongDMM is good
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "holopad0"
	anchored = TRUE
	layer = HOLOPAD_LAYER
	plane = FLOOR_PLANE
	max_integrity = 300
	speaking_name = "Elias"

/obj/structure/environmental_storytelling_holopad/eon_lab/entrance
	things_to_say = list("W-wait, a visitor?! If I knew I'd have visitors I'd turn off that turret... maybe.", "This place offers nothing of use to you. This is not a place of pride, but rather shame.")
	loop_sleep_time = 5 SECONDS

/obj/structure/environmental_storytelling_holopad/eon_lab/office
	things_to_say = list("Welcome to my office. This is where I got most of my paperwork done. Higher-ups wanted lots of reports for funding purposes, I'm sure you understand.", "Now, hopefully you'll respect my privacy and leave my humble domicile.")
	loop_sleep_time = 5 SECONDS

// custom weaponry
/obj/machinery/porta_turret/syndicate/eon_lab
	name = "laser turret"
	desc = "An old, modified version of a syndicate turret designed to fire laser shots instead of bullets. However this modification has given it a weakness that other energy weapons posess..."
	projectile = /obj/item/projectile/beam/laser
	eprojectile = /obj/item/projectile/beam/laser
	shot_sound = 'sound/weapons/laser.ogg'
	eshot_sound = 'sound/weapons/laser.ogg'
	emp_vulnerable = TRUE // it's an older, run down version of it and i'll be SLIGHTLY kind to explorers. can't belive i wrote that, i must be sick.

// paper
/obj/item/paper/fluff/ruins/eon_lab/

/obj/item/paper/fluff/ruins/eon_lab/anthonys_diary // Anthony Ward
	name = "Anthony Ward's Diary"
	info = {"
	<h3>Anthony Ward's Diary</h3>
	<hr />
	<br />Day 4:<br />My therapist thought I should try and keep a journal considering my current predicament. I reluctantly agreed. He didn't say I needed to share it with anyone or anything but it's just something I don't think about. I'm already almost a week late on my first entry.
	<br />Day 5: <br /> Our research has been going fine. We have good days filled with progress, but also have bad days where it feels like we're banging our head against a wall. I guess I can relate to that.
	<br />Day 9: <br /> My team is fine, I guess. Doctor Elias is a nice man, albiet older while Alexandra is around my age, mid to late 20s. I think we all get along alright, though I've heard stories of horrible projectmates from graduate school. Maybe I should get to know them more, especially Alexandra... Hopefully all of us can get the recognition and reward we're all striving to get.
	<br /> <br /> <br /> <i> There seems to be a massive stain on the middle of the page, a mixture of coffee, tears, and a splash of blood, all obscuring the writing beneath </i> <br /> <br /> <br /> <br />
	<br> Day 31: <br />I can't take this job anymore. I shoudl've never signed up, the free therapy be DAMNED. We've... succeeded. If you can even call it that. Yeah, we can teleport people but at what cost? They come through screaming, like the world they entered from the portal is too much to handle. Screams that seem to have been held in for millenia. Some even wildly tear at their sensory organs screaming. All of them seem to scream about the same thing. <b> It's eternity in there. </b>

	"}
	icon_state = "paper_words"

/obj/item/paper/fluff/ruins/eon_lab/funding_report
	name = "Funding Report #3"
	info = {"
	<h1>Eon Transit Labs</h1>
    <h2>Project JauntGate Progress Report</h2>
    <h3>Submitted to: ______________</h3>
    <h3>Project Director: Elias Harlow</h3>
    <h3>Date: ______________</h3>

    <h2>Overview</h2>
    <p>As we submit this latest progress report, we want to extend our gratitude for the continued support and funding. Thanks to your backing, the Eon Lab has made significant strides in the advancement of cutting-edge matter displacement technology, bringing us closer than ever to full-scale implementation.</p>

    <h2>Key Milestones Achieved</h2>
    <ul>
        <li>Successful teleportation of inorganic test materials with 100% structural integrity.</li>
        <li>Live biological testing has continued to show consistent success with small organisms.</li>
        <li>Human trials have now been expanded, demonstrating further promising results.</li>
        <li>Transit time remains effectively zero, confirming the stability of our methodology.</li>
    </ul>

    <h2>Current Objectives</h2>
    <p>With the additional funding from previous allocations, we have been able to expand our research efforts. Our current focus is refining the stability of long-range jaunts, ensuring absolute precision, and exploring potential commercial, governmental, and military applications beyond controlled laboratory environments.</p>

    <h2>Future Prospects</h2>
    <p>Our continued success in human trials signals that Eon Lab is moving closer to operational deployment. With additional funding, we can refine the technology for large-scale applications, including military logistics, deep-space colonization, and emergency medical transport.</p>

    <h2>Funding Requirements</h2>
    <p>To build on the progress we have already achieved with your generous backing, we request additional funding to facilitate the next phase of testing and expansion. Key investment areas include:</p>
    <ul>
        <li>Enhanced security protocols to mitigate unforeseen transit anomalies.</li>
        <li>Expansion of platform infrastructure for larger payload testing.</li>
    </ul>

    <h2>Conclusion</h2>
    <p>Eon Lab is on the brink of revolutionizing space travel, and our progress would not have been possible without your steadfast support. With continued investment, we are confident that we can push this technology into real-world application, unlocking unprecedented opportunities for human expansion and exploration.</p>

    <p><strong>Respectfully submitted,</strong></p>
    <p><strong>Elias Harlow</strong><br>
    Project Director, Eon Transit Labs</p>"}
	icon_state = "paper_words"

/obj/item/paper/fluff/ruins/eon_lab/elias_diary //Elias Harlow
