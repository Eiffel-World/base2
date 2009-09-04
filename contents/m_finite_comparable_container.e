note
	description: "Finite data structures with comparable elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_FINITE_COMPARABLE_CONTAINER [E -> COMPARABLE]

inherit
	M_COMPARABLE_CONTAINER [E]

	M_FINITE [E]

feature -- Status report
	has_min: BOOLEAN
			-- Is there a minimum element?
		do
			Result := not is_empty
		end

	has_max: BOOLEAN
			-- Is there a maximum element?
		do
			Result := not is_empty
		end

invariant
	non_empty_has_min: has_min = not is_empty
	non_empty_has_max: has_max = not is_empty
end
