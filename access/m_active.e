note
	description: "Data structures with the notion of current element."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_ACTIVE [E]

inherit
	M_CONTAINER [E]

feature -- Access
	item: E
			-- Current element
		require
			readable: readable
		deferred
		end

feature -- Status report
	readable: BOOLEAN
			-- Is current element accessable?
		deferred
		end

invariant
	empty_not_readable: is_empty implies not readable
	has_item: readable implies has (item)
end
