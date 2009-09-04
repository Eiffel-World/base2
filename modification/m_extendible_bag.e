note
	description: "Finite data structures that can be extended with individual occurrences of elements with a given value."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_EXTENDIBLE_BAG [E]

inherit
	M_IMPLICIT_ENTRY_POINT [E]
		redefine
			extend
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
end
