note
	description: "Containers where values are associated with integer indexes from a continuous interval."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map

deferred class
	V_SEQUENCE [G]

inherit
	V_CONTAINER [G]
		rename
			new_iterator as at_start
		end

	V_UPDATABLE_MAP [INTEGER, G]
		rename
			has_key as has_index
		undefine
			out
		redefine
			has_index,
			map
		end

inherit {NONE}
	V_EQUALITY [INTEGER]
		export {NONE}
			all
		undefine
			out
		end

	V_ORDER [INTEGER]
		export {NONE}
			all
		undefine
			out
		end

feature -- Access		
	first: G
			-- First element.
		require
			not_empty: not is_empty
		do
			Result := item (lower)
		end

	last: G
			-- Last element.
		require
			not_empty: not is_empty
		do
			Result := item (upper)
		end

feature -- Measurement
	lower: INTEGER
			-- Lower bound of index interval.
		note
			status: specification
		deferred
		end

	upper: INTEGER
			-- Upper bound of index interval.
		note
			status: specification
		deferred
		end

	count: INTEGER
			-- Number of elements.
		do
			Result := upper - lower + 1
		end

	has_index (i: INTEGER): BOOLEAN
			-- Is any value associated with `i'?
		do
			Result := lower <= i and i <= upper
		end

feature -- Search
	index_of (v: G): INTEGER
			-- Index of the first occurrence of `v';
			-- out of range, if `v' does not occur.
		do
			if not is_empty then
				Result := index_of_from (v, lower)
			end
		ensure
			definition_not_has: not map.has (v) implies not map.domain [Result]
			definition_has: map.has (v) implies Result = map.inverse.image_of (v).extremum (agent less_equal)
		end

	index_of_from (v: G; i: INTEGER): INTEGER
			-- Index of the first occurrence of `v' starting from position `i';
			-- out of range, if `v' does not occur.
		require
			has_index: has_index (i)
		local
			it: V_INPUT_ITERATOR [G]
			j: INTEGER
		do
			from
				it := at (i)
				j := i
				Result := upper + 1
			until
				it.after or else it.item = v
			loop
				it.forth
				j := j + 1
			end
			if not it.after then
				Result := j
			end
		ensure
			definition_not_has: not (map | {MML_INTERVAL} [[i, upper]]).has (v) implies not map.domain [Result]
			definition_has: (map | {MML_INTERVAL} [[i, upper]]).has (v) implies
				Result = (map | {MML_INTERVAL} [[i, upper]]).inverse.image_of (v).extremum (agent less_equal)
		end

	index_that (p: PREDICATE [ANY, TUPLE [G]]): INTEGER
			-- Index of the first value that satisfies `p';
			-- out of range, if `p' is never satisfied.
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 1
		do
			if not is_empty then
				Result := index_that_from (p, lower)
			end
		ensure
			definition_not_has: not map.range.exists (p) implies not map.domain [Result]
			definition_has: map.range.exists (p) implies Result = map.inverse.image (map.range | p).extremum (agent less_equal)
		end

	index_that_from (p: PREDICATE [ANY, TUPLE [G]]; i: INTEGER): INTEGER
			-- Index of the first value that satisfies `p' starting from position `i';
			-- out of range, if `p' is never satisfied.
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 1
			has_index: has_index (i)
		local
			it: V_INPUT_ITERATOR [G]
			j: INTEGER
		do
			from
				it := at (i)
				j := i
				Result := upper + 1
			until
				it.after or else p.item ([it.item])
			loop
				it.forth
				j := j + 1
			end
			if not it.after then
				Result := j
			end
		ensure
			definition_not_has: not (map | {MML_INTERVAL} [[i, upper]]).range.exists (p) implies not map.domain [Result]
			definition_has: (map | {MML_INTERVAL} [[i, upper]]).range.exists (p) implies
				Result = (map | {MML_INTERVAL} [[i, upper]]).inverse.image (map.range | p).extremum (agent less_equal)
		end

	key_equivalence: PREDICATE [ANY, TUPLE [INTEGER, INTEGER]]
			-- Index equivalence relation: identity.
		note
			status: specification
		once
			Result := agent reference_equal
		end

feature -- Iteration
	at_start: like at
			-- New iterator pointing to the first position.
		do
			Result := at (lower)
		ensure then
			sequence_definition: Result.sequence.domain.for_all (agent (j: INTEGER; s: MML_SEQUENCE [G]): BOOLEAN
				do
					Result := s [j] = map [lower + j - 1]
				end (?, Result.sequence))
		end

	at_finish: like at
			-- New iterator pointing to the last position.
		do
			Result := at (upper)
		ensure
			target_definition: Result.target = Current
			sequence_domain_definition: Result.sequence.count = map.count
			sequence_definition: Result.sequence.domain.for_all (agent (j: INTEGER; s: MML_SEQUENCE [G]): BOOLEAN
				do
					Result := s [j] = map [lower + j - 1]
				end (?, Result.sequence))
			index_definition: Result.index = map.count
		end

	at (i: INTEGER): V_ITERATOR [G]
			-- New iterator pointing at position `i'.
		require
			valid_position: lower - 1 <= i and i <= upper + 1
		deferred
		ensure
			target_definition: Result.target = Current
			sequence_domain_definition: Result.sequence.count = bag.count
			sequence_definition: Result.sequence.domain.for_all (agent (j: INTEGER; s: MML_SEQUENCE [G]): BOOLEAN
				do
					Result := s [j] = map [lower + j - 1]
				end (?, Result.sequence))
			index_definition_nonempty: not map.is_empty implies Result.index = i - lower + 1
			index_definition_empty: map.is_empty implies Result.index = i
		end

