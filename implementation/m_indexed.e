note
	description: "Structures with integer indexes as cursors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_INDEXED [E]

inherit
	M_CURSORED [E]

feature -- Access
	index: INTEGER
			-- Index of current position

feature -- Cursor saving
	cursor_stored: BOOLEAN
			-- Is any previous cursor position stored?
		do
			Result := not cursors.is_empty
		end

	save_cursor
			-- Save current cursor position
		do
			cursors.extend (index)
		end

	restore_cursor
			-- Restore previous cursor position
		do
			index := cursors.item
			cursors.remove
		end

feature -- Implementation
	cursors: M_LINKED_STACK [INTEGER]
		do
			if cursors_impl = Void then
				create cursors_impl
			end
			Result := cursors_impl
		end

	cursors_impl: like cursors
end
