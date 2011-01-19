note
	description: "Maps where key-value pairs can be added and removed."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, key_equivalence

deferred class
	V_TABLE [K, V]

inherit
	V_UPDATABLE_MAP [K, V]
		redefine
			is_equal
		end

	V_CONTAINER [V]
		redefine
			is_equal
		end

feature -- Access
	item alias "[]" (k: K): V assign put
			-- Value associated with `k'.
		local
			i: V_TABLE_ITERATOR [K, V]
		do
			i := at_key (k)
			Result := i.value
		end

feature -- Iteration
	new_iterator: V_TABLE_ITERATOR [K, V]
			-- New iterator pointing to a position in the table, from which it can traverse all elements by going `forth'.
		deferred
		end

	at_key (k: K): V_TABLE_ITERATOR [K, V]
			-- New iterator pointing to a position with key `k'
		deferred
		ensure
			target_definition: Result.target = Current
			index_definition_found: has_key (k) implies equivalent (Result.key_sequence [Result.index], k)
			index_definition_not_found: not has_key (k) implies Result.index = Result.key_sequence.count + 1
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Does `other' have equivalent set of keys (with respect to both `key_equivalence' and `other.key_equivalence'),
			-- and associate them with then same values?
		local
			i, j: V_TABLE_ITERATOR [K, V]
		do
			if count = other.count then
				from
					Result := True
					i := new_iterator
					j := other.new_iterator
				until
					i.after or not Result
				loop
					j.search_key (i.key)
					Result := not j.after and then (equivalent (i.key, j.key) and i.value = j.value)
					i.forth
				end
			end
		ensure then
			definition: Result = (map.count = other.map.count and
				map.domain.for_all (agent (k: K; o: like Current): BOOLEAN
					do
						Result := o.has_key (k) and then (equivalent (k, o.key (k)) and map [k] = o.map [o.key (k)])
					end (?, other)))
		end

feature -- Replacement
	put (v: V; k: K)
			-- Associate `v' with key `k'.
		local
			i: V_TABLE_ITERATOR [K, V]
		do
			i := at_key (k)
			i.put (v)
		end

feature -- Extension
	extend (v: V; k: K)
			-- Extend table with key-value pair <`k', `v'>.
		require
			fresh_key: not has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.extended (k, v)
		end

	force (v: V; k: K)
			-- Make sure that `k' is associated with `v'.
			-- Add `k' if not already present.
		local
			i: V_TABLE_ITERATOR [K, V]
		do
			i := at_key (k)
			if i.after then
				extend (v, k)
			else
				i.put (v)
			end
		ensure
			map_effect_has: old has_key (k) implies map |=| old map.replaced_at (key (k), v)
			map_effect_not_has: not old has_key (k) implies map |=| old map.extended (k, v)
		end

feature -- Removal
	remove (k: K)
			-- Remove key `k' and its associated value.
		require
			has_key: has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.removed (key (k))
		end

feature -- Specification
	map: MML_FINITE_MAP [K, V]
			-- Map of keys to values.
		note
			status: specification
		local
			it: V_TABLE_ITERATOR [K, V]
		do
			create Result.empty
			from
				it := new_iterator
			until
				it.after
			loop
				Result := Result.extended (it.key, it.value)
				it.forth
			end
		end

invariant
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: V): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
end