feature -- Replacement
	fill (v: G; l, u: INTEGER)
			-- Put `v' at positions [`l', `u'].
		require
			l_not_too_small: l >= lower
			u_not_too_large: u <= upper
			l_not_too_large: l <= u + 1
		local
			it: V_ITERATOR [G]
			j: INTEGER
		do
			from
				it := at (l)
				j := l
			until
				j > u
			loop
				it.put (v)
				it.forth
				j := j + 1
			end
		ensure
			map_domain_effect: map.domain |=| old map.domain
			map_changed_effect: (map | {MML_INTERVAL}[[l, u]]).is_constant (v)
			map_unchanged_effect: (map | (map.domain - {MML_INTERVAL}[[l, u]])) |=| old (map | (map.domain - {MML_INTERVAL}[[l, u]]))
		end

	clear (l, u: INTEGER)
			-- Put default value at positions [`l', `u'].
		require
			l_not_too_small: l >= lower
			u_not_too_large: u <= upper
			l_not_too_large: l <= u + 1
		do
			fill (({G}).default, l, u)
		ensure
			map_domain_effect: map.domain |=| old map.domain
			map_changed_effect: (map | {MML_INTERVAL}[[l, u]]).is_constant (({G}).default)
			map_unchanged_effect: (map | (map.domain - {MML_INTERVAL}[[l, u]])) |=| old (map | (map.domain - {MML_INTERVAL}[[l, u]]))
		end

	subcopy (other: V_SEQUENCE [G]; other_first, other_last, index: INTEGER)
			-- Copy items of `other' within bounds [`other_first', `other_last'] to current sequence starting at index `index'.
		require
			other_exists: other /= Void
			other_first_not_too_small: other_first >= other.lower
			other_last_not_too_large: other_last <= other.upper
			other_first_not_too_large: other_first <= other_last + 1
			index_not_too_small: index >= lower
			enough_space: upper - index >= other_last - other_first
		local
			j: INTEGER
		do
			from
				j := other_first
			until
				j > other_last
			loop
				put (other [j], j - other_first + index)
				j := j + 1
			end
		ensure
			map_domain_effect: map.domain |=| old map.domain
			map_changed_effect: {MML_INTERVAL} [[index, index + other_last - other_first]].for_all (
				agent (i: INTEGER; other_map: MML_MAP [INTEGER, G]; f, of: INTEGER): BOOLEAN
					do
						Result := map [i] = other_map [i - f + of]
					end (?, old other.map, index, other_first))
			map_unchanged_effect: (map | (map.domain - {MML_INTERVAL} [[index, index + other_last - other_first]])) |=|
				old (map | (map.domain - {MML_INTERVAL} [[index, index + other_last - other_first]]))
			other_map_effect: other /= Current implies other.map |=| old other.map
		end

	sort (order: PREDICATE [ANY, TUPLE [G, G]])
			-- Sort elements in `order' left to right.
		require
			order_exists: order /= Void
			order_has_two_args: order.open_count = 2
			--- is_total_order: is_total_order (order)
		do
			quick_sort (lower, upper, order)
		ensure
			map_effect_short: map.count < 2 implies map |=| old map
			map_effect_long: map.count >= 2 implies
				map.domain.removed (map.domain.extremum (agent greater_equal)).for_all (
					agent (i: INTEGER; o: PREDICATE [ANY, TUPLE [G, G]]): BOOLEAN
						do
							Result := o.item ([map [i], map [i + 1]])
						end (?, order))
		end

