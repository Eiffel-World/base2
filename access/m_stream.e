note
	description: "Data structures where a new element is made available with every step forward."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_STREAM [E]

inherit
	M_ACTIVE [E]
	
feature -- Cursor movement
	forth
			-- Move current position to the next element
		require
			readable: readable
		deferred
		end

	search (v: like item)
			-- Move to first position (at or after current position) where `item' and `v' are equal.
		require
			not_off: readable
		do
			from
			until
				not readable or else v = item
			loop
				forth
			end
		ensure
			item_found: readable implies v = item
		end
		
end
