note
	description: "Iterators over sequences that allow only traversal, search and replacement."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, index

class
	V_SEQUENCE_ITERATOR [G]

inherit
	V_INDEX_ITERATOR [G]
		redefine
			copy
		end

create {V_CONTAINER}
	make

feature {NONE} -- Initialization
	make (t: V_SEQUENCE [G]; i: INTEGER)
			-- Create an iterator at position `i' in `t'.
		require
			t_exists: t /= Void
			i_valid: 0 <= i and i <= t.count + 1
		do
			target := t
			index := i
		ensure
			target_effect: target = t
			index_effect: index = i
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and `index' as in `other'.
		do
			target := other.target
			index := other.index
		ensure then
			target_effect: target = other.target
			index_effect: index = other.index
			other_target_effect: other.target = old other.target
			other_index_effect: other.index = old other.index
		end

feature -- Access
	target: V_SEQUENCE [G]
			-- Target container.
end
