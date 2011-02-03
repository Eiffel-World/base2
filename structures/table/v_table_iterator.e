note
	description: "Iterators to read from and update tables."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, key_sequence, index

deferred class
	V_TABLE_ITERATOR [K, V]

inherit
	V_ITERATOR [V]
		rename
			item as value,
			sequence as value_sequence
		redefine
			target
		end

feature -- Access
	key: K
			-- Key at current position.
		require
			not_off: not off
		deferred
		end

	target: V_TABLE [K, V]
			-- Table to iterate over.
		deferred
		end

feature -- Cursor movement
	search_key (k: K)
			-- Move to a position where key is equivalent to `k'.
			-- If `k' does not appear, go after.
			-- (Use `target.key_equivalence'.)
		deferred
		ensure
			index_effect_found: target.has_key (k) implies target.equivalent (key_sequence [index], k)
			index_effect_not_found: not target.has_key (k) implies index = key_sequence.count + 1
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

feature -- Specification
	key_sequence: MML_SEQUENCE [K]
			-- Sequence of keys.
		note
			status: specification
		deferred
		ensure
			exists: Result /= Void
		end

invariant
	target_exists: target /= Void
	keys_in_target: key_sequence.range |=| target.map.domain
	unique_keys: key_sequence.count = target.map.count
	key_definition: key_sequence.domain [index] implies key = key_sequence [index]
	value_sequence_domain_definition: value_sequence.count = key_sequence.count
	value_sequence_definition: value_sequence.domain.for_all (agent (i: INTEGER): BOOLEAN
		do
			Result := value_sequence [i] = target.map [key_sequence [i]]
		end)
end
