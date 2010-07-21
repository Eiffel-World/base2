note
	description: "Possibly infinite sets implemented using agents."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_AGENT_SET [G]

inherit
	MML_SET [G]

create
	such_that

convert
	such_that ({PREDICATE [ANY, TUPLE [G]]})

feature {NONE} -- Initialization
	such_that (p: PREDICATE [ANY, TUPLE [G]])
			-- Create a set {x | p(x)}
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 1
		do
			predicate := p
		end

feature -- Access
	has alias "[]" (x: G): BOOLEAN
			-- Does set contain `x'?
		do
			Result := predicate.item ([x])
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically equal to `other'?
		do
			Result := True
		end

feature -- Basic operations
	intersection alias "*" (other: MML_SET [G]): MML_SET [G]
			-- Set that consists of values contained in both `Current' and `other'
		do
			if attached {MML_FINITE_SET [G]} other then
				Result := other.intersection (Current)
			else
				create {MML_AGENT_SET [G]} Result.such_that (agent (x: G; o: MML_SET [G]): BOOLEAN
					do
						Result := has (x) and o.has (x)
					end (?, other))
			end
		end

feature {MML_AGENT_SET} -- Implementation
	predicate: PREDICATE [ANY, TUPLE [G]]
			-- Defining predicate of a set
end

