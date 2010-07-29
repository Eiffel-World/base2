note
	description: "[
			Hash tables with chaining.
			Search, extension and removal are amortized constant time.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation, hash_function, capacity, optimal_load

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
	make,
	make_with_capacity_and_load

feature {NONE} -- Initialization
	make_reference_equality (h: V_HASH [K])
			-- Create an empty set with reference equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make_with_capacity_and_load (create {V_REFERENCE_EQUALITY [K]}, h, default_capacity, default_optimal_load)
		ensure
			map_effect: map.is_empty
			relation_effect: relation |=| create {MML_IDENTITY [K]}
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = default_capacity
			optimal_load_effect: optimal_load = default_optimal_load
		end

	make_object_equality (h: V_HASH [K])
			-- Create an empty set with object equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make_with_capacity_and_load (create {V_OBJECT_EQUALITY [K]}, h, default_capacity, default_optimal_load)
		ensure
			map_effect: map.is_empty
			relation_effect: relation |=| create {MML_AGENT_RELATION [K, K]}.such_that (agent (x, y: K): BOOLEAN do Result := x ~ y end)
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = default_capacity
			optimal_load_effect: optimal_load = default_optimal_load
		end

	make (eq: V_EQUIVALENCE [K]; h: V_HASH [K])
			-- Create an empty table with key equivalence `eq'.
		require
			eq_exists: eq /= Void
		do
			make_with_capacity_and_load (eq, h, default_capacity, default_optimal_load)
		ensure
			map_effect: map.is_empty
			relation_effect: relation |=| eq.relation
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = default_capacity
			optimal_load_effect: optimal_load = default_optimal_load
		end

	make_with_capacity_and_load (eq: V_EQUIVALENCE [K]; h: V_HASH [K]; c, l: INTEGER)
			-- Create an empty table with key equivalence `eq', hash function `h', initial capacity `c' and optimal load `l'.
		require
			eq_exists: eq /= Void
			h_exists: h /= Void
			c_positive: c > 0
			l_positive: l > 0
		do
			key_equivalence := eq
			key_hash := h
			create set.make_with_capacity_and_load (create {V_KEY_VALUE_EQUIVALENCE [K, V]}.make (eq),
				create {V_KEY_VALUE_HASH [K, V]}.make (h), c, l)
		ensure
			map_effect: map.is_empty
			relation_effect: relation |=| eq.relation
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = c
			optimal_load_effect: optimal_load = l
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize table by copying `key_order', and key-value pair from `other'.
		do
			if other /= Current then
				key_equivalence := other.key_equivalence
				key_hash := other.key_hash
				set := other.set.twin
			end
		ensure then
			map_effect: map |=| other.map
			relation_effect: relation |=| other.relation
			hash_function_effect: hash_function |=| other.hash_function
			capacity_effect: capacity = other.capacity
			optimal_load_effect: optimal_load = other.optimal_load
			map_effect: other.map |=| old other.map
			relation_effect: other.relation |=| old other.relation
			hash_function_effect: other.hash_function |=| old other.hash_function
			capacity_effect: other.capacity = old other.capacity
			optimal_load_effect: other.optimal_load = old other.optimal_load
		end

feature -- Measurement
	key_equivalence: V_EQUIVALENCE [K]
			-- Equivalence relation on keys.

	key_hash: V_HASH [K]
			-- Hash function on keys.

feature -- Efficiency parameters
	capacity: INTEGER
			-- Bucket array size.
		do
			Result := set.capacity
		end

	optimal_load: INTEGER
			-- Approximate percentage of elements per bucket that bucket array has after automatic resizing.			
		do
			Result := set.optimal_load
		end

feature -- Resizing		
	resize (n: INTEGER)
			-- Set bucket array size to `n'.
		do
			set.resize (n)
		ensure
			capacity_effect: capacity = n
		end

	set_optimal_load (l: INTEGER)
			-- Set `optimal_load' to `l'.
		require
			l_positive: l > 0
		do
			set.set_optimal_load (l)
		ensure
			optimal_load_effect: optimal_load = l
		end

feature -- Defaults
	default_capacity: INTEGER = 8
			-- Default size of `buckets'.

	default_optimal_load: INTEGER = 100
			-- Default value for `optimal_load'.

	default_growth: INTEGER = 2
			-- Rate by which bucket array grows and shrinks.		

feature {V_SET_TABLE, V_SET_TABLE_ITERATOR} -- Implementation
	set: V_HASH_SET [TUPLE [key: K; value: V]]
			-- Underlying set of key-value pairs.

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
	key_hash_map_definition: key_hash.map |=| hash_function
end
