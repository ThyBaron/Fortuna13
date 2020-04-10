/mob/living/carbon/adjustStaminaLossBuffered(amount, updating_health = 1)
	if(status_flags & GODMODE)
		return 0
	if(CONFIG_GET(flag/disable_stambuffer))
		return
	var/directstamloss = (bufferedstam + amount) - stambuffer
	if(directstamloss > 0)
		adjustStaminaLoss(directstamloss)
	bufferedstam = CLAMP(bufferedstam + amount, 0, stambuffer)
	stambufferregentime = world.time + 10
	if(updating_health)
		update_health_hud()

/mob/living/carbon/adjustStaminaLoss(amount, updating_health = TRUE, forced = FALSE, affected_zone = BODY_ZONE_CHEST)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	var/obj/item/bodypart/BP
	if(isbodypart(affected_zone)) //we specified a bodypart object
		BP = def_zone
	else
		BP = get_bodypart(check_zone(affecteed_zone)) || bodyparts[1]
	if(amount > 0? BP.receieve_damage(0, 0, amount) : BP.heal_damage(0, 0, abs(amount)))
		update_damage_overlays()
	if(updating_health)
		updatehealth()
	updatestamina()
	if((combat_flags & COMBAT_FLAG_HARD_STAMCRIT) && amount > 20)
		incomingstammult = max(0.01, incomingstammult/(amount*0.05))
	return amount
