NotVanilla = SMODS.current_mod
function round(n)
  if n % 1 <= 0.4 then
    return math.floor(n)
  else
    return math.ceil(n)
  end
end
function roundExtense(n,x)
	if x ~= 0 then
		if n * 10^x % 1 <= 0.4 then
			return math.floor(n * 10^x) / 10^x
		else
			return math.ceil(n * 10^x) / 10^x
		end
	else
		if n * 10^x % 1 <= 0.4 then
			return round(math.floor(n * 10^x) / 10^x)
		else
			return round(math.ceil(n * 10^x) / 10^x)
		end
	end
end
Ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'}
rank = 13
ticketRate = 2


SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end
SMODS.Atlas{
	key = 'Jokers',
	path = 'Jokers.png',
	px = 71,
	py = 95
}
SMODS.Atlas{
	key = 'Tickets',
	path = 'Tickets.png',
	px = 71,
	py = 95
}
SMODS.Atlas{
	key = 'ModdedTickets',
	path = 'ModdedTickets.png',
	px = 71,
	py = 95
}
SMODS.Atlas{
	key = 'soulAtlas',
	path = 'soulAtlas.png',
	px = 71,
	py = 95
}
SMODS.Atlas{
	key = 'Boosters',
	path = 'Boosters.png',
	px = 71,
	py = 95
}
SMODS.Atlas{
	key = 'Vouchers',
	path = 'Vouchers.png',
	px = 71,
	py = 95
}

SMODS.Joker{
	key = 'palette',
	loc_txt = {
		name = 'Limited Palette',
		text = {
			'{X:mult,C:white}X1{} Mult,',
			'{X:mult,C:white}X0.25{} per hand size',
			'below starting hand size',
			'{C:inactive,S:0.75}(Currently {X:mult,C:white}X#2#{}){}'
			},
		unlock = {
			'Have more than 26 cards',
			'held in hand'
			},
	},
	atlas = 'Jokers',
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
	pos = {x = 0, y = 0},
	in_pool = function(self,wawa,wawa2)
		allow_duplicates = false
		return true
    end,
		config = { 
		extra = {
			hdiff = 6,
			xmult = 1}
		},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.hdiff,center.ability.extra.xmult}}
	end,
	calculate = function(self,card,context)
		if context.joker_main then 
		card.ability.extra.xmult = 1 + (0.25 * (G.GAME.starting_params.hand_size - G.hand.config.card_limit))
		return {xmult = card.ability.extra.xmult}
		end
	end,
	check_for_unlock = function(self,args)
		if #G.hand.cards >= 26 then
		return true
		end
	end,
}
SMODS.Joker{
	key = 'target',
	loc_txt = {
		name = 'The Target',
		text = {
			'Played {C:attention}#2#s{} give {C:money}$#1#{},',
			'rank changes at end of round'
			},
	},
	atlas = 'Jokers',
	rarity = 2,
	cost = 8,
	in_pool = function(self,wawa,wawa2)
		allow_duplicates = false
		return true
    end,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
	pos = {x = 1, y = 0},
	config = { 
		extra = {
			dollars = 4}
		},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.dollars, Ranks[rank]}}
	end,
	calculate = function(self,card,context)
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == rank + 1 then 
		return {
			dollars = card.ability.extra.dollars}
		end
		if context.end_of_round and not context.repitition and not context.blueprint then
		rank = pseudorandom("blahblahblah",1,13)
		end
	end,
}
SMODS.Joker{
	key = 'ticket',
	loc_txt = {
		name = 'Ticket Booth',
		text = {
			'Gives {C:dark_edition}#1#{} random {C:mult}ticket{} card',
			'when exiting the shop'
			}
	},
	atlas = 'Jokers',
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
	pos = {x = 2, y = 0},
	in_pool = function(self,wawa,wawa2)
		allow_duplicates = false
		return true
    end,
		config = { 
		extra = {
			tickets = 1}
		},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.tickets}}
	end,
	calculate = function(self,card,context)
		if context.ending_shop then 
            play_sound('timpani')
            SMODS.add_card({ set = 'Tickets' })
            card:juice_up(0.3, 0.5)
			message = '+1 Ticket'
			colour = G.C.MULT
		end
	end,
}






