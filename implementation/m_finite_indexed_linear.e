note
	description: "Finite linear structures with integer indexes as cursors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_FINITE_INDEXED_LINEAR [E]

inherit
	M_FINITE_LINEAR [E]
		undefine
			back,
			go_i_th
		end

	M_INDEXED_LINEAR [E]

feature -- Cursor movement
	finish
			-- Move current position to the last element
		do
			index := count
		end
end
