note
	description: "Finite sets that can be extended with and pruned of individual elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_SPARSE_SET [E]

inherit
	M_FINITE_SET [E]

	M_IMPLICIT_ENTRY_POINT [E]
		redefine
			extend
		end

	M_PRUNABLE_BY_VALUE [E]
		rename
			prune_all as prune
		redefine
			prune
		end

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		deferred
		ensure then
			one_more_element_if_not_has: not old has (v) implies count = old count + 1
			same_count_if_has: old has (v) implies count = old count
		end

	prune (v: E)
			-- Remove `v'
		deferred
		ensure then
			one_less_element_if_had: old has (v) implies count = old count - 1
			same_count_if_not_had: not old has (v) implies count = old count
		end
end
