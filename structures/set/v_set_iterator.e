note
	description: "Iterators over sets, allowing efficient search."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, sequence, index

deferred class
	V_SET_ITERATOR [G]

inherit
	V_INPUT_ITERATOR [G]

feature -- Access
	target: V_SET [G]
			-- Set to iterate over.
		deferred
		end

feature -- Cursor movement
	search (v: G)
			-- Move to an element equivalent to `v'.
			-- If `v' does not appear, go off.
			-- (Use `target.equivalence'.)
		deferred
		ensure
			index_effect_found: target.has_equivalent (v) implies target.relation [sequence [index], v]
			index_effect_not_found: not target.has_equivalent (v) implies index = sequence.count + 1
		end
end
