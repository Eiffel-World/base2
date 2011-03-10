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
			map_effect: map |=| old map.updated (key (k), v)
		end

	swap (k1, k2: K)
			-- Swap values associated with `k1' and `k2'.
		require
			has_key_one: has_key (k1)
			has_key_two: has_key (k2)
		local
			v: V
		do
			v := item (k1)
			put (item (k2), k1)
			put (v, k2)
		ensure
			map_effect: map |=| old map.updated (key (k1), map [key (k2)]).updated (key (k2), map [key (k1)])
		end
end
