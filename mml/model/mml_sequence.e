note
	description: "Possibly infinite sequences."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_SEQUENCE [G]

inherit
	MML_MODEL

feature -- Access
	item alias "[]" (i: INTEGER): G
			-- Item that corresponds to `k'
		require
			in_domain: domain [i]
		deferred
		end

	domain: MML_SET [INTEGER]
			-- Domain of the sequence
		deferred
		end

feature -- Status report
	is_empty: BOOLEAN
			-- Is sequence empty?
		deferred
		end

feature -- Decomposition
	first : G is
			-- First elemrnt.
		require
			non_empty: not is_empty
		do
			Result := item (1)
		end

	but_first : MML_SEQUENCE[G] is
			-- The elements of `current' except for the first one.
		require
			not_empty: not is_empty
		deferred
		end

	tail (lower: INTEGER): MML_SEQUENCE[G] is
			-- Suffix from `lower'.
		deferred
		end

	front (upper: INTEGER): MML_FINITE_SEQUENCE[G] is
			-- Prefix up to `upper'.
		do
			Result := interval (1, upper)
		end

	interval (lower : INTEGER; upper : INTEGER) : MML_FINITE_SEQUENCE[G] is
			-- Subsequence from `lower' to `upper'.
		deferred
		end

feature -- Replacement
	replaced_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' at position `i'
		require
			in_domain: domain [i]
		deferred
		end
end
