note
	description: "Data structures that can be pruned of elements with given value."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_PRUNABLE_BY_VALUE [E]

inherit
	M_PRUNABLE [E]

feature -- Element change
	prune_all (v: E)
			-- Remove all occurences of `v'
		deferred
		ensure
			pruned_all: not has (v)
		end
end
