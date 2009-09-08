note
	description: "Stacks implemented through linekd lists."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_LINKED_STACK [E]

inherit
	M_STACK [E]
		undefine
			readable,
			hold_count,
			exists
		end

inherit {NONE}
	M_LINKED_LIST [E]
		export {NONE}
			all
		redefine
			remove
		end

feature -- Element change
	extend (v: E)
			-- Put `v' on top
		do
			extend_back (v)
			finish
		end

	remove
			-- Remove top
		do
			Precursor
			finish
		end

invariant
	always_last: not is_empty implies is_last
end