-- consumables area
SMODS.ConsumableType {
    key = 'Tickets',
	loc_txt = {
		name = 'Tickets',
		collection = 'Ticket Cards',
	},
    default = 'c_Tickets_spectral1',
    primary_colour = G.C.SECONDARY_SET.Spectral,
    secondary_colour = G.C.SECONDARY_SET.Spectral,
    collection_rows = { 5, 6 },
    shop_rate = 2
}
NotVanilla.Tickets = SMODS.Consumable:extend {
    set = "Tickets",
    use = function(self, card, area, copier)
		if G.GAME.used_vouchers['v_nv_ticketvouch2'] then
			SMODS.calculate_effect({dollars = math.ceil(card.cost / 2)}, card)
		end
	end
}
NotVanilla.Tickets = SMODS.Consumable:extend {
	set = "Tickets",
	loc_txt = {
		undiscovered = {
			name = "Not Discovered",
            text = {
                "Purchase or use",
                "this card in an",
                "unseeded run to",
                "learn what it does",
            },
		},
	},
}

NotVanilla.Tickets{
	key = 'spectral1',
	loc_txt = {
		name = 'Spectral Ticket I',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:spectral}spectral{} card'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 0, y = 0},
	cost = 4,
	config = {
		extra = {
			spectral = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.spectral}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.spectral, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Spectral' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'spectral2',
	loc_txt = {
		name = 'Spectral Ticket II',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:spectral}spectral{} cards'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 1, y = 0},
	cost = 4,
	config = {
		extra = {
			spectral = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.spectral}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.spectral, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Spectral' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'tarot1',
	loc_txt = {
		name = 'Tarot Ticket I',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:tarot}tarot{} card'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 2, y = 0},
	cost = 4,
	config = {
		extra = {
			tarot = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.tarot}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.tarot, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Tarot' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'tarot2',
	loc_txt = {
		name = 'Tarot Ticket II',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:tarot}tarot{} cards'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 3, y = 0},
	cost = 4,
	config = {
		extra = {
			tarot = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.tarot}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.tarot, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Tarot' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'fate',
	loc_txt = {
		name = 'Ticket of Fate',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:tarot}tarot{} card',
			'and {C:dark_edition}#2#{} random {C:spectral}spectral{} card'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 4, y = 0},
	cost = 4,
	config = {
		extra = {
			tarot = 1,
			spectral = 1,
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.tarot,center.ability.extra.spectral}}
	end,
	use = function(self, card, area, copier)
		local switch = 0
		for i = 1, math.min(card.ability.extra.tarot + card.ability.extra.spectral, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
						if switch == 0 then
							play_sound('timpani')
							SMODS.add_card({ set = 'Tarot' })
							card:juice_up(0.3, 0.5)
							switch = 1
						else
							play_sound('timpani')
							SMODS.add_card({ set = 'Spectral' })
							card:juice_up(0.3, 0.5)
							switch = 0
						end
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'recursion',
	loc_txt = {
		name = 'Recursive Ticket',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:mult}ticket{} cards'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 5, y = 0},
	cost = 4,
	config = {
		extra = {
			tickets = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.tickets}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.tickets, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Tickets' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'planet1',
	loc_txt = {
		name = 'Planet Ticket I',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:planet}planet{} card'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 6, y = 0},
	cost = 4,
	config = {
		extra = {
			planets = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.planets}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Planet' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'planet2',
	loc_txt = {
		name = 'Planet Ticket II',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:planet}planet{} cards'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 7, y = 0},
	cost = 4,
	config = {
		extra = {
			planets = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.planets}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Planet' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'joker1',
	loc_txt = {
		name = 'Buffoon Ticket I',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:attention}joker{}'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 8, y = 0},
	cost = 4,
	config = {
		extra = {
			jokers = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.jokers}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.jokers, G.jokers.config.card_limit - #G.jokers.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.jokers.config.card_limit > #G.jokers.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Joker' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'joker2',
	loc_txt = {
		name = 'Buffoon Ticket II',
		text = {
			'Generates {C:dark_edition}#1#{} random {C:attention}jokers{}'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 9, y = 0},
	cost = 4,
	config = {
		extra = {
			jokers = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.jokers}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.jokers, G.jokers.config.card_limit - #G.jokers.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.jokers.config.card_limit > #G.jokers.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Joker' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'nebula',
	loc_txt = {
		name = 'Nebula Ticket',
		text = {
			'Generates {C:dark_edition}#1#{} {C:planet}planet{} cards of',
			'the most played hand'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 0, y = 1},
	cost = 6,
	config = {
		extra = {
			planets = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.planets}}
	end,
	use = function(self, card, area, copier)
		local _pokerHand = 'High Card'
		local playMoreThan = (G.GAME.hands[_pokerHand].played or -1)
		for k,v in pairs(G.GAME.hands) do
			if v.played > playMoreThan and v.visible then
			_pokerHand = k
			playMoreThan = v.played
			end
		end
		local _planet
		for _, center in pairs(G.P_CENTER_POOLS.Planet) do
			if center.config.hand_type == _pokerHand then
			_planet = center.key
			end
		end
		for i = 1, math.min(card.ability.extra.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ key = _planet })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}
NotVanilla.Tickets{
	key = 'tag1',
	loc_txt = {
		name = 'Speeding Ticket',
		text = {
			'Generates {C:dark_edition}2{} random {C:attention}tags{}'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 1, y = 1},
	cost = 5,
	config = {
		extra = {
			tags = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.tags}}
	end,
	use = function(self, card, area, copier)
		local switch = 0
		local tag_pool = get_current_pool('Tag')
        local selected_tag = pseudorandom_element(tag_pool, pseudoseed('tag_generator'))
        local it = 1
        while selected_tag == 'UNAVAILABLE' do
			it = it + 1
			selected_tag = pseudorandom_element(tag_pool, pseudoseed('tag_generator_resample'..it))
        end
        local selected_tag2 = pseudorandom_element(tag_pool, pseudoseed('tag_generator'))
        local it2 = 1
        while selected_tag2 == 'UNAVAILABLE' do
			it2 = it2 + 1
			selected_tag2 = pseudorandom_element(tag_pool, pseudoseed('tag_generator_resample'..it))
        end
		for i = 1, math.min(card.ability.extra.tags, 3) do
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
					if switch == 0 then
                        play_sound('timpani')
                        add_tag(Tag(selected_tag, false, 'Small'))
                        card:juice_up(0.3, 0.5)
						switch = 1
					else
						play_sound('timpani')
                        add_tag(Tag(selected_tag2, false, 'Small'))
                        card:juice_up(0.3, 0.5)
						switch = 0
					end
                    return true
                end
            }))
        end
        delay(0.6)
	end,
    can_use = function(self, card)
        return true
    end
}
NotVanilla.Tickets{
	key = 'voucher',
	loc_txt = {
		name = 'Voucher Ticket',
		text = {
			'Redeems {C:dark_edition}#1#{} random {C:diamonds}voucher{}'
			},
	},
	atlas = 'Tickets',
	set = 'Tickets',
	pos = {x = 2, y = 1},
	cost = 7,
	config = {
		extra = {
			vouchers = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.vouchers}}
	end,
    use = function()
        local voucher_key = get_next_voucher_key(true)
        local new_card = create_card("Voucher", G.play, nil, nil, nil, nil, voucher_key, nil)
			new_card:start_materialize()
			new_card.cost = 0
			new_card.from_tag = true
			new_card:redeem()
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					new_card:start_dissolve()
					return true
				end
			}))
    end,
    can_use = function(self, card)
        return true
    end
}


-- modded tickets area
if next(SMODS.find_mod("Cryptid")) then
	NotVanilla.Tickets{
		key = 'code1',
		loc_txt = {
			name = 'Code Ticket I',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:code}code{} card'
			},
		},
		atlas = 'Tickets',
		set = 'ModdedTickets',
		pos = {x = 0, y = 0},
		cost = 4,
		config = {
			extra = {
				code = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.code}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.code, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Code' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'code2',
		loc_txt = {
			name = 'Code Ticket II',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:code}code{} cards'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 1, y = 0},
		cost = 4,
		config = {
			extra = {
				code = 2
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.code}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.code, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Code' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'code3',
		loc_txt = {
			name = 'Machine Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:dark_edition}glitched{} {C:code}code{} card'
			},
		},
		atlas = 'Tickets',
		set = 'ModdedTickets',
		pos = {x = 2, y = 0},
		cost = 6,
		config = {
			extra = {
				code = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.code}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.code, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Code', edition = 'e_cry_glitched' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
end
if next(SMODS.find_mod("RevosVault")) then
	NotVanilla.Tickets{
		key = 'revo1',
		loc_txt = {
			name = 'Contract Ticket',
			text = {
				'Generates a random {C:inactive}contract{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 3, y = 0},
		cost = 4,
		config = {
			extra = {
				consumable = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'EnchancedDocuments' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'revo2',
		loc_txt = {
			name = 'Scrappy Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:scrap}scrap{} card'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 4, y = 0},
		cost = 4,
		config = {
			extra = {
				consumable = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'scrap' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'revo3',
		loc_txt = {
			name = 'Scammy Ticket',
			text = {
				'Generates {C:dark_edition}1{} random {C:scrap}scrap{} card',
				'and {C:dark_edition}1{} random {C:inactive}contract{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 5, y = 0},
		cost = 4,
		config = {
			extra = {
				consumable = 2
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			local switch = 0
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
            		trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
								play_sound('timpani')
								SMODS.add_card({ set = 'EnchancedDocuments' })
								card:juice_up(0.3, 0.5)
								play_sound('timpani')
								SMODS.add_card({ set = 'scrap' })
								card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
        		}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
end
if next(SMODS.find_mod("GrabBag")) then
	NotVanilla.Tickets{
		key = 'gb1',
		loc_txt = {
			name = 'Ticket of Visions',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:dark_edition}ephemerals{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 6, y = 0},
		cost = 6,
		config = {
			extra = {
				consumable = 2
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Ephemeral' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'gb2',
		loc_txt = {
			name = 'Fading Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:dark_edition}temporary{} {C:mult}tickets{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 7, y = 0},
		cost = 6,
		config = {
			extra = {
				consumable = 2
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Tickets', edition = 'e_gb_temporary' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
end
if next(SMODS.find_mod("LuckyRabbit")) then
	NotVanilla.Tickets{
		key = 'lucky1',
		loc_txt = {
			name = 'Confetti Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:silly}silly{} cards'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 8, y = 0},
		cost = 5,
		config = {
			extra = {
				consumable = 2
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Silly' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'lucky2',
		loc_txt = {
			name = 'Deal',
			text = {
				'Generates a {C:dark_edition}crisis{}',
				'Go {C:money}$100{} in {C:mult}debt{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 9, y = 0},
		cost = 1,
		config = {
			extra = {
				consumable = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ key = 'c_fmod_crisis' })
							G.GAME.dollars = -100
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit and G.GAME.round_resets.ante > 1
    	end
	}
end
if next(SMODS.find_mod("Maximus")) then
	NotVanilla.Tickets{
		key = 'mxms1',
		loc_txt = {
			name = 'Cassiopeia Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:horoscope}horoscope{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 0, y = 1},
		cost = 5,
		config = {
			extra = {
				consumable = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.mxms_horoscope.config.card_limit - #G.mxms_horoscope.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Horoscope' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.mxms_horoscope and #G.mxms_horoscope.cards < G.mxms_horoscope.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'mxms2',
		loc_txt = {
			name = 'Cetus Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:dark_edition}negative{} {C:horoscope}horoscope{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 1, y = 1},
		cost = 5,
		config = {
			extra = {
				consumable = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.mxms_horoscope.config.card_limit - #G.mxms_horoscope.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Horoscope', edition = 'e_negative' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return true
    	end
	}
end
if next(SMODS.find_mod("sdm0sstuff")) then
	NotVanilla.Tickets{
		key = 'sdm1',
		loc_txt = {
			name = 'Bakery Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:dark_edition}negative{} {C:bakery}bakery{} card'
			},
		},
		atlas = 'soulAtlas',
		set = 'Tickets',
		pos = {x = 0, y = 0},
		soul_pos = {x = 0, y = 1},
		cost = 5,
		config = {
			extra = {
				consumable = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'Bakery', edition = 'e_negative' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'sdm2',
		loc_txt = {
			name = 'Overcooked Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:bakery}bakery{} card',
				'with abilities doubled'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 2, y = 1},
		cost = 4,
		config = {
			extra = {
				consumable = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
							local _funnykey = SMODS.add_card({ set = 'Bakery' })
                        	play_sound('timpani')
							_funnykey.ability.extra.amount = 2 * _funnykey.ability.extra.amount
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
end
if next(SMODS.find_mod("JoJoMod")) then
	NotVanilla.Tickets{
		key = 'jojo1',
		loc_txt = {
			name = 'Stand Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:dark_edition}stand{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 3, y = 1},
		cost = 6,
		config = {
			extra = {
				jokers = 1
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.jokers}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.jokers, G.jokers.config.card_limit - #G.jokers.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.jokers.config.card_limit > #G.jokers.cards then
                        	play_sound('timpani')
							local stands = {}
							for k, v in pairs(G.P_CENTERS) do
   								if v.set == "Joker" and v.mod and v.mod.id == "JoJoMod" and string.find(k,'stand_') ~= nil then
        							table.insert(stands, v.key)
    							end
							end
							local joker = pseudorandom_element(stands, "seedblahblahblah")
							SMODS.add_card({key = joker, set = "Joker"})
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    	end
	}
	NotVanilla.Tickets{
		key = 'jojo2',
		loc_txt = {
			name = 'Junk Ticket',
			text = {
				'Generates {C:dark_edition}#1#{} random {C:attention}scraps{}'
			},
		},
		atlas = 'ModdedTickets',
		set = 'Tickets',
		pos = {x = 4, y = 1},
		cost = 5,
		config = {
			extra = {
				consumable = 2
			}
		},
		loc_vars = function(self,info_queue,center)
			return{vars = {center.ability.extra.consumable}}
		end,
		use = function(self, card, area, copier)
			for i = 1, math.min(card.ability.extra.consumable, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({
                	trigger = 'after',
                	delay = 0.4,
                	func = function()
                    	if G.consumeables.config.card_limit > #G.consumeables.cards then
                        	play_sound('timpani')
                        	SMODS.add_card({ set = 'jojo_Scraps' })
                        	card:juice_up(0.3, 0.5)
                    	end
                    	return true
                	end
            	}))
        	end
        	delay(0.6)
		end,
    	can_use = function(self, card)
        	return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    	end
	}
end


-- boosters area
SMODS.Booster{
	key = 'ticket1',
	atlas = 'Boosters',
	pos = {x = 0, y =0},
	loc_txt = {
		name = 'Ticket Pack',
		group_name = 'Ticket Pack',
		text = {
			'Choose {C:attention}1{} out of',
			'{C:attention}2{} tickets'
			}
	},
	cost = 4,
	weight = 1,
	config = {
		choose = 1,
		extra = 2
	},
	kind = 'ticketboost',
	draw_hand = false,
	group_key = 'Tickets',
	create_card = function(self,card)
		return create_card("Tickets", G.pack_cards, nil, nil, true, true, nil, "NotVanilla_tickets")
	end,
}
SMODS.Booster{
	key = 'ticket2',
	atlas = 'Boosters',
	pos = {x = 1, y =0},
	loc_txt = {
		name = 'Ticket Pack',
		text = {
			'Choose {C:attention}1{} out of',
			'{C:attention}2{} tickets'
		},
		group_name = 'Ticket Pack'
	},
	cost = 4,
	weight = 1,
	config = {
		choose = 1,
		extra = 2
	},
	kind = 'ticketboost',
	draw_hand = false,
	group_key = 'Tickets',
	create_card = function(self,card)
		return create_card("Tickets", G.pack_cards, nil, nil, true, true, nil, "NotVanilla_tickets")
	end,
}
SMODS.Booster{
	key = 'ticket3',
	atlas = 'Boosters',
	pos = {x = 2, y =0},
	loc_txt = {
		name = 'Jumbo Ticket Pack',
		text = {
			'Choose {C:attention}1{} out of',
			'{C:attention}4{} tickets'
		},
		group_name = 'Ticket Pack'
	},
	cost = 4,
	weight = 1,
	kind = 'ticketboost',
	draw_hand = false,
	group_key = 'Tickets',
	config = {
		choose = 1,
		extra = 4
	},
	create_card = function(self,card)
		return create_card("Tickets", G.pack_cards, nil, nil, true, true, nil, "NotVanilla_tickets")
	end,
}
SMODS.Booster{
	key = 'ticket4',
	atlas = 'Boosters',
	pos = {x = 3, y =0},
	loc_txt = {
		name = 'Mega Ticket Pack',
		text = {
			'Choose {C:attention}2{} out of',
			'{C:attention}4{} tickets'
		},
		group_name = 'Ticket Pack'
	},
	cost = 8,
	weight = 1,
	kind = 'ticketboost',
	draw_hand = false,
	group_key = 'Tickets',
	config = {
		choose = 2,
		extra = 4
	},
	create_card = function(self,card)
		return create_card("Tickets", G.pack_cards, nil, nil, true, true, nil, "NotVanilla_tickets")
	end,
}

-- vouchers area
SMODS.Voucher{
	key = 'ticketvouch1',
	loc_txt = {
		name = 'Mass Production',
		text = {
			'Tickets are {C:attention}#1#x{} more likely',
			'to appear in shops'
		}
	},
	atlas = 'Vouchers',
	pos = {x = 0, y = 0},
	config = {extra = {rate = 2}},
	loc_vars = function(self,info_queue,center)
		return{vars = {center.ability.extra.rate}}
	end,
	redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.Tickets_rate = card.ability.extra.rate
                return true
            end
        }))
	end,
}
SMODS.Voucher{
	key = 'ticketvouch2',
	loc_txt = {
		name = 'Prized Tickets',
		text = {
			'Tickets give half of their {C:money}cost{}',
			'back when used'
		}
	},
	atlas = 'Vouchers',
	pos = {x = 1, y = 0},
	requires = {'v_nv_ticketvouch1'}
}