note
	description: "Iterators over sets, allowing efficient search."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, sequence, index

deferred class
	V_SET_ITERATOR [G]

inherit
	V_ITERATOR [G]

feature -- Access
	target: V_SET [G]
			-- Set to iterate over.
		deferred
		end

feature -- Cursor movement
	search (v: G)
			-- Move to an element equivalent to `v'.
			-- If `v' does not appear, go after.
			-- (Use `target.equivalence'.)
		deferred
		ensure
			index_effect_found: target.has (v) implies target.equivalent (sequence [index], v)
			index_effect_not_found: not target.has (v) implies index = sequence.count + 1
		end

feature -- Removal
	remove
			-- Remove element at current position. Move to the next position.
		require
			not_off: not off
		deferred
		ensure
			target_set_effect: target.set |=| old (target.set / sequence [index])
			sequence_effect: sequence |=| old (sequence.front (index - 1) + sequence.tail (index + 1))
			index_effect: index = old index
		end
end
