note
	description: "Data structures with internal cursor, which can be saved and restored."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_CURSORED [E]

inherit
	M_ACTIVE [E]

feature -- Status report
	off: BOOLEAN
			-- Does the current position not correspond to any element?
		do
			Result := not readable
		end

feature -- Cursor saving
	cursor_stored: BOOLEAN
			-- Is any previous cursor position stored?
		deferred
		end

	save_cursor
			-- Save current cursor position
		deferred
		ensure
			cursor_stored: cursor_stored
		end

	restore_cursor
			-- Restore previous cursor position
		require
			cursor_stored: cursor_stored
		deferred
		end

invariant
	off_is_not_readable: off = not readable
end
