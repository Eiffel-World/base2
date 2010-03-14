note
	description: "[
		Container where all elements are unique with repect to some equivalence relation. 
		Elements can be added and removed.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: set, relation

deferred class
	V_SET [G]

inherit
	V_CONTAINER [G]
		rename
			has as has_exactly
		redefine
			has_exactly,
			occurrences,
			is_equal
		end

feature -- Measurement
	equivalence: V_EQUIVALENCE [G]
			-- Equivalence relation on values.
		deferred
		end

feature -- Search
	has (v: G): BOOLEAN
			-- Is `v' contained?
			-- (Uses `equivalence'.)
		local
			i: V_SET_ITERATOR [G]
		do
			i := at_start
			i.search (v)
			Result := not i.off
		ensure
			definition: Result = has_equivalent (set, v, relation)
		end

	has_exactly (v: G): BOOLEAN
			-- Is value `v' contained?
			-- (Uses reference equality.)
		local
			i: V_SET_ITERATOR [G]
		do
			i := at_start
			i.search (v)
			Result := not i.off and then i.item = v
		end

	occurrences (v: G): INTEGER
			-- How many times is `v' contained?
			-- (Uses reference equality.)
		do
			if has_exactly (v) then
				Result := 1
			end
		end

feature -- Iteration
	at_start: V_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		do
			Result := new_iterator
			Result.start
		end

	new_iterator: V_SET_ITERATOR [G]
			-- New iterator over `Current'.
			-- (Might have more efficient implementation than `at_start'.)
		deferred
		ensure
			target_definition: Result.target = Current
		end

