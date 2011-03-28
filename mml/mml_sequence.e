note
	description: "Finite sequence."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_SEQUENCE [G]

inherit
	MML_MODEL
		redefine
			default_create
		end

create
	default_create,
	singleton

create {MML_MODEL}
	make_from_array

convert
	singleton ({G})

feature {NONE} -- Initialization
	default_create
			-- Create an empty sequence.
		do
			create array.make (1, 0)
		end

	singleton (x: G)
			-- Create a sequence with one element `x'.
		do
			create array.make (1, 1)
			array [1] := x
		end

feature -- Properties
	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := array.exists (agent meq (x, ?))
		end

	is_empty: BOOLEAN
			-- Is the sequence empty?
		do
			Result := array.is_empty
		end

	is_constant (c: G): BOOLEAN
			-- Are all values equal to `c'?
		do
			Result := array.for_all (agent meq (c, ?))
		end

feature -- Elements
	item alias "[]" (i: INTEGER): G
			-- Value at position `i'.
		require
			in_domain: domain [i]
		do
			Result := array [i + array.lower - 1]
		end

feature -- Sets
	domain: MML_INTERVAL
			-- Set of indexes.
		do
			create Result.from_range (1, count)
		end

	range: MML_SET [G]
			-- Set of values.
		local
			i: INTEGER
		do
			create Result
			from
				i := array.lower
			until
				i > array.upper
			loop
				Result := Result & array [i]
				i := i + 1
			end
		end

feature -- Measurement
	count alias "#": INTEGER
			-- Number of elements.
		do
			Result := array.count
		end

	occurrences (x: G): INTEGER
			-- How many times does `x' occur?
		do
			Result := array.count_satisfying (agent meq (x, ?))
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this sequence contain the same elements in the same order as `other'?		
		do
			Result := attached {MML_SEQUENCE [G]} other as sequence and then
				(count = sequence.count and Current <= sequence)
		end

	is_prefix_of alias "<=" (other: MML_SEQUENCE [G]): BOOLEAN
			-- Is this sequence a prefix of `other'?
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

feature -- Decomposition
	first: G
			-- First element.
		require
			non_empty: not is_empty
		do
			Result := item (1)
		end

	last: G
			-- Last element.
		require
			non_empty: not is_empty
		do
			Result := item (count)
		end

	but_first: MML_SEQUENCE [G]
			-- Current sequence without the first element.
		require
			not_empty: not is_empty
		do
			Result := interval (2, count)
		end

	but_last: MML_SEQUENCE [G]
			-- Current sequence without the last element.
		require
			not_empty: not is_empty
		do
			Result := interval (1, count - 1)
		end

	front (upper: INTEGER): MML_SEQUENCE [G]
			-- Prefix up to `upper'.
		do
			Result := interval (1, upper)
		end

	tail (lower: INTEGER): MML_SEQUENCE [G]
			-- Suffix from `lower'.
		do
			Result := interval (lower, count)
		end

	interval (lower, upper: INTEGER): MML_SEQUENCE [G]
			-- Subsequence from `lower' to `upper'.
		local
			l, u: INTEGER
		do
			l := lower.max (1)
			u := upper.min (count).max (l - 1)
			create Result.make_from_array (array.subarray (array.lower + l - 1, array.lower + u - 1))
		end

feature -- Modification
	extended alias "&" (x: G): MML_SEQUENCE [G]
			-- Current sequence extended with `x' at the end.
		local
			a: V_ARRAY [G]
		do
			create a.make (1, array.count + 1)
			a.copy_range (array, array.lower, array.upper, 1)
			a [a.count] := x
			create Result.make_from_array (a)
		end

	prepended (x: G): MML_SEQUENCE [G]
			-- Current sequence prepended with `x' at the beginning.
		local
			a: V_ARRAY [G]
		do
			create a.make (1, array.count + 1)
			a.copy_range (array, array.lower, array.upper, 2)
			a [1] := x
			create Result.make_from_array (a)
		end

	concatenation alias "+" (other: MML_SEQUENCE [G]): MML_SEQUENCE [G]
			-- The concatenation of the current sequence and `other'.
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
				a.copy_range(array, array.lower, array.upper, 1)
				a.copy_range(other.array, other.array.lower, other.array.upper, count + 1)
				create Result.make_from_array (a)
			end
		end

	replaced_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' at position `i'.
		require
			in_domain: domain [i]
		local
			a: V_ARRAY [G]
		do
			a := array.twin
			a [array.lower + i - 1] := x
			create Result.make_from_array (a)
		end

	removed_at (i: INTEGER): MML_SEQUENCE [G]
			-- Current sequence with element at position `i' removed.
		require
			in_domain: domain [i]
		local
			a: V_ARRAY [G]
		do
			create a.make (1, array.count - 1)
			a.copy_range (array, array.lower, array.lower + i - 2, 1)
			a.copy_range (array, array.lower + i, array.upper, i)
			create Result.make_from_array (a)
		end

	inverse: MML_RELATION [G, INTEGER]
			-- Relation of values in current sequence to their indexes.
		do
			create Result.make_from_arrays (array, domain.array)
		end

feature {MML_MODEL} -- Implementation
	array: V_ARRAY [G]
			-- Element storage.

	make_from_array (a: V_ARRAY [G])
			-- Create with a predefined array.
		require
			a_exists: a /= Void
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

