note
	description: "Data structures in which elements are kept sorted with respect to the linear traversal order."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_SORTED [E -> COMPARABLE]

inherit
	M_COMPARABLE_CONTAINER [E]

	M_LINEAR [E]

feature -- Acess
	min: E
			-- Minimum element
		do
			Result := first
		end

feature -- Status report
	has_min: BOOLEAN
			-- Is there a minimum element?
		do
			Result := not is_empty
		end

invariant
	non_empty_has_min: has_min = not is_empty
	first_is_min: not is_empty implies first = min
	item_not_less_than_min: readable implies item >= min
end
