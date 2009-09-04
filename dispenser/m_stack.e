note
	description: "Data structures with first-in first-out policy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_STACK [E]

inherit
	M_DISPENSER [E]
		redefine
			extend
		end

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		deferred
		ensure then
			added_on_top: item = v
		end

end
