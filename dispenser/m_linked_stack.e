note
	description: "Summary description for {M_LINKED_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_LINKED_STACK [E]

inherit
	M_STACK [E]
		undefine
			hold_count,
			exists
		end

inherit {NONE}
	M_LINKED_LIST [E]

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		do
			extend_back (v)
			finish
		end
end
