note
	description: "Sequences with integer indexes as cursors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_INDEXED_SEQUENCE [E]

inherit
	M_SEQUENCE [E]
		undefine
			back,
			go_i_th
		end

	M_INDEXED [E]

feature -- Cursor movement
	start
			-- Move current position to the first element
		do
			index := 1
		end
		
	finish
			-- Move current position to the last element
		do
			index := count
		end		
		
	forth
			-- Move current position to the next element
		do
			index := index + 1
		end

	back
			-- Move current position to the previous element
		do
			index := index - 1
		end

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
