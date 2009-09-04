note
	description: "Cells linked to another cell."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_LINKABLE [E]

inherit
	M_CELL [E]

create
	set_item

feature -- Access
	right: M_LINKABLE [E]
			-- Cell to the right

feature -- Replacement
	set_right (r: M_LINKABLE [E])
			-- Set `right' to `r'
		do
			right := r
		ensure
			right_set: right = r
		end
end
