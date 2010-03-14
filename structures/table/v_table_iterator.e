note
	description: "Iterators to read from and update tables."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, key_sequence, index

deferred class
	V_TABLE_ITERATOR [K, G]

inherit
	V_ITERATOR [G]
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

	target: V_TABLE [K, G]
			-- Table to iterate over.
		deferred
		end

feature -- Cursor movement
	search_key (k: K)
			-- Move to a position where key is equivalent to `k'.
			-- If `k' does not appear, go off.
			-- (Use `target.key_equivalence'.)
		deferred
		ensure
			index_effect_found: target.has_equivalent_key (target.map, k, target.relation) implies target.relation [key_sequence [index], k]
			index_effect_not_found: not target.has_equivalent_key (target.map, k, target.relation) implies index = key_sequence.count + 1
		end

feature -- Specification
	key_sequence: MML_FINITE_SEQUENCE [K]
			-- Sequence of keys.
		note
			status: specification
		deferred
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
