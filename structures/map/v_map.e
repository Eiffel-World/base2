note
	description: "Data structures where values are associated with keys. Keys are unique with respect to some equivalence relation."
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
			definition: Result = map [equivalent_key (map, k, relation)]
		end

feature -- Measurement
	has_key (k: K): BOOLEAN
			-- Is any value associated with `k'?
		deferred
		ensure
			definition: Result = has_equivalent_key (map, k, relation)
		end

feature -- Specification
	map: MML_MAP [K, V]
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

	has_equivalent_key (m: MML_MAP [K, V]; k: K; r: MML_RELATION [K, K]): BOOLEAN
			-- Does `m' contain a key equivalent to `k' according to `r'?
		note
			status: specification
		require
			m_exists: m /= Void
			r_exists: r /= Void
		do
			Result := not (r.image_of (k) * m.domain).as_finite.is_empty
		ensure
			definition: Result = not (r.image_of (k) * m.domain).as_finite.is_empty
		end

	equivalent_key (m: MML_MAP [K, V]; k: K; r: MML_RELATION [K, K]): K
			-- Key in `m' equivalent to `k' according to `r'.
		note
			status: specification
		require
			m_exists: m /= Void
			r_exists: r /= Void
			has_equivalent: has_equivalent_key (m, k, r)
		do
			Result := (r.image_of (k) * m.domain).as_finite.any_item
		ensure
			Result = (r.image_of (k) * m.domain).as_finite.any_item
		end
end
