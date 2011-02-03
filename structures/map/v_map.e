note
	description: "Finite data structures where values are associated with keys. Keys are unique with respect to some equivalence relation."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, key_equivalence

deferred class
	V_MAP [K, V]

feature -- Access
	item alias "[]" (k: K): V
			-- Value associated with `k'.
		require
			has_key: has_key (k)
		deferred
		ensure
			definition: Result = map [key (k)]
		end

feature -- Search
	key_equivalence: PREDICATE [ANY, TUPLE [K, K]]
			-- Key equivalence relation.
		deferred
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

	has_key (k: K): BOOLEAN
			-- Does `map' contain a key equivalent to `k' according to `key_equivalence'?
		note
			status: specification
		do
			Result := map.domain.exists (agent equivalent (k, ?))
		ensure
			definition: Result = map.domain.exists (agent equivalent (k, ?))
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

feature -- Specification
	map: MML_MAP [K, V]
			-- Corresponding mathematical map.
		note
			status: specification
		deferred
		ensure
			exists: Result /= Void
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
	--- is_equivalence: is_equivalence (key_equivalence)
end
