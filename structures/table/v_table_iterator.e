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

feature {V_TABLE} -- Initialization
	make_start (t: V_TABLE [K, G])
			-- Create an iterator at the start of `t'
		deferred
		ensure
			target_effect: target = t
			index_effect_nonempty: not t.map.is_empty implies index = 1
			index_effect_empty: t.map.is_empty implies index = 0
		end

feature -- Access
	key: K
			-- Key at current position
		require
			not_off: not off
		deferred
		end

	target: V_TABLE [K, G]
			-- Table to iterate over
		deferred
		end

feature -- Model
	key_sequence: MML_FINITE_SEQUENCE [K]
			-- Sequence of keys
		note
			status: model
		deferred
		end

invariant
	target_exists: target /= Void
	keys_in_target: key_sequence.range |=| target.map.domain
	unique_keys: key_sequence.count = target.map.count
	key_definition: key = key_sequence [index]
	value_sequence_domain_definition: value_sequence.count = key_sequence.count
	value_sequence_definition: value_sequence.domain.for_all (agent (i: INTEGER): BOOLEAN
		do
			Result := value_sequence [i] = target.map [key_sequence [i]]
		end)
end
