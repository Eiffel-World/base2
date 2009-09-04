note
	description: "Data structures that can be pruned of elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_PRUNABLE [E]

inherit
	M_CONTAINER [E]

feature -- Element change
	wipe_out
			-- Prune of all elements
		deferred
		ensure
			is_empty: is_empty
		end
end
