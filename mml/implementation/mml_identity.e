note
	description: "Identity relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_IDENTITY [G]

inherit
	MML_ENDORELATION [G]
		redefine
			is_identity
		end

feature -- Access
	has alias "[]" (x, y: G): BOOLEAN
			-- Is `x' related `y'?
		do
			Result := model_equals (x, y)
		end

	image_of (x: G): MML_FINITE_SET [G]
			-- The set of values related to `x'
		do
			Result := (create {MML_FINITE_SET [G]}.empty).extended (x)
		end

feature -- Status report
	is_identity: BOOLEAN = True
			-- Is this an identity relation?

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
			-- Infinite sets are never equal
		do
			if attached {MML_IDENTITY [G]} other then
				Result := True
			end
		end

feature -- Basic operations
	complement: MML_RELATION [G, G]
			-- Relation consisting of all pairs not in `Current'
		do
			create {MML_AGENT_RELATION [G, G]} Result.such_that (agent (x, y: G): BOOLEAN
				do
					Result := not model_equals (x, y)
				end)
		end

	inverse: MML_IDENTITY [G]
			-- Relation consisting of inverted pairs from `Current'
		do
			Result := Current
		end

	intersection alias "*" (other: MML_RELATION [G, G]): MML_RELATION [G, G]
			-- Relation consisting of pair contained in both `Current' and `other'
		do
--			if attached {MML_FINITE_RELATION [G, G]} other then
--				Result := other.intersection (Current)
--			else
				create {MML_AGENT_RELATION [G, G]} Result.such_that (agent (x, y: G; o: MML_RELATION [G, G]): BOOLEAN
					do
						Result := has (x, y) and o.has (x, y)
					end (?, ?, other))
--			end
		end
end
