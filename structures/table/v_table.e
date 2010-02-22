note
	description: "Finite maps where key-value pairs can be added and removed."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation

deferred class
	V_TABLE [K, G]

inherit
	V_UPDATABLE_MAP [K, G]
		redefine
			is_equal
		end

	V_CONTAINER [G]
		redefine
			is_equal
		end

feature -- Measurement
	key_equivalence: V_EQUIVALENCE [K]
			-- Equivalence relation on keys
		deferred
		end

feature -- Iteration
	at_start: V_TABLE_ITERATOR [K, G]
			-- New iterator pointing to a position in the table, from which it can traverse all elements by going `forth'
		deferred
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Does `other' have the same key equivalence relation,
			-- contain the same set of keys and associate them with then same values?
		local
			i, j: V_TABLE_ITERATOR [K, G]
		do
			if key_equivalence ~ other.key_equivalence and count = other.count then
				from
					Result := True
					i := at_start
					j := other.at_start
				until
					i.off or not Result
				loop
					j.search_key (i.key)
					Result := not j.off and then i.value = j.value
					i.forth
				end
			end
		end

feature -- Extension
	extend (k: K; v: G)
			-- Extend table with key-value pair <`k', `v'>
		require
			fresh_key: not has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.extended (k, v)
		end

	force (k: K; v: G)
			-- Make sure that `k' is associated with `v'.
			-- Add `k' if not already present.
		do
			if has_key (k) then
				put (k, v)
			else
				extend (k, v)
			end
		ensure
			map_effect_has: old has_equivalent_key (map, k, relation) implies map |=| old map.replaced_at (equivalent_key (map, k, relation), v)
			map_effect_not_has: not old has_equivalent_key (map, k, relation) implies map |=| old map.extended (k, v)
		end

feature -- Removal
	remove (k: K)
			-- Remove key `k' and its associated value.
		require
			has_key: has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.removed (equivalent_key (map, k, relation))
		end

feature -- Specification
	map: MML_FINITE_MAP [K, G]
			-- Corresponding mathematical map
		note
			status: specification
		local
			it: V_TABLE_ITERATOR [K, G]
		do
			create Result.empty
			from
				it := at_start
			until
				it.off
			loop
				Result := Result.extended (it.key, it.value)
				it.forth
			end
		end

	relation: MML_RELATION [K, K]
			-- Key equivalence relation
		note
			status: specification
		do
			Result := key_equivalence.relation
		end

invariant
	key_equivalence_exists: key_equivalence /= Void
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
	key_equivalence_relation_definition: key_equivalence.relation |=| relation
end
