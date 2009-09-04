note
	description: "Data structures that can be pruned of individual occurences of elements with a given value."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_PRUNABLE_BAG [E]

inherit
	M_PRUNABLE_BY_VALUE [E]

	M_FINITE [E]

feature -- Element change
	prune (v: E)
			-- Prune one occurence of `v' if there is one
		deferred
		ensure
			one_less_element_if_has: old has (v) implies count = old count - 1
			pruned_one_if_has: old has (v) implies occurrences (v) = old occurrences (v) - 1
			same_count_if_not_has: not old has (v) implies count = old count
		end
end
