note
	description: "Data structures with capacity."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_BOUNDED [E]

inherit
	M_EXTENDIBLE [E]

	M_FINITE [E]

feature -- Access
	capacity: INTEGER
			-- Capacity
		deferred
		end

feature -- Status report
	has_space_for (i: INTEGER): BOOLEAN
			-- Can `i' new elements be added?
		do
			Result := capacity - count >= i
		end
end
