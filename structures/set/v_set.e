note
	description: "[
		Container where all elements are unique with respect to some equivalence relation. 
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
			i := new_iterator
			i.search (v)
			Result := not i.after
		ensure
			definition: Result = has_equivalent (v)
		end

	has_exactly (v: G): BOOLEAN
			-- Is value `v' contained?
			-- (Uses reference equality.)
		local
			i: V_SET_ITERATOR [G]
		do
			i := new_iterator
			i.search (v)
			Result := not i.after and then i.item = v
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
	new_iterator: V_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		deferred
		end

	at (v: G): V_SET_ITERATOR [G]
			-- New iterator over `Current' pointing at element `v' if it exists and `after' otherwise.
		deferred
		ensure
			target_definition: Result.target = Current
			index_definition_found: has_equivalent (v) implies relation [Result.sequence [Result.index], v]
			index_definition_not_found: not has_equivalent (v) implies Result.index = Result.sequence.count + 1
		end

feature -- Comparison
	is_subset_of (other: V_SET [G]): BOOLEAN
			-- Does `other' have all elements of `Current'?
			-- (Uses `other.equivalence'.)
		require
			other_exists: other /= Void
		do
			Result := for_all (agent other.has)
		ensure
			definition: Result = set.for_all (agent other.has_equivalent)
		end

	is_superset_of (other: V_SET [G]): BOOLEAN
			-- Does `Current' have all elements of `other'?
			-- (Uses `equivalence'.)
		require
			other_exists: other /= Void
		do
			Result := other.is_subset_of (Current)
		ensure
			definition: Result = other.set.for_all (agent has_equivalent)
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
					Result := not has_equivalent (x)
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
---			definition: Result = (relation |=| other.relation and set.count = other.set.count and
---				set.for_all (agent other.has_equivalent))
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the set.
		deferred
		ensure
			set_effect_not_has: not old has_equivalent (v) implies set |=| old set.extended (v)
			set_effect_has: old has_equivalent (v) implies set |=| old set
		end

	join (other: V_SET [G])
			-- Add all elements from `other'.
		require
			other_exists: other /= Void
		do
			from
				other.iterator.start
			until
				other.iterator.after
			loop
				extend (other.iterator.item)
				other.iterator.forth
			end
		ensure
			set_effect_old: (old set).for_all (agent has_equivalent)
			set_effect_other: other.set.for_all (agent has_equivalent)
			set_effect_new: set.for_all (agent (x: G; c, o: V_SET [G]): BOOLEAN
				do
					Result := c.has_equivalent (x) or o.has_equivalent (x)
				end (?, old Current.twin, other))
		end

feature -- Removal
	remove (v: G)
			-- Remove `v' from the set, if contained.
			-- Otherwise do nothing.		
		do
			iterator.search (v)
			if not iterator.after then
				iterator.remove
			end
		ensure
			set_effect_has: old has_equivalent (v) implies set |=| old (set.removed (equivalent (v)))
			set_effect_not_has: not old has_equivalent (v) implies set |=| old set
		end

	meet (other: V_SET [G])
			-- Remove elements that are not in `other'.
		require
			other_exists: other /= Void
		do
			from
				iterator.start
			until
				iterator.after
			loop
				if not other.has (iterator.item) then
					iterator.remove
				else
					iterator.forth
				end
			end
		ensure
			set_effect_old: (old set).for_all (agent (x: G; o: V_SET [G]): BOOLEAN
				do
					Result := has_equivalent (x) xor not o.has_equivalent (x)
				end (?, other))
			set_effect_new: set.for_all (agent (old Current.twin).has_equivalent)
		end

	subtract (other: V_SET [G])
			-- Remove elements that are in `other'.
		require
			other_exists: other /= Void
		do
			from
				other.iterator.start
			until
				other.iterator.after
			loop
				remove (other.iterator.item)
				other.iterator.forth
			end
		ensure
			set_effect_old: (old set).for_all (agent (x: G; o: V_SET [G]): BOOLEAN
				do
					Result := has_equivalent (x) or o.has_equivalent (x)
				end (?, other))
			set_effect_new: set.for_all (agent (old Current.twin).has_equivalent)
		end

	sym_subtract (other: V_SET [G])
			-- Remove elements that are also in `other' and add elements of `other' that are not in `Current'.
		require
			other_exists: other /= Void
		do
			from
				other.iterator.start
			until
				other.iterator.after
			loop
				if has (other.iterator.item) then
					remove (other.iterator.item)
				else
					extend (other.iterator.item)
				end
				other.iterator.forth
			end
		ensure
			set_effect_old: (old set).for_all (agent (x: G; o: V_SET [G]): BOOLEAN
				do
					Result := not o.has_equivalent (x) implies has_equivalent (x)
				end (?, other))
			set_effect_other: other.set.for_all (agent (x: G; c: V_SET [G]): BOOLEAN
				do
					Result := not c.has_equivalent (x) implies has_equivalent (x)
				end (?, old Current.twin))
			set_effect_new: set.for_all (agent (x: G; c, o: V_SET [G]): BOOLEAN
				do
					Result := c.has_equivalent (x) or o.has_equivalent (x)
				end (?, old Current.twin, other))
		end

feature {V_SET} -- Implementation
	iterator: V_SET_ITERATOR [G]
			-- Internal iterator (to be used only in procedures).		
		deferred
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
				i := new_iterator
			until
				i.after
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

	has_equivalent (x: G): BOOLEAN
			-- Does `set' contain an element equivalent to `x' according to `relation'?
		note
			status: specification
		do
			Result := not (set * relation.image_of (x)).is_empty
		ensure
			definition: Result = not (set * relation.image_of (x)).is_empty
		end

	equivalent (x: G): G
			-- Element of `set' equivalent to `x' according to `relation'.
		note
			status: specification
		require
			has_equivalent: has_equivalent (x)
		do
			Result := (set * relation.image_of (x)).any_item
		ensure
			Result = (set * relation.image_of (x)).any_item
		end

invariant
	equivalence_exists: equivalence /= Void
	-- equivalence_relation_definition: equivalence.relation |=| relation
	bag_domain_definition: bag.domain |=| set
	bag_definition: bag.is_constant (1)
end
