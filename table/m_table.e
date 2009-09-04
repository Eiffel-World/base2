note
	description: "Finite mappings, where keys and items can be dynamically reassociated"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_TABLE [K, E]

inherit
	M_MAPPING [K, E]

	M_FINITE [E]

	M_REPLACEABLE [E]

feature -- Replacement
	replace (k: K; v: E)
			-- Reassociate `k' with `v'
		require
			has_key: has_key (k)
		deferred
		ensure
			associated: item (k) = v
		end
end
