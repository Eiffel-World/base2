note
	description: "Linear structures with references to cells as cursors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_CELLED_LINEAR [G]

inherit
	M_LINEAR [G]
		undefine
			readable,
			item
		redefine
			go_i_th
		end

	M_CELLED [G]

feature -- Access
	index: INTEGER
			-- Index of current position
		do
			if not off then
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
