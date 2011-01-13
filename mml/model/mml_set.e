note
	description: "Possibly infinite sets."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_SET [G]

inherit
	MML_MODEL

feature -- Access
	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained?
		deferred
		end

---	any_item: G
---			-- Arbitrary element.
---		require
---			not_empty: not is_empty
---		deferred
---		end

feature -- Status report
---	is_empty: BOOLEAN
---			-- Is the set empty?
---		require
---			is_finite: is_finite
---		deferred
---		end

feature -- Element change
	extended (x: G): MML_SET[G]
			-- Current set extended with `x' if absent.
		note
			mapped_to: "Set.extended(Current, x)"
		do
			Result := Current + (create {MML_FINITE_SET [G]}.singleton (x))
		end

	removed (x: G): MML_SET[G]
			-- Current set with `x' removed if present.
		note
			mapped_to: "Set.removed(Current, x)"
		do
			Result := Current - (create {MML_FINITE_SET [G]}.singleton (x))
		end

feature -- Basic operations
	union alias "+" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other'.
		require
			other_exists: other /= Void
		deferred
		end

	intersection alias "*" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in both `Current' and `other'.
		require
			other_exists: other /= Void
		deferred
		end

	difference alias "-" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in `Current' but not in `other'.
		require
			other_exists: other /= Void
		deferred
		end

	sym_difference alias "^" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other', but not in both.
		require
			other_exists: other /= Void
		deferred
		end

feature -- Quantification
---	for_all (test: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
---			-- Does `test' hold for all elements?
---		require
---			test_exists: test /= Void
---			test_has_one_arg: test.open_count = 1
---		deferred
---		end

---	exists (test: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
---			-- Does `test' hold for at least one element?
---		require
---			test_exists: test /= Void
---			test_has_one_arg: test.open_count = 1
---		deferred
---		end
end
