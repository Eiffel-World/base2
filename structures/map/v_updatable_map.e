note
	description: "Maps where values associated with existing keys can be updated."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation

deferred class
	V_UPDATABLE_MAP [K, G]

inherit
	V_MAP [K, G]

feature -- Replacement
	put (k: K; v: G)
			-- Associate `v' with key `k'
		require
			has_key: has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.replaced_at (map_key (k), v)
		end
end
