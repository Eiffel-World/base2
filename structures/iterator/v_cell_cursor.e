note
	description: "Cursors storing a position in a linked container."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: item, off

deferred class
	V_CELL_CURSOR [G]

feature -- Access
	item: G
			-- Item at current position.
		do
			Result := active.item
		end

feature -- Status report
	off: BOOLEAN
			-- Is current position off scope?
		do
			Result := active = Void
		end

feature -- Replacement
	put (v: G)
			-- Replace item at current position with `v'.
		require
			not_off: not off
		do
			active.put (v)
		ensure
			item_effect: item = v
		end

feature {V_CELL_CURSOR} -- Implementation
	active: V_CELL [G]
			-- Cell at current position.
		deferred
		end
end
