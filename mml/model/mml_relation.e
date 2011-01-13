note
	description: "Possibly infinite relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_RELATION [G, H]

inherit
	MML_MODEL

feature -- Access
	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related to `y'?
		deferred
		end

feature -- Sets
---	range: MML_SET [H]
---			-- The set of values related to any value.
---		deferred
---		end	

---	image (subdomain: MML_SET [G]): MML_SET [H]
---			-- The set of values related to any value in `subdomain'.
---		require
---			subdomain_exists: subdomain /= Void
---		deferred
---		end		

	image_of (x: G): MML_SET [H]
			-- Set of values related to `x'.
		deferred
		end

feature -- Basic operations
	restricted alias "|" (subdomain: MML_SET [G]): MML_RELATION [G, H]
			-- Relation that consists of all pairs in `Current' whose left component is in `subdomain'.
		require
			subdomain_exists: subdomain /= Void
		deferred
		end

	complement: MML_RELATION [G, H]
			-- Relation that consists of all pairs not in `Current'.
		deferred
		end

	inverse: MML_RELATION [H, G]
			-- Relation that consists of inverted pairs from `Current'.
		deferred
		end

	union alias "+" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other'.
		require
			other_exists: other /= Void
		deferred
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pair contained in both `Current' and `other'.
		require
			other_exists: other /= Void
		deferred
		end
end
