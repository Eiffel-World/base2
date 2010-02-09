note
	description: "Data structures where values are associated with keys. Keys are unique with respect to some equivalence relation."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation

deferred class
	V_MAP [K, G]

feature -- Access
	item alias "[]" (k: K): G
			-- Value associated with `k'
		require
			has_key: has_key (k)
		deferred
		ensure
			definition: Result = map [map_key (k)]
		end

feature -- Measurement
	has_key (k: K): BOOLEAN
			-- Is any value associated with `k'?
		deferred
		ensure
			definition: Result = not map_keys (k).as_finite.is_empty
		end

feature -- Model
	map: MML_MAP [K, G]
			-- Corresponding mathematical map
		note
			status: model
		deferred
		end

	relation: MML_RELATION [K, K]
			-- Key equivalence relation
		note
			status: model
		deferred
		end

	map_keys (k: K): MML_SET [K]
			-- Set of map keys equivalent to `k'
			-- Either empty of singleton, becacause there is no more than one key from the same equivalence class
		note
			status: spec_helper
		do
			Result := relation.image_of (k) * map.domain
		ensure
			definition: Result |=| (relation.image_of (k) * map.domain)
			finite: Result.is_finite
			empty_or_singleton: Result.as_finite.is_empty or Result.as_finite.count = 1
		end

	map_key (k: K): K
			-- Map key equivalent `k' if present
		note
			status: spec_helper
		require
			has_key: not map_keys (k).as_finite.is_empty
		do
			Result := map_keys (k).as_finite.any_item
		ensure
			Result = map_keys (k).as_finite.any_item
		end
end
