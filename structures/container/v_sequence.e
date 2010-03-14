note
	description: "Containers where values are associated with integer indexes from a continious interval."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map

deferred class
	V_SEQUENCE [G]

inherit
	V_CONTAINER [G]

	V_UPDATABLE_MAP [INTEGER, G]
		rename
			has_key as has_index
		redefine
			map
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
		deferred
		end

	upper: INTEGER
			-- Upper bound of index interval.
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
				Result := index_of_from (v, 1)
			end
		ensure
			definition_not_has: not map.has (v) implies not map.domain [Result]
			definition_has: map.has (v) implies Result = map.inverse.image_of (v).lower
		end

	index_of_from (v: G; i: INTEGER): INTEGER
			-- Index of the first occurrence of `v' starting from position `i';
			-- out of range, if `v' does not occur.
		require
			has_index: has_index (i)
		local
			it: V_INPUT_ITERATOR [G]
			j: INTEGER
			found: BOOLEAN
		do
			from
				it := at (i)
				j := i
				Result := upper + 1
			until
				it.off or found
			loop
				if it.item = v then
					found := True
					Result := j
				end
				it.forth
				j := j + 1
			end
		ensure
			definition_not_has: not (map | {MML_INTEGER_SET} [[i, map.domain.upper]]).has (v) implies not map.domain [Result]
			definition_has: (map | {MML_INTEGER_SET} [[i, map.domain.upper]]).has (v) implies
				Result = (map | {MML_INTEGER_SET} [[i, map.domain.upper]]).inverse.image_of (v).lower
		end

	index_that (p: PREDICATE [ANY, TUPLE [G]]): INTEGER
			-- Index of the first value that satisfies `p';
			-- out of range, if `p' is never satisfied.
		require
			p_exists: p /= Void
		do
			if not is_empty then
				Result := index_that_from (p, 1)
			end
		ensure
			definition_not_has: not map.range.exists (p) implies not map.domain [Result]
			definition_has: map.range.exists (p) implies Result = map.inverse.image ({MML_AGENT_SET [G]} [p]).lower
		end

	index_that_from (p: PREDICATE [ANY, TUPLE [G]]; i: INTEGER): INTEGER
			-- Index of the first value that satisfies `p' starting from position `i';
			-- out of range, if `p' is never satisfied.
		require
			p_exists: p /= Void
			has_index: has_index (i)
		local
			it: V_INPUT_ITERATOR [G]
			j: INTEGER
			found: BOOLEAN
		do
			from
				it := at (i)
				j := i
				Result := upper + 1
			until
				it.off or found
			loop
				if p.item ([it.item]) then
					found := True
					Result := j
				end
				it.forth
				j := j + 1
			end
		ensure
			definition_not_has: not (map | {MML_INTEGER_SET} [[i, map.domain.upper]]).range.exists (p) implies not map.domain [Result]
			definition_has: (map | {MML_INTEGER_SET} [[i, map.domain.upper]]).range.exists (p) implies
				Result = (map | {MML_INTEGER_SET} [[i, map.domain.upper]]).inverse.image ({MML_AGENT_SET [G]} [p]).lower
		end

feature -- Iteration
	at_start: V_ITERATOR [G]
			-- New iterator pointing to the first position.
		deferred
		ensure then
			sequence_definition: Result.sequence.domain.for_all (agent (j: INTEGER; s: MML_FINITE_SEQUENCE [G]): BOOLEAN
				do
					Result := s [j] = map [map.domain.lower + j - 1]
				end (?, Result.sequence))
		end

	at_finish: like at_start
			-- New iterator pointing to the last position.
		deferred
		ensure
			target_definition: Result.target = Current
			sequence_domain_definition: Result.sequence.count = bag.count
			sequence_definition: Result.sequence.domain.for_all (agent (j: INTEGER; s: MML_FINITE_SEQUENCE [G]): BOOLEAN
				do
					Result := s [j] = map [map.domain.lower + j - 1]
				end (?, Result.sequence))
			index_definition: Result.index = map.count
		end

	at (i: INTEGER): like at_start
			-- New iterator poiting at `i'-th position.
		require
			has_index: 1 <= i and i <= count
		deferred
		ensure
			target_definition: Result.target = Current
			sequence_domain_definition: Result.sequence.count = bag.count
			sequence_definition: Result.sequence.domain.for_all (agent (j: INTEGER; s: MML_FINITE_SEQUENCE [G]): BOOLEAN
				do
					Result := s [j] = map [map.domain.lower + j - 1]
				end (?, Result.sequence))
			index_definition: Result.index = i
		end

