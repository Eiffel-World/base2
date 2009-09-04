note
	description: "Data structures with comparable elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_COMPARABLE_CONTAINER [E -> COMPARABLE]

inherit
	M_CONTAINER [E]

feature -- Acess
	min: E
			-- Minimum element
		require
			has_min: has_min
		deferred
		end

	max: E
			-- Maximum element
		require
			has_max: has_max
		deferred
		end

feature -- Status report
	has_min: BOOLEAN
			-- Is there a minimum element?
		deferred
		end

	has_max: BOOLEAN
			-- Is there a maximum element?
		deferred
		end

invariant
	no_min_max_in_empty: is_empty implies (not has_min and not has_max)
	min_not_greater_than_max: (has_min and has_max) implies min <= max
end
