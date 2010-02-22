note
	description: "Finite sets."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_FINITE_SET [G]

inherit
	MML_SET [G]
		redefine
			is_finite,
			as_finite,
			is_empty
		end

create
	empty,
	singleton

create {MML_MODEL}
	make_from_array

convert
	singleton ({G})

feature -- Access
	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained in the set?
		note
			mapped_to: "Current[x]"
		local
			i: INTEGER
		do
			from
				i := array.lower
			until
				i > array.upper or Result
			loop
				Result := model_equals (x, array[i])
				i := i + 1
			end
		end

	count: INTEGER
			-- Set cardinality
		note
			mapped_to: "Set.count(Current)"
		do
			Result := array.count
		end

	any_item: G
			-- Arbitrary item from the set
		require
			not_empty: not is_empty
		do
			if not is_empty then
				-- Workaround for semistrict postconditions
				Result := array [array.lower]
			end
		end

	lower: INTEGER
			-- Minimum
		note
			mapped_to: "Set.lower(Current)"
		require
			is_integer_set: is_integer_set
			not_empty: not is_empty
		do
			Result := as_integer_set.lower
		end

	upper: INTEGER
			-- Maximum
		note
			mapped_to: "Set.upper(Current)"
		require
			is_integer_set: is_integer_set
			not_empty: not is_empty
		do
			Result := as_integer_set.upper
		end
feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is `Current' mathematically equal to `other'?
		note
			mapped_to: "Current == other"
		local
			i: INTEGER
		do
			if attached {MML_FINITE_SET[G]} other as set and then count = set.count then
				from
					Result := True
					i := array.lower
				until
					i > array.upper or not Result
				loop
					Result := set.has (array [i])
					i := i + 1
				end
			end
		end

feature {NONE} -- Initialization
	empty
			-- Create an empty set
		note
			mapped_to: "Set.empty"
		do
			create array.make (1, 0)
		end

	singleton (x: G)
			-- Create a set that contains only `x'
		do
			create array.make (1, 1)
			array [1] := x
		end

feature -- Element change
	extended (x: G): MML_FINITE_SET[G]
			-- Current set extended with `x'
		note
			mapped_to: "Set.extended(Current, x)"
		local
			a: ARRAY [G]
		do
			if not has (x) then
				create a.make (1, array.count + 1)
				a.subcopy (array, array.lower, array.upper, 1)
				a.put (x, a.count)
				create Result.make_from_array (a)
			else
				Result := Current
			end
		end

	removed (x: G): MML_FINITE_SET[G]
			-- Current set with `x' removed if was present, otherwise current set
		note
			mapped_to: "Set.removed(Current, x)"
		local
			a: ARRAY [G]
			i, j: INTEGER
			found: BOOLEAN
		do
			create a.make (array.lower, array.upper)
			from
				i := array.lower
				j := array.lower
			until
				i > array.upper
			loop
				if model_equals (array[i], x) then
					found := True
				else
					a[j] := array[i]
					j := j + 1
				end
				i := i + 1
			end
			if found then
				create Result.make_from_array (a.subarray (a.lower, a.upper - 1))
			else
				create Result.make_from_array (a)
			end
		end

feature -- Status report
	is_finite: BOOLEAN = True
			-- Is the set finite?

	is_empty: BOOLEAN
			-- Is the set empty?
		do
			Result := array.is_empty
		end

	is_integer_set: BOOLEAN
			-- Is Current a set of integers?
		do
			Result := attached {MML_FINITE_SET [INTEGER]} Current
		end

	is_interval: BOOLEAN
			-- Is Current an integer interval?
		do
			if is_integer_set then
				Result := as_integer_set.is_interval
			end
		end

feature -- Conversion
	as_finite: MML_FINITE_SET [G]
			-- Current set
		do
			Result := Current
		end

	as_integer_set: MML_INTEGER_SET
			-- Current set if it is integer set
		do
			if integer_set_cache = Void then
				if attached {MML_FINITE_SET [INTEGER]} Current as int_set then
					create integer_set_cache.make_from_array (int_set.array)
				end
			end
			Result := integer_set_cache
		end

feature -- Basic operations
	intersection alias "*" (other: MML_SET [G]): MML_FINITE_SET [G]
			-- Set that consists of values contained in both `Current' and `other'
		local
			a: ARRAY [G]
			i, j: INTEGER
		do
			create a.make (array.lower, array.upper)
			from
				i := array.lower
				j := a.lower
			until
				i > array.upper
			loop
				if other.has (array [i]) then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			create Result.make_from_array (a.subarray (a.lower, j - 1))
		end

	difference alias "-" (other: MML_SET [G]): MML_FINITE_SET [G]
			-- Set that consists of values of `Current' that are not in `other'
		local
			a: ARRAY [G]
			i, j: INTEGER
		do
			create a.make (array.lower, array.upper)
			from
				i := array.lower
				j := a.lower
			until
				i > array.upper
			loop
				if not other.has (array [i]) then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			create Result.make_from_array (a.subarray (a.lower, j - 1))
		end

feature -- Quantification
	for_all (test: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Does `test' hold for all elements?
		local
			i: INTEGER
		do
			from
				Result := True
				i := array.lower
			until
				i > array.upper or not Result
			loop
				Result := test.item ([array[i]])
				i := i + 1
			end
		ensure
			definition: Result = (intersection (create {MML_AGENT_SET [G]}.such_that (test)).count = count)
		end

	exists (test: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Does `test' hold for all elements?
		local
			i: INTEGER
		do
			from
				i := array.lower
			until
				i > array.upper or Result
			loop
				Result := test.item ([array[i]])
				i := i + 1
			end
		ensure
			definition: Result = not intersection (create {MML_AGENT_SET [G]}.such_that (test)).is_empty
		end

feature {MML_MODEL} -- Implementation
	array: ARRAY [G]

	make_from_array (a: ARRAY [G])
			-- Create with a predefined array
		do
			array := a
		end

	integer_set_cache: MML_INTEGER_SET

invariant
	is_interval implies is_integer_set
end
