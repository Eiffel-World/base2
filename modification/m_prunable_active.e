note
	description: "Data structure that can be pruned of their current element."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_PRUNABLE_ACTIVE [E]

inherit
	M_SPARSE_PRUNABLE [E]

	M_ACTIVE [E]

feature -- Element change
	remove
			-- Remove current element
		require
			current_element_exists: readable
		deferred
		end

end

