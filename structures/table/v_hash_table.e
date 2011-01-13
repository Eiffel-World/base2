note
	description: "[
			Hash tables with chaining.
			Search, extension and removal are amortized constant time.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation, hash_function

class
	V_HASH_TABLE [K, V]

inherit
	V_SET_TABLE [K, V]
		redefine
			copy
		end

create
	make_reference_equality,
	make_object_equality,
	make

feature {NONE} -- Initialization
	make_reference_equality (h: V_HASH [K])
			-- Create an empty set with reference equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make (create {V_REFERENCE_EQUALITY [K]}, h)
		ensure
			map_effect: map.is_empty
			relation_effect: create {MML_IDENTITY [K]} |=| relation
			--- hash_function_effect: hash_function |=| h.map
		end

	make_object_equality (h: V_HASH [K])
			-- Create an empty set with object equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make (create {V_OBJECT_EQUALITY [K]}, h)
		ensure
			map_effect: map.is_empty
			--- relation_effect: relation |=| create {MML_AGENT_RELATION [K, K]}.such_that (agent (x, y: K): BOOLEAN do Result := x ~ y end)
			--- hash_function_effect: hash_function |=| h.map
		end

	make (eq: V_EQUIVALENCE [K]; h: V_HASH [K])
			-- Create an empty table with key equivalence `eq'.
		require
			eq_exists: eq /= Void
		do
			key_equivalence := eq
			key_hash := h
			create set.make (create {V_KEY_VALUE_EQUIVALENCE [K, V]}.make (eq), create {V_KEY_VALUE_HASH [K, V]}.make (h))
		ensure
			map_effect: map.is_empty
			--- relation_effect: relation |=| eq.relation
			--- hash_function_effect: hash_function |=| h.map
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize table by copying `key_order', and key-value pair from `other'.
		do
			if other /= Current then
				key_equivalence := other.key_equivalence
				key_hash := other.key_hash
				if set = Void then
					-- Copy used as a creation procedure
					set := other.set.twin
				else
					set.copy (other.set)
				end
			end
		ensure then
			map_effect: map |=| other.map
			--- relation_effect: relation |=| other.relation
			--- hash_function_effect: hash_function |=| other.hash_function
			map_effect: other.map |=| old other.map
			--- relation_effect: other.relation |=| old other.relation
			--- hash_function_effect: other.hash_function |=| old other.hash_function
		end

feature -- Measurement
	key_equivalence: V_EQUIVALENCE [K]
			-- Equivalence relation on keys.

	key_hash: V_HASH [K]
			-- Hash function on keys.

feature {V_SET_TABLE, V_SET_TABLE_ITERATOR} -- Implementation
	set: V_HASH_SET [TUPLE [key: K; value: V]]
			-- Underlying set of key-value pairs.
			-- Should not be reassigned after creation.

feature -- Specification
	hash_function: MML_MAP [K, INTEGER]
			-- Mathematical map from keys to hash codes.
		note
			status: specification
		do
			Result := key_hash.map
		end

invariant
	key_hash_exists: key_hash /= Void
	--- key_hash_map_definition: key_hash.map |=| hash_function
end
