note
	description: "Finite data structures in which elements are kept sorted with respect to the linear traversal order."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_FINITE_SORTED [E -> COMPARABLE]

inherit
	M_SORTED [E]
		undefine
			has_min
		end

	M_FINITE_COMPARABLE_CONTAINER [E]
		undefine
			hold_count,
			exists
		end

	M_FINITE_LINEAR [E]

feature -- Acess
	max: E
			-- Maximum element
		do
			Result := last
		end

invariant
	last_is_max: not is_empty implies last = max
	item_not_greater_than_max: readable implies item <= max
end
