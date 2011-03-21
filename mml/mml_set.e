note
	description: "Finite sets."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_SET [G]

inherit
	MML_MODEL

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

feature -- Properties
	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := array.exists (agent meq (x, ?))
		end

	is_empty: BOOLEAN
			-- Is the set empty?
		do
			Result := array.is_empty
		end

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

feature -- Elements
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

	extremum (order: PREDICATE [ANY, TUPLE [G, G]]): G
			-- Least element with respect to `order'.
		require
			not_empty: not is_empty
			order_exists: order /= Void
			order_has_one_arg: order.open_count = 2
			--- transitive: forall x, y, z: G :: order (x, y) and order (y, z) implies order (x, z)
			--- total: forall x, y: G :: order (x, y) or order (y, x)
		local
			i: INTEGER
		do
			from
				Result := array.first
				i := array.lower + 1
			until
				i > array.upper
			loop
				if order.item ([array [i], Result]) then
					Result := array [i]
				end
				i := i + 1
			end
		ensure
			definition: has (Result) and for_all (agent (x, y: G; o: PREDICATE [ANY, TUPLE [G, G]]): BOOLEAN
				do
					Result := o.item ([x, y])
				end (Result, ?, order))
		end

feature -- Subsets
	filtered alias "|" (test: PREDICATE [ANY, TUPLE [G]]): MML_SET [G]
			-- Set of all elements that satisfy `test'.
		require
			test_exists: test /= Void
			test_has_one_arg: test.open_count = 1
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
				if test.item ([array [i]]) then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			a.resize (a.lower, j - 1)
			create Result.make_from_array (a)
		end

feature -- Measurement
	count: INTEGER
			-- Cardinality.
		do
			Result := array.count
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this set contain same elements as `other'?
		do
			Result := attached {MML_SET[G]} other as set and then
				(count = set.count and is_subset_of (set))
		end

	is_subset_of (other: MML_SET [G]): BOOLEAN
			-- Does `other' have all elements of `Current'?
		require
			other_exists: other /= Void
		do
			Result := for_all (agent other.has)
		end

	is_superset_of (other: MML_SET [G]): BOOLEAN
			-- Does `Current' have all elements of `other'?
		require
			other_exists: other /= Void
		do
			Result := other.is_subset_of (Current)
		end

	disjoint (other: MML_SET [G]): BOOLEAN
			-- Do no elements of `other' occur in `Current'?
		require
			other_exists: other /= Void
		do
			Result := not other.exists (agent has)
		end

feature -- Modification
	extended (x: G): MML_SET [G]
			-- Current set extended with `x' if absent.
		local
			a: V_ARRAY [G]
		do
			if not Current [x] then
				create a.make (1, array.count + 1)
				a.copy_range (array, array.lower, array.upper, 1)
				a [a.count] := x
				create Result.make_from_array (a)
			else
				Result := Current
			end
		end

	removed (x: G): MML_SET [G]
			-- Current set with `x' removed if present.
		local
			a: V_ARRAY [G]
			i: INTEGER
		do
			i := array.index_satisfying (agent meq (x, ?))
			if array.has_index (i) then
				create a.make (array.lower, array.upper - 1)
				a.copy_range (array, array.lower, i - 1, a.lower)
				a.copy_range (array, i + 1, array.upper, i)
				create Result.make_from_array (a)
			else
				Result := Current
			end
		end

	union alias "+" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other'.
		require
			other_exists: other /= Void
		do
			Result := Current - other
			Result.array.resize (Result.array.lower, Result.array.upper + other.array.count)
			Result.array.copy_range (other.array, other.array.lower, other.array.upper, Result.count - other.count + 1)
		end

	intersection alias "*" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in both `Current' and `other'.
		require
			other_exists: other /= Void
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

	difference alias "-" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in `Current' but not in `other'.
		require
			other_exists: other /= Void
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
		require
			other_exists: other /= Void
		do
			Result := (Current + other) - (Current * other)
		end

feature {MML_MODEL} -- Implementation
	array: V_ARRAY [G]
			-- Element storage.

	make_from_array (a: V_ARRAY [G])
			-- Create with a predefined array.
		require
			a_exists: a /= Void
			no_duplicates: a.bag.is_constant (1)
		do
			array := a
		end

	meq (v1, v2: G): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end

invariant
	array_exists: array /= Void
end
