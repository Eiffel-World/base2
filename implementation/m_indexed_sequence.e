note
	description: "Sequences with integer indexes as cursors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_INDEXED_SEQUENCE [E]

inherit
	M_SEQUENCE [E]

	M_INDEXED [E]

feature -- Cursor movement
	go_off
			-- Go to a position that doesn't correspond to any element
		do
			index := 0
		end

	go_i_th (i: INTEGER)
			-- Go to position `i'
		do
			index := i
		end
end
