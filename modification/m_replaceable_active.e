note
	description: "Data structures with the notion of current element, in which elements can be replaced by other elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_REPLACEABLE_ACTIVE [E]

inherit
	M_REPLACEABLE [E]

	M_ACTIVE [E]

feature -- Status report
	writable: BOOLEAN
			-- Can current item be replaced?
		deferred
		end

feature -- Replacement
	replace (v: E)
			-- Replace current element with `v'
		require
			writable
		deferred
		ensure
			item_replaced: item = v
		end

invariant
	readable_if_writable: writable implies readable
end
