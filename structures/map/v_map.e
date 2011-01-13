note
	description: "Finite data structures where values are associated with keys. Keys are unique with respect to some equivalence relation."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation

deferred class
	V_MAP [K, V]

feature -- Access
	item alias "[]" (k: K): V
			-- Value associated with `k'.
		require
			has_key: has_key (k)
		deferred
		ensure
			definition: Result = map [equivalent_key (k)]
		end

feature -- Measurement
	has_key (k: K): BOOLEAN
			-- Is any value associated with `k'?
		deferred
		ensure
			definition: Result = has_equivalent_key (k)
		end

feature -- Specification
	map: MML_FINITE_MAP [K, V]
			-- Corresponding mathematical map.
		note
			status: specification
		deferred
		end

	relation: MML_RELATION [K, K]
			-- Key equivalence relation.
		note
			status: specification
		deferred
		end

	has_equivalent_key (k: K): BOOLEAN
			-- Does `map' contain a key equivalent to `k' according to `relation'?
		note
			status: specification
		do
			Result := not (map.domain * relation.image_of (k)).is_empty
		ensure
			definition: Result = not (map.domain * relation.image_of (k)).is_empty
		end

	equivalent_key (k: K): K
			-- Key in `map' equivalent to `k' according to `relation'.
		note
			status: specification
		require
			has_equivalent: has_equivalent_key (k)
		do
			Result := (map.domain * relation.image_of (k)).any_item
		ensure
			Result = (map.domain * relation.image_of (k)).any_item
		end
end
