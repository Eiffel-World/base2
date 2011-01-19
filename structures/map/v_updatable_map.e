note
	description: "Maps where values associated with existing keys can be updated."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation

deferred class
	V_UPDATABLE_MAP [K, V]

inherit
	V_MAP [K, V]
		redefine
			item
		end

feature -- Access
	item alias "[]" (k: K): V assign put
			-- Value associated with `k'.
		deferred
		end

feature -- Replacement
	put (v: V; k: K)
			-- Associate `v' with key `k'.
		require
			has_key: has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.replaced_at (key (k), v)
		end
end
