note
	description: "[
		Containers where values are associated with keys. 
		Keys are unique with respect to some equivalence relation.
		Immutable interface.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, key_equivalence

deferred class
	V_MAP [K, V]

inherit
	V_CONTAINER [V]
		redefine
			out
		end

feature -- Access
	item alias "[]" (k: K): V
			-- Value associated with `k'.
		require
			has_key: has_key (k)
		do
			Result := at_key (k).value
		ensure
			definition: Result = map [key (k)]
		end

feature -- Search
	key_equivalence: PREDICATE [ANY, TUPLE [K, K]]
			-- Key equivalence relation.
		deferred
		end

	has_key (k: K): BOOLEAN
			-- Does `map' contain a key equivalent to `k' according to `key_equivalence'?
		note
			status: specification
		deferred
		ensure
			definition: Result = map.domain.exists (agent equivalent (k, ?))
		end

	exists_key (pred: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
			-- Is there a key that satisfies `pred'?
		require
			pred_exists: pred /= Void
			pred_has_one_arg: pred.open_count = 1
			precondition_satisfied: map.domain.for_all (agent (k: K; p: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
				do
					Result := p.precondition ([k])
				end (?, pred))
		local
			it: V_MAP_ITERATOR [K, V]
		do
			from
				Result := False
				it := new_iterator
			until
				it.after or Result
			loop
				Result := pred.item ([it.key])
				it.forth
			end
		ensure
			definition: Result = map.domain.exists (pred)
		end

	for_all_keys (pred: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
			-- Do all keys satisfy `pred'?
		require
			pred_exists: pred /= Void
			pred_has_one_arg: pred.open_count = 1
			precondition_satisfied: map.domain.for_all (agent (k: K; p: PREDICATE [ANY, TUPLE [K]]): BOOLEAN
				do
					Result := p.precondition ([k])
				end (?, pred))
		local
			it: V_MAP_ITERATOR [K, V]
		do
			from
				Result := True
				it := new_iterator
			until
				it.after or not Result
			loop
				Result := pred.item ([it.key])
				it.forth
			end
		ensure
			definition: Result = map.domain.for_all (pred)
		end

feature -- Iteration
	new_iterator: like at_key
			-- New iterator pointing to a position in the map, from which it can traverse all elements by going `forth'.
		deferred
		end

	at_key (k: K): V_MAP_ITERATOR [K, V]
			-- New iterator pointing to a position with key `k'.
			-- If key does not exist, iterator is off.
		deferred
		ensure
			target_definition: Result.target = Current
			index_definition_found: has_key (k) implies equivalent (Result.key_sequence [Result.index], k)
			index_definition_not_found: not has_key (k) implies not Result.key_sequence.domain [Result.index]
		end

feature -- Output
	out: STRING
			-- String representation of the content.
		local
			it: V_MAP_ITERATOR [K, V]
		do
			from
				Result := ""
				it := new_iterator
			until
				it.off
			loop
				Result.append ("(" + it.key.out + ", " + it.value.out + ")")
				if not it.is_last then
					Result.append (" ")
				end
				it.forth
			end
		end

feature -- Specification
	map: MML_MAP [K, V]
			-- Map of keys to values.
		note
			status: specification
		local
			it: V_MAP_ITERATOR [K, V]
		do
			create Result
			from
				it := new_iterator
			until
				it.after
			loop
				Result := Result.updated (it.key, it.value)
				it.forth
			end
		end

	equivalent (k1, k2: K): BOOLEAN
			-- Are `k1' and `k2' equivalent according to `key_equivalence'?
		note
			status: specification
		do
			Result := key_equivalence.item ([k1, k2])
		ensure
			definition: Result = key_equivalence.item ([k1, k2])
		end

	key (k: K): K
			-- Key in `map' equivalent to `k' according to `relation'.
		note
			status: specification
		require
			has_key: has_key (k)
		do
			Result := (map.domain | agent equivalent (k, ?)).any_item
		ensure
			Result = (map.domain | agent equivalent (k, ?)).any_item
		end

---	is_equivalence (r: PREDICATE [ANY, TUPLE [K, K]])
			-- Is `r' an equivalence relation?
---		note
---			status: specification
---		deferred
---		ensure
			--- definition: Result = (
			---	(forall x: K :: r (x, x)) and
			--- (forall x, y: K :: r (x, y) = r (y, x)) and
			--- (forall x, y, z: K :: r (x, y) and r (y, z) implies r (x, z))
---		end

invariant
	key_equivalence_exists: key_equivalence /= Void
	--- equivalence_is_total: equivalence.precondition |=| True
	--- equivalence_is_equivalence: is_equivalence (key_equivalence)
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: V): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
end