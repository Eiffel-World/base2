note
	description: "Finite extendible data structures, where a single element can be accessed and removed at a time."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_DISPENSER [E]

inherit
	M_FINITE [E]

	M_EXTENDIBLE_BY_VALUE [E]
		redefine
			extend
		end

	M_PRUNABLE_ACTIVE [E]
		redefine
			remove
		end

feature -- Status report
	readable: BOOLEAN
			-- Is current element accessable?
		do
			Result := not is_empty
		end

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		deferred
		ensure then
			one_more_element: count = old count + 1
			one_more_occurrence: occurrences (v) = old occurrences (v) + 1
		end

	remove
			-- Remove current element
		deferred
		ensure then
			one_less_element: count = old count - 1
			one_less_occurrence: occurrences (old item) = old occurrences (item) - 1
		end

invariant
	readable_in_non_empty: not is_empty implies readable
end
