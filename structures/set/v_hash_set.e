note
	description: "[
			Hash sets with chaining.
			Search, extension and removal are amortized constant time.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: set, relation, hash_function

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
	make

feature {NONE} -- Initialization
	make_reference_equality (h: V_HASH [G])
			-- Create an empty set with reference equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make (create {V_REFERENCE_EQUALITY [G]}, h)
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| create {MML_IDENTITY [G]}
			hash_function_effect: hash_function |=| h.map
		end

	make_object_equality (h: V_HASH [G])
			-- Create an empty set with object equality and hash function `h'.
		require
			h_exists: h /= Void
		do
			make (create {V_OBJECT_EQUALITY [G]}, h)
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| create {MML_AGENT_RELATION [G, G]}.such_that (agent (x, y: G): BOOLEAN do Result := x ~ y end)
			hash_function_effect: hash_function |=| h.map
		end

	make (eq: V_EQUIVALENCE [G]; h: V_HASH [G])
			-- Create an empty set with equivalence relation `eq' and hash function `h'.
		require
			eq_exists: eq /= Void
			h_exists: h /= Void
		do
			equivalence := eq
			hash := h
			buckets := empty_buckets (default_capacity)
			create iterator.make (Current)
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| eq.relation
			hash_function_effect: hash_function |=| h.map
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
				create iterator.make (Current)
			end
		ensure then
			set_effect: set |=| other.set
			relation_effect: relation |=| other.relation
			hash_function_effect: hash_function |=| other.hash_function
			other_set_effect: other.set |=| old other.set
			other_relation_effect: other.relation |=| old other.relation
			other_hash_function_effect: other.hash_function |=| old other.hash_function
		end

feature -- Measurement
	equivalence: V_EQUIVALENCE [G]
			-- Equivalence relation on values.

	hash: V_HASH [G]
			-- Hash function.

	count: INTEGER
			-- Number of elements.

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
		end

feature {NONE} -- Performance parameters
	default_capacity: INTEGER = 8
			-- Default size of `buckets'.

	optimal_load: INTEGER = 100
			-- Approximate percentage of elements per bucket that bucket array has after automatic resizing.

	growth_rate: INTEGER = 2
			-- Rate by which bucket array grows and shrinks.

feature {V_HASH_SET_ITERATOR, V_HASH_SET} -- Implementation
	buckets: V_ARRAY [V_LINKED_LIST [G]]
			-- Element storage.

	capacity: INTEGER
			-- Bucket array size.
		do
			Result := buckets.count
		end

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
			-- Resize `buckets' to an optimal size for current `count'.
		do
			if count * optimal_load // 100 > growth_rate * capacity then
				resize (capacity * growth_rate)
			elseif buckets.count > default_capacity and count * optimal_load // 100 < capacity // growth_rate then
				resize (capacity // growth_rate)
			end
		end

	resize (c: INTEGER)
			-- Resize `buckets' to `c'.
		require
			c_positive: c > 0
		local
			i: INTEGER
			b: V_ARRAY [V_LINKED_LIST [G]]
		do
			b := empty_buckets (c)
			from
				iterator.start
			until
				iterator.after
			loop
				i := bucket_index (iterator.item, c)
				b [i].extend_back (iterator.item)
				iterator.forth
			end
			buckets := b
		ensure
			capacity_effect: capacity = c
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
end
