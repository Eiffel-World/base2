note
	description: "Finite linear data structures that can be extended at back."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_SEQUENCE [E]

inherit
	M_FINITE_LINEAR [E]

	M_EXTENDIBLE_BAG [E]
		undefine
			hold_count,
			exists
		redefine
			extend
		end

feature -- Element change
	extend (v: E)
			-- Add `v' at back
		deferred
		ensure then
			new_is_last: last = v
		end

	append (other: M_FINITE_LINEAR [E])
			-- Append `other'
		require
			enough_space: has_space_for (other.count)
			not_void: other /= Void
			not_current: other /= Current
		do
			other.save_cursor
			from
				other.start
			until
				other.off
			loop
				extend (other.item)
				other.forth
			end
			other.restore_cursor
		ensure
			more_elements: count = old count + other.count
		end

end
