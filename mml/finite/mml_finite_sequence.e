note
	description: "Finite sequence."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	mapped_to: "Sequence G"

class
	MML_FINITE_SEQUENCE [G]

inherit
	MML_SEQUENCE [G]

create
	empty,
	singleton

create {MML_MODEL}
	make_from_array

feature -- Access
	item alias "[]" (i: INTEGER): G
			-- Item that corresponds to `k'
		note
			mapped_to: "Current[i]"
		do
			Result := array [i + array.lower - 1]
		end

	count: INTEGER
			-- Number of elements
		note
			mapped_to: "Sequence.count(Current)"
		do
			Result := array.count
		end

	domain: MML_INTEGER_SET
			-- Domain of the sequence
		note
			mapped_to: "Sequence.domain(Current)"
		do
			create Result.from_range (1, count)
		end

	range: MML_FINITE_SET [G]
			-- Set of values
		local
			i: INTEGER
		do
			create Result.empty
			from
				i := array.lower
			until
				i > array.upper
			loop
				Result := Result.extended (array [i])
				i := i + 1
			end
		end

	has (x: G): BOOLEAN
			-- Does sequence contain `x'?
		local
			i: INTEGER
		do
			from
				i := array.lower
			until
				i > array.upper or Result
			loop
				Result := model_equals (array [i], x)
				i := i + 1
			end
		end

	occurrences (x: G): INTEGER
			-- How many times `x' occur?
		local
			i: INTEGER
		do
			from
				i := array.lower
			until
				i > array.upper
			loop
				if model_equals (array [i], x) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Search
	first_index_of (x: G): INTEGER
			-- Index of the first occurrence of `x'
		local
			i: INTEGER
		do
			from
				i := array.lower
			until
				i > array.upper or Result > 0
			loop
				if model_equals (array [i], x) then
					Result := i
				end
				i := i + 1
			end
		end

	last_index_of (x: G): INTEGER
			-- Index of the last occurrence of `x'
		local
			i: INTEGER
		do
			from
				i := array.upper
			until
				i < array.lower or Result > 0
			loop
				if model_equals (array [i], x) then
					Result := i
				end
				i := i - 1
			end
		end

feature -- Decomposition
	last: G
			-- The last element of `current'.
		require
			non_empty: not is_empty
		do
			Result := array [array.upper]
		end

	but_first: like Current
			-- The elements of `current' except for the first one.
		do
			Result := interval (2, count)
		end

	but_last: like Current
			-- The elements of `current' except for the last one.
		require
			not_empty: not is_empty
		do
			Result := interval (1, count - 1)
		end

	tail (lower: INTEGER): like Current
			-- Suffix from `lower'.
		do
			Result := interval (lower, count)
		end

	interval (lower, upper: INTEGER): like Current
			-- Subsequence from `lower' to `upper'.
		local
			l, u: INTEGER
		do
			l := lower.max (1)
			u := upper.min (count).max (l - 1)
			create Result.make_from_array (array.subarray (array.lower + l - 1, array.lower + u - 1))
		end

feature -- Status report
	is_constant (c: G): BOOLEAN
			-- Are all values equal to `c'?
		local
			i: INTEGER
		do
			from
				Result := True
				i := array.lower
			until
				i > array.upper or not Result
			loop
				Result := model_equals (array [i], c)
				i := i + 1
			end
		end

	is_empty: BOOLEAN
			-- Is sequence empty?
		do
			Result := array.is_empty
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is `Current' mathematically equal to `other'?		
		note
			mapped_to: "Current == other"
		local
			i: INTEGER
		do
			if attached {MML_FINITE_SEQUENCE [G]} other as sequence and then count = sequence.count then
				from
					Result := True
					i := 1
				until
					i > count or not Result
				loop
					Result := model_equals (item (i), sequence.item (i))
					i := i + 1
				end
			end
		end

	is_prefix_of (other: MML_FINITE_SEQUENCE [G]): BOOLEAN
			-- Is `Current' a prefix of `other'?
		require
			other_exists: other /= Void
		local
			i: INTEGER
		do
			Result := count <= other.count
			from
				i := 1
			until
				i > count or not Result
			loop
				Result := model_equals (item (i), other.item (i))
				i := i + 1
			end
		end

feature {NONE} -- Initialization
	empty
			-- Create empty sequence
		note
			mapped_to: "Sequence.empty"
		do
			create array.make (1, 0)
		end

	singleton (x: G)
			-- Create sequence with one element
		do
			create array.make (1, 1)
			array [1] := x
		end

feature -- Element change
	extended (x: G): like Current
			-- Current sequence extended with `x' at the end
		note
			mapped_to: "Sequence.extended(Current, x)"
		local
			a: V_ARRAY [G]
		do
			create a.make (1, array.count + 1)
			a.subcopy (array, array.lower, array.upper, 1)
			a [a.count] := x
			create Result.make_from_array (a)
		end

	prepended (x: G): like Current
			-- Current sequence prepended with `x' at the beginning
		local
			a: V_ARRAY [G]
		do
			create a.make (1, array.count + 1)
			a.subcopy (array, array.lower, array.upper, 2)
			a [1] := x
			create Result.make_from_array (a)
		end

	concatenation alias "+" (other : MML_FINITE_SEQUENCE[G]): like Current
			-- The concatenation of `current' and `other'.
		require
			other_exists: other /= Void
		local
			a: V_ARRAY[G]
		do
			if is_empty then
				Result := other
			elseif other.is_empty then
				Result := Current
			else
				create a.make (1, count + other.count)
				a.subcopy(array, array.lower, array.upper, 1)
				a.subcopy(other.array, other.array.lower, other.array.upper, count + 1)
				create Result.make_from_array (a)
			end
		end

	infinite_concatenation alias "|+|" (other : MML_SEQUENCE[G]): MML_SEQUENCE [G]
			-- The concatenation of `current' and `other'.
		require
			other_exists: other /= Void
		do
			if attached {MML_FINITE_SEQUENCE [G]} other as sequence then
				Result := Current + sequence
			end
		end

	replaced_at (i: INTEGER; x: G): like Current
			-- Current sequence with `x' at position `i'
		note
			mapped_to: "Sequence.replaced_at(Current, i, x)"
		local
			a: V_ARRAY [G]
		do
			a := array.twin
			a [i] := x
			create Result.make_from_array (a)
		end

	removed_at (i: INTEGER): like Current
			-- Current sequence with element at position `i' removed
		local
			a: V_ARRAY [G]
		do
			create a.make (1, array.count - 1)
			a.subcopy (array, 1, i - 1, 1)
			a.subcopy (array, i + 1, array.count, i)
			create Result.make_from_array (a)
		end

feature {MML_MODEL} -- Implementation
	array: V_ARRAY [G]

	make_from_array (a: V_ARRAY [G])
			-- Create with a predefined array
		do
			array := a
		end
end

