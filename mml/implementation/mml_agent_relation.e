note
	description: "Possibly infinite relation implemented using agents."
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
			-- Create a relation {(x, y) | p (x, y)}.
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 2
		do
			predicate := p
		end

feature -- Access
	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related to `y'?
		do
			Result := predicate.item ([x, y])
		end

	image_of (x: G): MML_SET [H]
			-- The set of values related to `x'.
		do
			create {MML_AGENT_SET [H]} Result.such_that (agent has (x, ?))
		end

feature -- Basic operations
	restricted alias "|" (subdomain: MML_SET [G]): MML_RELATION [G, H]
			-- Relation that consists of all pairs in `Current' whose left component is in `subdomain'.
		do
			create {MML_AGENT_RELATION [G, H]} Result.such_that (agent (x: G; y: H; s: MML_SET [G]): BOOLEAN
				do
					Result := has (x, y) and s [x]
				end (?, ?, subdomain))
		end

	complement: MML_AGENT_RELATION [G, H]
			-- Relation that consists of all pairs not in `Current'.
		do
			create Result.such_that (agent (x: G; y: H): BOOLEAN do Result := not has (x, y) end)
		end

	inverse: MML_AGENT_RELATION [H, G]
			-- Relation that consists of inverted pairs from `Current'.
		do
			create Result.such_that (agent (y: H; x: G): BOOLEAN do Result := has (x, y) end)
		end

	union alias "+" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pair contained in either `Current' or `other'.
		do
			create {MML_AGENT_RELATION [G, H]} Result.such_that (agent (x: G; y: H; o: MML_RELATION [G, H]): BOOLEAN
				do
					Result := has (x, y) or o.has (x, y)
				end (?, ?, other))
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pair contained in both `Current' and `other'.
		do
			if attached {MML_FINITE_RELATION [G, H]} other then
				Result := other * Current
			else
				create {MML_AGENT_RELATION [G, H]} Result.such_that (agent (x: G; y: H; o: MML_RELATION [G, H]): BOOLEAN
					do
						Result := has (x, y) and o.has (x, y)
					end (?, ?, other))
			end
		end

feature {MML_AGENT_RELATION} -- Implementation
	predicate: PREDICATE [ANY, TUPLE [G, H]]
			-- Characteristic predicate of the relation.		
end
