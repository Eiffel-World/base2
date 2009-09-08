note
	description: "Sequences with references to cells as cursors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_CELLED_SEQUENCE [E]

inherit
	M_SEQUENCE [E]
		undefine
			readable,
			item,
			start,
			forth
		end

	M_CELLED [E]

feature -- Access
	i_th alias "[]" (i: INTEGER): E
			-- Element associated with `i'
		do
			save_cursor
			go_i_th (i)
			Result := item
			restore_cursor
		end

	index: INTEGER
			-- Index of current position
		do
			save_cursor
			from
				start
				Result := 1
			until
				cursors.item = active
			loop
				forth
				Result := Result + 1
			end
			restore_cursor
		end

feature -- Cursor movement
	go_i_th (i: INTEGER)
			-- Go to position `i'
		local
			j: INTEGER
		do
			if not has_index (i) then
				go_off
			else
				from
					start
					j := 1
				until
					i = j
				loop
					forth
					j := j + 1
				end
			end
		end

	go_off
			-- Go to a position that doesn't correspond to any element
		do
			active := Void
		end
end
