note
	description: "Infinite sequences implemented using agents."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MML_AGENT_SEQUENCE [G]

inherit
	MML_SEQUENCE [G]

create
	such_that

feature {NONE} -- Initialization
	such_that (f: FUNCTION [ANY, TUPLE [INTEGER], G])
			-- Create a sequence where `item' (i) = `f' (i) with domain `d'
		do
			function := f
		end

feature -- Access
	item alias "[]" (i: INTEGER): G
			-- Item that corresponds to `k'
		do
			Result := function.item ([i])
		end

	domain: MML_SET [INTEGER]
			-- Domain of the sequence
		once
			create {MML_AGENT_SET [INTEGER]} Result.such_that (agent (i: INTEGER): BOOLEAN do Result := i >= 1 end)
		end

feature -- Status report
	is_empty: BOOLEAN = False
			-- Is sequence empty?

feature -- Decomposition
	but_first : MML_SEQUENCE[G] is
			-- The elements of `current' except for the first one.
		do
			create {MML_AGENT_SEQUENCE [G]} Result.such_that (agent (i: INTEGER): G do Result := item (i + 1) end)
		end

	tail (lower: INTEGER): MML_SEQUENCE[G] is
			-- Suffix from `lower'.
		do
			create {MML_AGENT_SEQUENCE [G]} Result.such_that (agent (i, l: INTEGER): G do Result := item (i + l - 1) end (?, lower))
		end

	interval (lower, upper: INTEGER) : MML_FINITE_SEQUENCE[G] is
			-- Subsequence from `lower' to `upper'.
		local
			a: ARRAY [G]
			i: INTEGER
		do
			create a.make (1, upper - lower + 1)
			from
				i := lower
			until
				i > upper
			loop
				a.put (item (i), i - lower + 1)
				i := i + 1
			end
			create Result.make_from_array (a)
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically equal to `other'?
		do
--			if attached {MML_AGENT_SEQUENCE [G]} other as sequence then
--				Result := function ~ sequence.function
--			end
			Result := True
		end

feature -- Replacement
	replaced_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' at position `i'
		do
			create {MML_AGENT_SEQUENCE [G]} Result.such_that (agent (j, index: INTEGER; y: G): G
				do
					if j = index then
						Result := y
					else
						Result := item (j)
					end
				end (?, i, x))
		end

feature {MML_AGENT_SEQUENCE} -- Implementation
	function: FUNCTION [ANY, TUPLE [INTEGER], G]
			-- Function from positions to sequence elements
end
