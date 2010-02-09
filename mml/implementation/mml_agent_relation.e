note
	description: "Possibly infinite relations implemented using agents."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_AGENT_RELATION [G, H]

inherit
	MML_RELATION [G, H]

create
	such_that

feature {NONE} -- Initialization
	such_that (p: PREDICATE [ANY, TUPLE [G, H]])
			-- Create a set {x | p(x)}
		do
			predicate := p
		end

feature -- Access
	has alias "[]" (x: G; y: H): BOOLEAN
			-- Does relation contain <`x', `y'>?
		do
			Result := predicate.item ([x, y])
		end

	image_of (x: G): MML_SET [H]
			-- The set of values related to `x'
		do
			create {MML_AGENT_SET [H]} Result.such_that (agent has (x, ?))
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically equal to `other'?
		do
			Result := True
		end

feature -- Basic operations
	complement: MML_AGENT_RELATION [G, H]
			-- Relation consisting of all pairs not in `Current'
		do
			create Result.such_that (agent (x: G; y: H): BOOLEAN do Result := not has (x, y) end)
		end

	inverse: MML_AGENT_RELATION [H, G]
			-- Relation consisting of inverted pairs from `Current'
		do
			create Result.such_that (agent (y: H; x: G): BOOLEAN do Result := has (x, y) end)
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation consisting of pair contained in both `Current' and `other'
		do
--			if attached {MML_FINITE_RELATION [G, H]} other then
--				Result := other.intersection (Current)
--			else
				create {MML_AGENT_RELATION [G, H]} Result.such_that (agent (x: G; y: H; o: MML_RELATION [G, H]): BOOLEAN
					do
						Result := has (x, y) and o.has (x, y)
					end (?, ?, other))
--			end
		end

feature {MML_AGENT_RELATION} -- Implementation
	predicate: PREDICATE [ANY, TUPLE [G]]
			-- Definiting predicate of a set		
end
