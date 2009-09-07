note
	description: "Finite data structures in which elements are kept sorted with respect to the linear traversal order."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_SORTED [E -> COMPARABLE]

inherit
	M_FINITE_COMPARABLE_CONTAINER [E]
		undefine
			hold_count,
			exists
		end

	M_SEQUENCE [E]

feature -- Acess
	min: E
			-- Minimum element
		do
			Result := first
		end

	max: E
			-- Maximum element
		do
			Result := last
		end

invariant
	first_is_min: not is_empty implies first = min
	last_is_max: not is_empty implies last = max
	item_not_less_than_min: readable implies item >= min	
	item_not_greater_than_max: readable implies item <= max
end
