note
	description: "Iterators to read and write from/to a container in linear order."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, sequence, index

deferred class
	V_ITERATOR [G]

inherit
	V_INPUT_ITERATOR [G]

	V_OUTPUT_STREAM [G]
		undefine
			is_equal
		end

feature -- Replacement
	put (v: G)
			-- Replace item at current position with `v'
		require
			not_off: not off
		deferred
		ensure
			sequence_effect: sequence |=| old sequence.replaced_at (index, v)
		end

	output (v: G)
			-- Replace item at current position with `v' and go to the next position
		do
			put (v)
			forth
		ensure then
			sequence_effect: sequence |=| old (sequence.replaced_at (index, v))
		end
end
