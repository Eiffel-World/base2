note
	description: "Structures with references to cells as cursors."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_CELLED [E]

inherit
	M_CURSORED [E]

feature -- Access
	item: E
			-- Current element
		do
			Result := active.item
		end

feature -- Status report
	readable: BOOLEAN
			-- Is current element accessable?
		do
			Result := (active /= Void)
		end

feature -- Cursor saving
	cursor_stored: BOOLEAN
			-- Is any previous cursor position stored?
		do
			Result := not cursors.is_empty
		end

	save_cursor
			-- Save current cursor position
		do
			cursors.extend (active)
		end

	restore_cursor
			-- Restore previous cursor position
		do
			active := cursors.item
			cursors.remove
		end

feature {NONE} -- Implementation
	active: M_CELL [E]

	cursors: M_LINKED_STACK [like active]
		do
			if cursors_impl = Void then
				create cursors_impl
			end
			Result := cursors_impl
		end

	cursors_impl: like cursors
end