feature -- Replacement
	fill (v: G; l, u: INTEGER)
			-- Put `v' at positions [`l', `u'].
		require
			valid_lower: has_index (l)
			valid_upper: has_index (u)
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
			map_changed_effect: (map | {MML_INTEGER_SET}[[l, u]]).is_constant (v)
			map_unchanged_effect: (map | (map.domain - {MML_INTEGER_SET}[[l, u]])) |=| old (map | (map.domain - {MML_INTEGER_SET}[[l, u]]))
		end

	clear (l, u: INTEGER)
			-- Put default value at positions [`l', `u'].
		require
			valid_lower: has_index (l)
			valid_upper: has_index (u)
		do
			fill (default_item, l, u)
		ensure
			map_domain_effect: map.domain |=| old map.domain
			map_changed_effect: (map | {MML_INTEGER_SET}[[l, u]]).is_constant (default_item)
			map_unchanged_effect: (map | (map.domain - {MML_INTEGER_SET}[[l, u]])) |=| old (map | (map.domain - {MML_INTEGER_SET}[[l, u]]))
		end

	subcopy (other: V_SEQUENCE [G]; other_first, other_last, index: INTEGER)
			-- Copy items of `other' within bounds [`other_first', `other_last'] to current array starting at index `index'.
		require
			other_exists: other /= Void
			valid_lower: other.has_index (other_first)
			valid_upper: other.has_index (other_last) or other_last = 0
			valid_bounds: other_first <= other_last + 1
			valid_start: has_index (index)
			enough_space: upper - index >= other_last - other_first
		local
			j: INTEGER
		do
			from
				j := other_first
			until
				j > other_last
			loop
				put (j - other_first + index, other [j])
				j := j + 1
			end
		ensure
			map_domain_effect: map.domain |=| old map.domain
			map_changed_effect: {MML_INTEGER_SET} [[index, index + other_last - other_first]].for_all (agent (i: INTEGER; other_map: MML_MAP [INTEGER, G]; f, of: INTEGER): BOOLEAN
				do
					Result := map [i] = other_map [i - f + of]
				end (?, old other.map, index, other_first))
			map_unchanged_effect: (map | (map.domain - {MML_INTEGER_SET} [[index, index + other_last - other_first]])) |=|
				old (map | (map.domain - {MML_INTEGER_SET} [[index, index + other_last - other_first]]))
			other_map_effect: other /= Current implies other.map |=| old other.map
		end

feature -- Specification
	map: MML_FINITE_MAP [INTEGER, G]
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
				it.off
			loop
				Result := Result.extended (i, it.item)
				it.forth
				i := i + 1
			end
		end

	relation: MML_IDENTITY [INTEGER]
			-- Index equivalence relation: identity.
		note
			status: specification
		do
			create Result
		end

invariant
	indexes_in_interval: map.domain.is_interval
	lower_definition_nonempty: not map.is_empty implies lower = map.domain.lower
	lower_defintion_empty: map.is_empty implies lower = 1
	upper_definition_nonempty: not map.is_empty implies upper = map.domain.upper
	upper_defintion_empty: map.is_empty implies upper = 0
	first_definition: not map.is_empty implies first = map [lower]
	last_definition: not map.is_empty implies last = map [upper]
	relation_definition: relation.is_identity
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
end
