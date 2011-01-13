note
	description: "Identity relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_IDENTITY [G]

inherit
	MML_ENDORELATION [G]

	MML_FINITE

feature -- Access
	has alias "[]" (x, y: G): BOOLEAN
			-- Is `x' related `y'?
		do
			Result := model_equals (x, y)
		end

	image_of (x: G): MML_FINITE_SET [G]
			-- Set of values related to `x'.
		do
			create Result.singleton (x)
		end

	image (subdomain: MML_SET [G]): MML_SET [G]
			-- The set of values related to any value in `subdomain'.
		require
			subdomain_exists: subdomain /= Void
		do
			Result := subdomain
		end

feature -- Status report
	reflexive: BOOLEAN = True
			-- Is relation reflexive?

	irreflexive: BOOLEAN = False
			-- Is relation irreflexive?

	symmetric: BOOLEAN = True
			-- Is relation symmetric?

	antisymmetric: BOOLEAN = True
			-- Is relation antisymmetric?

	transitive: BOOLEAN = True
			-- Is relation transitive?

	total: BOOLEAN = False
			-- Is relation total?

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically equal to `other'?
		do
			if attached {MML_IDENTITY [G]} other then
				Result := True
			end
		end

feature -- Basic operations
	restricted alias "|" (subdomain: MML_SET [G]): MML_ENDORELATION [G]
			-- Relation that consists of all pairs in `Current' whose left component is in `subdomain'.
		do
			create {MML_AGENT_ENDORELATION [G]} Result.such_that (agent (x, y: G; s: MML_SET [G]): BOOLEAN
				do
					Result := Current [x, y] and s [x]
				end (?, ?, subdomain))
		end

	complement: MML_ENDORELATION [G]
			-- Relation that consists of all pairs not in `Current'.
		do
			create {MML_AGENT_ENDORELATION [G]} Result.such_that (agent (x, y: G): BOOLEAN
				do
					Result := not model_equals (x, y)
				end)
		end

	inverse: MML_IDENTITY [G]
			-- Relation that consists of inverted pairs from `Current'.
		do
			Result := Current
		end

	union alias "+" (other: MML_RELATION [G, G]): MML_ENDORELATION [G]
			-- Relation that consists of pair contained in either `Current' or `other'.
		do
			create {MML_AGENT_ENDORELATION [G]} Result.such_that (agent (x, y: G; o: MML_RELATION [G, G]): BOOLEAN
				do
					Result := has (x, y) or o.has (x, y)
				end (?, ?, other))
		end

	intersection alias "*" (other: MML_RELATION [G, G]): MML_ENDORELATION [G]
			-- Relation that consists of pair contained in both `Current' and `other'.
		do
			create {MML_AGENT_ENDORELATION [G]} Result.such_that (agent (x, y: G; o: MML_RELATION [G, G]): BOOLEAN
				do
					Result := has (x, y) and o.has (x, y)
				end (?, ?, other))
		end
end
