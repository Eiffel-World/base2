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
			extended,
			removed
		end

	MML_FINITE

create
	empty,
	singleton

create {MML_MODEL}
	make_from_array

convert
	singleton ({G})

feature {NONE} -- Initialization
	empty
			-- Create an empty set.
		do
			create array.make (1, 0)
		end

	singleton (x: G)
			-- Create a set that contains only `x'.
		do
			create array.make (1, 1)
			array [1] := x
		end

feature -- Access
	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained?
		local
			i: INTEGER
		do
			-- Workaround: cannot use `exists' because of agent typing issues
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
			-- Cardinality.
		do
			Result := array.count
		end

	any_item: G
			-- Arbitrary element.
		require
			not_empty: not is_empty
		do
			if not is_empty then
				-- Workaround for semistrict postconditions
				Result := array [array.lower]
			end
		end

	lower: INTEGER
			-- Minimum item.
		require
			is_integer_set: is_integer_set
			not_empty: not is_empty
		do
			Result := as_integer_set.lower
		end

	upper: INTEGER
			-- Maximum item.
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
		do
			if attached {MML_FINITE_SET[G]} other as set and then count = set.count then
				Result := array.for_all (agent set.has)
			end
		end

feature -- Element change
	extended (x: G): MML_FINITE_SET[G]
			-- Current set extended with `x' if absent.
		local
			a: V_ARRAY [G]
		do
			if not Current [x] then
				create a.make (1, array.count + 1)
				a.subcopy (array, array.lower, array.upper, 1)
				a [a.count] := x
				create Result.make_from_array (a)
			else
				Result := Current
			end
		end

	removed (x: G): MML_FINITE_SET[G]
			-- Current set with `x' removed if present.
		local
			a: V_ARRAY [G]
			i, j: INTEGER
		do
			create a.make (array.lower, array.upper)
			from
				i := array.lower
				j := array.lower
			until
				i > array.upper
			loop
				if not model_equals (array [i], x) then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			if j /= i then
				a.resize (a.lower, a.upper - 1)
			end
			create Result.make_from_array (a)
		end

feature -- Status report
	is_empty: BOOLEAN
			-- Is the set empty?
		do
			Result := array.is_empty
		end

	is_integer_set: BOOLEAN
			-- Is current set a set of integers?
		do
			Result := attached {MML_FINITE_SET [INTEGER]} Current
		end

	is_interval: BOOLEAN
			-- Is current set an integer interval?
		do
			if is_integer_set then
				Result := as_integer_set.is_interval
			end
		end

feature -- Conversion
	as_integer_set: MML_INTEGER_SET
			-- Current set if `is_integer_set'; Void otherwise.
		do
			if integer_set_cache = Void then
				if attached {MML_FINITE_SET [INTEGER]} Current as int_set then
					create integer_set_cache.make_from_array (int_set.array)
				end
			end
			Result := integer_set_cache
		end

feature -- Basic operations
	union alias "+" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other'.
		do
			if attached {MML_FINITE_SET [G]} other as finite then
				Result := Current |+| finite
			else
				Result := other + Current
			end
		end

	finite_union alias "|+|" (other: MML_FINITE_SET [G]): MML_FINITE_SET [G]
			-- Set of values contained in either `Current' or `other'.
		do
			Result := Current - other
			Result.array.resize (Result.array.lower, Result.array.upper + other.array.count)
			Result.array.subcopy (other.array, other.array.lower, other.array.upper, count - other.count + 1)
		end

	intersection alias "*" (other: MML_SET [G]): MML_FINITE_SET [G]
			-- Set of values contained in both `Current' and `other'.
		local
			a: V_ARRAY [G]
			i, j: INTEGER
		do
			create a.make (array.lower, array.upper)
			from
				i := array.lower
				j := a.lower
			until
				i > array.upper
			loop
				if other [array [i]] then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			a.resize (a.lower, j - 1)
			create Result.make_from_array (a)
		end

	difference alias "-" (other: MML_SET [G]): MML_FINITE_SET [G]
			-- Set of values contained in `Current' but not in `other'.
		local
			a: V_ARRAY [G]
			i, j: INTEGER
		do
			create a.make (array.lower, array.upper)
			from
				i := array.lower
				j := a.lower
			until
				i > array.upper
			loop
				if not other [array [i]] then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			a.resize (a.lower, j - 1)
			create Result.make_from_array (a)
		end

	sym_difference alias "^" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other', but not in both.
		do
			if attached {MML_FINITE_SET [G]} other as finite then
				Result := Current |^| finite
			else
				Result := other ^ Current
			end
		end

	finite_sym_difference alias "|^|" (other: MML_FINITE_SET [G]): MML_FINITE_SET [G]
			-- Set of values contained in either `Current' or `other', but not in both.
		do
			Result := (Current |+| other) - (Current * other)
		end

feature -- Quantification
	for_all (test: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Does `test' hold for all elements?
		require
			test_exists: test /= Void
			test_has_one_arg: test.open_count = 1
		do
			Result := array.for_all (test)
		end

	exists (test: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Does `test' hold for at least one element?
		require
			test_exists: test /= Void
			test_has_one_arg: test.open_count = 1
		do
			Result := array.exists (test)
		end

feature {MML_MODEL} -- Implementation
	array: V_ARRAY [G]
			-- Element storage.

	make_from_array (a: V_ARRAY [G])
			-- Create with a predefined array.
		do
			array := a
		end

	integer_set_cache: MML_INTEGER_SET
			-- Current set as integer set.
end
