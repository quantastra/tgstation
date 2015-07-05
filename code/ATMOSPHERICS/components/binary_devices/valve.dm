/*
It's like a regular ol' straight pipe, but you can turn it on and off.
*/

/obj/machinery/atmospherics/binary/valve
	icon_state = "mvalve_map"
	name = "manual valve"
	desc = "A pipe valve"

	can_unwrench = 1

	var/frequency = 0
	var/id = null

	var/open = 0
	var/type = "m" //lets us have a nice, clean, OOP update_icon_nopipes()

/obj/machinery/atmospherics/binary/valve/open
	open = 1

/obj/machinery/atmospherics/binary/valve/update_icon_nopipes(animation = 0)
	normalize_dir()
	if(animation)
		flick("[type]valve_[open][!open]",src)
	icon_state = "[type]valve_[open?"on":"off"]"

/obj/machinery/atmospherics/binary/valve/proc/open()
	open = 1
	update_icon_nopipes()
	update_parents()
	var/datum/pipeline/parent1 = parents["p1"] ; parent1.reconcile_air()
	parents["p1"] = parent1
	investigate_log("was opened by [usr ? key_name(usr) : "a remote signal"]", "atmos")

/obj/machinery/atmospherics/binary/valve/proc/close()
	open = 0
	update_icon_nopipes()
	investigate_log("was closed by [usr ? key_name(usr) : "a remote signal"]", "atmos")

/obj/machinery/atmospherics/binary/valve/proc/normalize_dir()
	if(dir==SOUTH)
		dir = NORTH
	else if(dir==WEST)
		dir = EAST

/obj/machinery/atmospherics/binary/valve/attack_ai(mob/user)
	return

/obj/machinery/atmospherics/binary/valve/attack_hand(mob/user)
	add_fingerprint(usr)
	update_icon_nopipes(1)
	sleep(10)
	if(open)
		close()
		return
	open()

/obj/machinery/atmospherics/binary/valve/digital		// can be controlled by AI
	name = "digital valve"
	desc = "A digitally controlled valve."
	icon_state = "dvalve_map"
	type = "d"

/obj/machinery/atmospherics/binary/valve/digital/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/atmospherics/binary/valve/digital/update_icon_nopipes(animation)
	if(stat & NOPOWER)
		normalize_dir()
		icon_state = "dvalve_nopower"
		return
	..()