feature -- Comparison
	is_subset_of (other: V_SET [G]): BOOLEAN
			-- Does `other' have all ellement of `Current'?
			-- (Uses `other.equivalence'.)
		require
			other_exists: other /= Void
		do
			Result := for_all (agent other.has)
		ensure
			definition: Result = set.for_all (agent has_equivalent (other.set, ?, other.relation))
		end

	is_superset_of (other: V_SET [G]): BOOLEAN
			-- Does `Current' have all ellement of `other'?
			-- (Uses `equivalence'.)
		require
			other_exists: other /= Void
		do
			Result := other.is_subset_of (Current)
		ensure
			definition: Result = other.set.for_all (agent has_equivalent (set, ?, relation))
		end

	disjoint (other: V_SET [G]): BOOLEAN
			-- Do no elements of `other' occur in `Current'?
			-- (Uses `equivalence'.)
		require
			other_exists: other /= Void
		do
			Result := not other.exists (agent has)
		ensure
			definition: Result = other.set.for_all (agent (x: G): BOOLEAN
				do
					Result := not has_equivalent (set, x, relation)
				end)
		end

	is_equal (other: like Current): BOOLEAN
			-- Does `other' has the same equivalence relation and equivalent elements?
		do
			if other = Current then
				Result := True
			else
				Result := equivalence ~ other.equivalence and count = other.count and is_subset_of (other)
			end
		ensure then
			definition: Result = (relation |=| other.relation and set.count = other.set.count and
				set.for_all (agent has_equivalent (other.set, ?, relation)))
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the set.
		deferred
		ensure
			set_effect_not_has: not has_equivalent (old set, v, relation) implies set |=| old set.extended (v)
			set_effect_has: has_equivalent (old set, v, relation) implies set |=| old set
		end

	join (other: V_SET [G])
			-- Add all elements from `other'.
		require
			other_exists: other /= Void
		local
			i: V_INPUT_ITERATOR [G]
		do
			from
				i := other.at_start
			until
				i.off
			loop
				extend (i.item)
				i.forth
			end
		ensure
			set_effect_old: (old set).for_all (agent has_equivalent (set, ?, relation))
			set_effect_other: other.set.for_all (agent has_equivalent (set, ?, relation))
			set_effect_new: set.for_all (agent (x: G; s: MML_FINITE_SET [G]; o: V_SET [G]): BOOLEAN
				do
					Result := has_equivalent (s, x, relation) or has_equivalent (o.set, x, o.relation)
				end (?, old set, other))
		end

feature -- Removal
	remove (v: G)
			-- Remove `v' from the set, if contained.
			-- Otherwise do nothing.
		deferred
		ensure
			set_effect_has: old (has_equivalent (set, v, relation)) implies set |=| old (set.removed (equivalent (set, v, relation)))
			set_effect_not_has: not old (has_equivalent (set, v, relation)) implies set |=| old set
		end

	meet (other: V_SET [G])
			-- Remove elements that are not in `other'.
		require
			other_exists: other /= Void
		local
			i: V_INPUT_ITERATOR [G]
			s: V_SET [G]
		do
			s := twin
			from
				i := s.at_start
			until
				i.off
			loop
				if not other.has (i.item) then
					remove (i.item)
				end
				i.forth
			end
		ensure
			set_effect_old: (old set).for_all (agent (x: G; o: V_SET [G]): BOOLEAN
				do
					Result := has_equivalent (set, x, relation) or not has_equivalent (o.set, x, o.relation)
				end (?, other))
			set_effect_new: set.for_all (agent has_equivalent (old set, ?, relation))
		end

	subtract (other: V_SET [G])
			-- Remove elements that are in `other'.
		require
			other_exists: other /= Void
		local
			i: V_INPUT_ITERATOR [G]
		do
			from
				i := other.at_start
			until
				i.off
			loop
				remove (i.item)
				i.forth
			end
		ensure
			set_effect_old: (old set).for_all (agent (x: G; o: V_SET [G]): BOOLEAN
				do
					Result := has_equivalent (set, x, relation) or has_equivalent (o.set, x, o.relation)
				end (?, other))
			set_effect_new: set.for_all (agent has_equivalent (old set, ?, relation))
		end

	difference (other: V_SET [G])
			-- Remove elements that are also in `other' and add elements of `other' that are not in `Current'.
		require
			other_exists: other /= Void
		local
			i: V_INPUT_ITERATOR [G]
		do
			from
				i := other.at_start
			until
				i.off
			loop
				if has (i.item) then
					remove (i.item)
				else
					extend (i.item)
				end
				i.forth
			end
		ensure
			set_effect_old: (old set).for_all (agent (x: G; o: V_SET [G]): BOOLEAN
				do
					Result := not has_equivalent (o.set, x, o.relation) implies has_equivalent (set, x, relation)
				end (?, other))
			set_effect_other: other.set.for_all (agent (x: G; s: MML_FINITE_SET [G]): BOOLEAN
				do
					Result := not has_equivalent (s, x, relation) implies has_equivalent (set, x, relation)
				end (?, old set))
			set_effect_new: set.for_all (agent (x: G; s: MML_FINITE_SET [G]; o: V_SET [G]): BOOLEAN
				do
					Result := has_equivalent (s, x, relation) or has_equivalent (o.set, x, o.relation)
				end (?, old set, other))
		end

feature -- Specification
	set: MML_FINITE_SET [G]
			-- Set of elements.
		note
			status: specification
		local
			i: V_INPUT_ITERATOR [G]
		do
			create Result.empty
			from
				i := at_start
			until
				i.off
			loop
				Result := Result.extended (i.item)
				i.forth
			end
		end

	relation: MML_RELATION [G, G]
			-- Element equivalence relation.
		note
			status: specification
		do
			Result := equivalence.relation
		end

	has_equivalent (s: MML_FINITE_SET [G]; x: G; r: MML_RELATION [G, G]): BOOLEAN
			-- Does `s' contain an element equivalent to `x' according to `r'?
		note
			status: specification
		do
			Result := not (s * r.image_of (x)).is_empty
		ensure
			definition: Result = not (s * r.image_of (x)).is_empty
		end

	equivalent (s: MML_FINITE_SET [G]; x: G; r: MML_RELATION [G, G]): G
			-- Element of `s' equivalent to `x' according to `r'.
		note
			status: specification
		require
			has_equivalent: has_equivalent (s, x, r)
		do
			Result := (s * r.image_of (x)).any_item
		ensure
			Result = (s * r.image_of (x)).any_item
		end

invariant
	equivalence_exists: equivalence /= Void
	equivalence_relation_definition: equivalence.relation |=| relation
	bag_domain_definition: bag.domain |=| set
	bag_definition: bag.is_constant (1)
end
