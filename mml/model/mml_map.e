note
	description: "Possibly infinite partial maps."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_MAP [K, G]

inherit
	MML_MODEL

feature -- Access
	domain: MML_SET [K]
			-- Set of keys
		deferred
		end

	item alias "[]" (k: K): G
			-- Value associated with `k'
		require
			in_domain: domain [k]
		deferred
		end

feature -- Replacement
	replaced_at (k: K; x: G): MML_MAP [K, G]
			-- Current map with the value associated with `k' replaced by `x'
		require
			in_domain: domain [k]
		deferred
		end

feature -- Basic operations
	sequence_image (s: MML_FINITE_SEQUENCE [K]): MML_FINITE_SEQUENCE [G]
			-- Sequence of images of `s' elements under `Current'.		
		local
			i: INTEGER
			a: V_ARRAY [G]
		do
			create a.make (1, s.count)
			from
				i := 1
			until
				i > s.count
			loop
				a [i] := item (s [i])
				i := i + 1
			end
			create Result.make_from_array (a)
		end

--	restricted (subdomain: MML_SET [K]): MML_MAP [K, G]
--			-- This map with all key-value pairs where key is outside `restriction' removed
--		deferred
--		end
end
