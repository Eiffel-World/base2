note
	description: "Cursors storing a position in a linked container."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: active

deferred class
	V_CELL_CURSOR [G]

feature -- Access
	active: V_CELL [G]
			-- Cell at current position

	item: G
			-- Item at current position
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
			-- Replace item at current position with `v'
		do
			active.put (v)
		ensure
			active_item_effect: active.item = v
		end

invariant
	item_definition: active /= Void implies item = active.item
	off_definition: off = (active = Void)
end