feature {NONE} -- Implementation
	quick_sort (left, right: INTEGER; order: PREDICATE [ANY, TUPLE [G, G]])
			-- Sort element in index range [`left', `right'] in `order' left to right.
		require
			in_range: right > left implies has_index (left) and has_index (right)
			order_exists: order /= Void
			order_has_two_args: order.open_count = 2
			--- is_total_order: is_total_order (order)
		local
			pivot, l, r: INTEGER
		do
			if right > left then
				from
					l := left
					r := right
					pivot := (left + right) // 2
				until
					l > pivot or r < pivot
				loop
					from
					until
						order.item ([item (pivot), item (l)]) or l > pivot
					loop
						l := l + 1
					end
					from
					until
						order.item ([item (r), item (pivot)]) or r < pivot
					loop
						r := r - 1
					end
					swap (l, r)
					l := l + 1
					r := r - 1
					if l - 1 = pivot then
						r := r + 1
						pivot := r
					elseif r + 1 = pivot then
						l := l - 1
						pivot := l
					end
				end
				quick_sort (left, pivot - 1, order)
				quick_sort (pivot + 1, right, order)
			end
		end

feature -- Specification
	map: MML_MAP [INTEGER, G]
			-- Map of indexes to values.
		note
			status: specification
		local
			it: V_INPUT_ITERATOR [G]
			i: INTEGER
		do
			create Result.empty
			from
				i := lower
				it := at_start
			until
				it.after
			loop
				Result := Result.updated (i, it.item)
				it.forth
				i := i + 1
			end
		end

---	is_total_order (o: PREDICATE [ANY, TUPLE [G, G]])
			-- Is `o' a total order relation?
---		note
---			status: specification
---		deferred
---		ensure
			--- definition: Result = (
			--- (forall x: G :: o (x, x)) and
			--- (forall x, y, z: G :: o (x, y) and o (y, z) implies o (x, z) and
			--- (forall x, y: G :: o (x, y) or o (y, x)))
---		end		

invariant
	lower_definition_nonempty: not map.is_empty implies lower = map.domain.extremum (agent less_equal)
	lower_definition_empty: map.is_empty implies lower = 1
	upper_definition_nonempty: not map.is_empty implies upper = map.domain.extremum (agent greater_equal)
	upper_definition_empty: map.is_empty implies upper = 0
	first_definition: not map.is_empty implies first = map [lower]
	last_definition: not map.is_empty implies last = map [upper]
	indexes_in_interval: map.domain |=| {MML_INTERVAL} [[lower, upper]]
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
	--- key_equivalence_definition: key_equivalence |=| agent reference_equal
end
