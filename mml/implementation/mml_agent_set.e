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
	such_that,
	universe

convert
	such_that ({PREDICATE [ANY, TUPLE [G]]})

feature {NONE} -- Initialization
	such_that (p: PREDICATE [ANY, TUPLE [G]])
			-- Create a set {x | p(x)}.
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 1
		do
			predicate := p
		end

	universe
			-- Create a set of all values of type G.
		do
			predicate := agent (x: G): BOOLEAN do Result := True end
		end

feature -- Access
	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := predicate.item ([x])
		end

feature -- Basic operations
	union alias "+" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other'.
		do
			create {MML_AGENT_SET [G]} Result.such_that (agent (x: G; o: MML_SET [G]): BOOLEAN
				do
					Result := Current [x] or o [x]
				end (?, other))
		end

	intersection alias "*" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in both `Current' and `other'.
		do
			if attached {MML_FINITE_SET [G]} other then
				Result := other * Current
			else
				create {MML_AGENT_SET [G]} Result.such_that (agent (x: G; o: MML_SET [G]): BOOLEAN
					do
						Result := Current [x] and o [x]
					end (?, other))
			end
		end

	difference alias "-" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in `Current' but not in `other'.
		do
			create {MML_AGENT_SET [G]} Result.such_that (agent (x: G; o: MML_SET [G]): BOOLEAN
				do
					Result := Current [x] and not o [x]
				end (?, other))
		end

	sym_difference alias "^" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other', but not in both.
		do
			create {MML_AGENT_SET [G]} Result.such_that (agent (x: G; o: MML_SET [G]): BOOLEAN
				do
					Result := Current [x] xor o [x]
				end (?, other))
		end

feature {MML_AGENT_SET} -- Implementation
	predicate: PREDICATE [ANY, TUPLE [G]]
			-- Characteristic predicate of the set.
end

