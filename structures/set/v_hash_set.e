note
	description: "[
			Hash sets with chaining.
			Search, extension and removal are amortized constant time.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: set, relation, hash_function, capacity, optimal_load

class
	V_HASH_SET [G]

inherit
	V_SET [G]
		redefine
			copy
		end

create
	make_reference_equality,
	make_object_equality,
	make,
	make_with_capacity_and_load

feature {NONE} -- Initialization
	make_reference_equality (h: V_HASH [G])
			-- Create an empty set with reference equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make_with_capacity_and_load (create {V_REFERENCE_EQUALITY [G]}, h, default_capacity, default_optimal_load)
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| create {MML_IDENTITY [G]}
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = default_capacity
			optimal_load_effect: optimal_load = default_optimal_load
		end

	make_object_equality (h: V_HASH [G])
			-- Create an empty set with object equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make_with_capacity_and_load (create {V_OBJECT_EQUALITY [G]}, h, default_capacity, default_optimal_load)
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| create {MML_AGENT_RELATION [G, G]}.such_that (agent (x, y: G): BOOLEAN do Result := x ~ y end)
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = default_capacity
			optimal_load_effect: optimal_load = default_optimal_load
		end

	make (eq: V_EQUIVALENCE [G]; h: V_HASH [G])
			-- Create an empty set with equivalence relation `eq' and hash function `h'.
		require
			eq_exists: eq /= Void
			h_exists: h /= Void
		do
			make_with_capacity_and_load (eq, h, default_capacity, default_optimal_load)
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| eq.relation
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = default_capacity
			optimal_load_effect: optimal_load = default_optimal_load
		end

	make_with_capacity_and_load (eq: V_EQUIVALENCE [G]; h: V_HASH [G]; c, l: INTEGER)
			-- Create an empty set with equivalence relation `eq', hash function `h', initial capacity `c' and optimal load `l'.
		require
			eq_exists: eq /= Void
			h_exists: h /= Void
			c_positive: c > 0
			l_positive: l > 0
		do
			equivalence := eq
			hash := h
			buckets := empty_buckets (c)
			optimal_load := l
			create iterator.make (Current)
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| eq.relation
			hash_function_effect: hash_function |=| h.map
			capacity_effect: capacity = c
			optimal_load_effect: optimal_load = l
		end

feature -- Initialization
	copy (other: like Current)
			-- Copy equivalence relation, hash function, capacity, optimal load and values values from `other'.
		local
			i: INTEGER
		do
			if other /= Current then
				equivalence := other.equivalence
				hash := other.hash
				count := other.count
				create buckets.make (1, other.capacity)
				from
					i := 1
				until
					i > other.buckets.count
				loop
					buckets [i] := other.buckets [i].twin
					i := i + 1
				end
				optimal_load := other.optimal_load
				create iterator.make (Current)
			end
		ensure then
			set_effect: set |=| other.set
			relation_effect: relation |=| other.relation
			hash_function_effect: hash_function |=| other.hash_function
			capacity_effect: capacity = other.capacity
			optimal_load_effect: optimal_load = other.optimal_load
			other_set_effect: other.set |=| old other.set
			other_relation_effect: other.relation |=| old other.relation
			other_hash_function_effect: other.hash_function |=| old other.hash_function
			other_capacity_effect: other.capacity = old other.capacity
			other_optimal_load_effect: other.optimal_load = old other.optimal_load
		end

feature -- Measurement
	equivalence: V_EQUIVALENCE [G]
			-- Equivalence relation on values.

	hash: V_HASH [G]
			-- Hash function.

	count: INTEGER
			-- Number of elements.

feature -- Efficiency parameters
	capacity: INTEGER
			-- Bucket array size.
		do
			Result := buckets.count
		end

	optimal_load: INTEGER
			-- Approximate percentage of elements per bucket that bucket array has after automatic resizing.

feature -- Iteration
	new_iterator: V_HASH_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		do
			create Result.make (Current)
			Result.start
		end

	at (v: G): V_HASH_SET_ITERATOR [G]
			-- New iterator over `Current' pointing at element `v' if it exists and `off' otherwise.
		do
			create Result.make (Current)
			Result.search (v)
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the set.
		local
			i: INTEGER
		do
			i := index (v)
			if not buckets [i].exists (agent equivalence.equivalent (v, ?)) then
				buckets [i].extend_back (v)
				count := count + 1
				auto_resize
			end
		ensure then
			capacity_effect: capacity >= old capacity
		end

feature -- Removal
	wipe_out
			-- Remove all elements.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > buckets.count
			loop
				buckets [i].wipe_out
				i := i + 1
			end
			count := 0
			auto_resize
		ensure then
			capacity_effect: capacity = default_capacity
		end

feature -- Resizing		
	resize (n: INTEGER)
			-- Set bucket array size to `n'.
		local
			i: INTEGER
			b: V_ARRAY [V_LINKED_LIST [G]]
		do
			b := empty_buckets (n)
			from
				iterator.start
			until
				iterator.after
			loop
				i := bucket_index (iterator.item, n)
				b [i].extend_back (iterator.item)
				iterator.forth
			end
			buckets := b
		ensure
			capacity_effect: capacity = n
		end

	set_optimal_load (l: INTEGER)
			-- Set `optimal_load' to `l'.
		require
			l_positive: l > 0
		do
			optimal_load := l
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

feature {V_HASH_SET_ITERATOR, V_HASH_SET} -- Implementation
	buckets: V_ARRAY [V_LINKED_LIST [G]]
			-- Element storage.

	index (v: G): INTEGER
			-- Index of `v' into in a `buckets'.
		do
			Result := bucket_index (v, capacity)
		ensure
			result_in_bounds: 1 <= Result and Result <= buckets.count
		end

	remove_at (li: V_LINKED_LIST_ITERATOR [G])
			-- Remove element to which `li' points.
		require
			not_off: not li.off
		do
			li.remove
			count := count - 1
			auto_resize
		end

feature {NONE} -- Implementation
	iterator: V_HASH_SET_ITERATOR [G]
			-- Internal iterator.

	bucket_index (v: G; n: INTEGER): INTEGER
			-- Index of `v' into in a bucket array of size `n'.
		require
			n_positive: n > 0
		do
			Result := hash.item (v) \\ n + 1
		ensure
			result_in_bounds: 1 <= Result and Result <= n
		end

	empty_buckets (n: INTEGER): V_ARRAY [V_LINKED_LIST [G]]
			-- Array of `n' empty buckets.
		require
			n_non_negative: n >= 0
		local
			i: INTEGER
		do
			create Result.make (1, n)
			from
				i := 1
			until
				i > n
			loop
				Result [i] := create {V_LINKED_LIST [G]}
				i := i + 1
			end
		end

	auto_resize
			-- Enlarge `buckets'.
		do
			if count * optimal_load // 100 > default_growth * capacity then
				resize (capacity * default_growth)
			elseif buckets.count > default_capacity and count * optimal_load // 100 < capacity // default_growth then
				resize (capacity // default_growth)
			end
		end

feature -- Specification
	hash_function: MML_MAP [G, INTEGER]
			-- Mathematical map from values to hash codes.
		note
			status: specification
		do
			Result := hash.map
		end

invariant
	hash_exists: hash /= Void
	hash_map_definition: hash.map |=| hash_function
	buckets_exists: buckets /= Void
	iterator_exists: iterator /= Void
	all_buckets_exist: buckets.for_all (agent (x: V_LINKED_LIST [G]): BOOLEAN do Result := x /= Void end)
	optimal_load_positive: optimal_load > 0
end
