note
	description: "Bags that can be extended with and pruned of individual elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_SPARSE_BAG [E]

inherit
	M_EXTENDIBLE_BY_VALUE [E]
		redefine
			extend
		end

	M_PRUNABLE_BY_VALUE [E]
		redefine
			prune_all
		end

	M_FINITE [E]

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		deferred
		ensure then
			one_more_element: count = old count + 1
			one_more_occurrence: occurrences (v) = old occurrences (v) + 1
		end

	prune (v: E)
			-- Prune one occurence of `v' if there is one
		deferred
		ensure
			one_less_element_if_has: old has (v) implies count = old count - 1
			pruned_one_if_has: old has (v) implies occurrences (v) = old occurrences (v) - 1
			same_count_if_not_has: not old has (v) implies count = old count
		end

	prune_all (v: E)
			-- Remove all occurences of `v'
		deferred
		ensure then
			less_elements: count = old (count - occurrences (v))
		end		
end
