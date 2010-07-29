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
			-- First element.
		require
			non_empty: not is_empty
		do
			Result := item (1)
		end

	but_first: like Current is
			-- The elements of `current' except for the first one.
		require
			not_empty: not is_empty
		deferred
		end

	tail (lower: INTEGER): like Current is
			-- Suffix from `lower'.
		deferred
		end

	front (upper: INTEGER): like Current is
			-- Prefix up to `upper'.
		do
			Result := interval (1, upper)
		end

	interval (lower: INTEGER; upper: INTEGER): like Current is
			-- Subsequence from `lower' to `upper'.
		deferred
		end

feature -- Replacement
	replaced_at (i: INTEGER; x: G): like Current
			-- Current sequence with `x' at position `i'
		require
			in_domain: domain [i]
		deferred
		end
end
