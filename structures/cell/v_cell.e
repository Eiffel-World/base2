note
	description: "Cells containing an item."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: item

class
	V_CELL [G]

create
	put

feature -- Access
	item: G
			-- Content of the cell.

feature -- Replacement
	put (v: G)
			-- Replace `item' with `v'
		do
			item := v
		ensure
			item_effect: item = v
		end
end
