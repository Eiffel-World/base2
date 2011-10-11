note
	description: "Iterators to read from and update tables."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, key_sequence, index

deferred class
	V_TABLE_ITERATOR [K, V]

inherit
	V_MAP_ITERATOR [K, V]
		redefine
			target
		end

	V_IO_ITERATOR [V]
		rename
			sequence as value_sequence
		redefine
			target
		end

feature -- Access
	target: V_TABLE [K, V]
			-- Table to iterate over.
		deferred
		end

feature -- Removal
	remove
			-- Remove key-value pair at current position. Move to the next position.
		require
			not_off: not off
		deferred
		ensure
			target_map_effect: target.map |=| old target.map.removed (key_sequence [index])
			key_sequence_effect: key_sequence |=| old (key_sequence.front (index - 1) + key_sequence.tail (index + 1))
			index_effect: index = old index
		end

end
