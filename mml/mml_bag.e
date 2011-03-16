note
	description: "Finite bags."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_BAG [G]

inherit
	MML_MODEL

inherit {NONE}
	V_EQUALITY [INTEGER]
		export {NONE}
			all
		end

create
	empty,
	singleton

create {MML_MODEL}
	make_from_arrays

feature {NONE} -- Initialization
	empty
			-- Create an empty bag.
		do
			create keys.make (1, 0)
			create values.make (1, 0)
		end

	singleton (x: G)
			-- Create a bag that contains a single occurrence of `x'.
		do
			multiple (x, 1)
		end

	multiple (x: G; n: INTEGER)
			-- Create a bag that contains `n' occurrences of `x'.
		do
			create keys.make (1, 1)
			keys [1] := x
			create values.make (1, 1)
			values [1] := n
			count := n
		end

feature -- Properties
	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := occurrences (x) > 0
		end

	is_empty: BOOLEAN
			-- Is bag empty?
		do
			Result := keys.is_empty
		end

	is_constant (c: INTEGER): BOOLEAN
			-- Are all values equal to `c'?
		do
			Result := values.for_all (agent reference_equal (c, ?))
		end

feature -- Sets
	domain: MML_SET [G]
			-- Set of values that occur at least once.
		do
			create Result.make_from_array (keys)
		end

feature -- Measurement
	occurrences alias "[]" (x: G): INTEGER
			-- How many times `v' appears.
		local
			i: INTEGER
		do
			i := keys.index_that (agent meq (x, ?))
			if keys.has_index (i) then
				Result := values [i]
			end
		end

	count: INTEGER
			-- Total number of elements.

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this bag contain the same elements the same number of times as `other'?		
		local
			i: INTEGER
		do
			if attached {MML_BAG [G]} other as bag and then domain |=| bag.domain then
				from
					Result := True
					i := keys.lower
				until
					i > keys.upper or not Result
				loop
					Result := model_equals (values [i], bag [keys [i]])
					i := i + 1
				end
			end
		end

feature -- Modification
	extended (x: G): MML_BAG [G]
			-- Current bag extended with one occurrence of `x'.
		do
			Result := extended_multiple (x, 1)
		end

	extended_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag extended with `n' occurrences of `x'.
		local
			ks: V_ARRAY [G]
			vs: V_ARRAY [INTEGER]
			i: INTEGER
		do
			i := keys.index_that (agent meq (x, ?))
			if keys.has_index (i) then
				ks := keys
				vs := values.twin
				vs [i] := vs [i] + n
			else
				create ks.make (keys.lower, keys.upper + 1)
				ks.subcopy (keys, keys.lower, keys.upper, keys.lower)
				ks [ks.upper] := x
				create vs.make (values.lower, values.upper + 1)
				vs [vs.upper] := n
				vs.subcopy (values, values.lower, values.upper, values.lower)
			end
			create Result.make_from_arrays (ks, vs, count + n)
		end

	removed (x: G): MML_BAG [G]
			-- Current bag with one occurrence of `x' removed.
		require
			has: domain [x]
		do
			Result := removed_multiple (x, 1)
		end

	removed_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag with `n' occurrences of `x' removed.
		require
			has_n: occurrences (x) >= n
		local
			ks: V_ARRAY [G]
			vs: V_ARRAY [INTEGER]
			i: INTEGER
		do
			i := keys.index_that (agent meq (x, ?))
			if values [i] = n then
				create ks.make (keys.lower, keys.upper - 1)
				ks.subcopy (keys, keys.lower, i - 1, keys.lower)
				ks.subcopy (keys, i + 1, keys.upper, i)
				create vs.make (values.lower, values.upper - 1)
				vs.subcopy (values, values.lower, i - 1, values.lower)
				vs.subcopy (values, i + 1, values.upper, i)
			else
				ks := keys
				vs := values.twin
				vs [i] := vs [i] - n
			end
			create Result.make_from_arrays (ks, vs, count - n)
		end

	removed_all (x: G): MML_BAG [G]
			-- Current bag with all occurrences of `x' removed, if contained.
			-- Otherwise current bag.
		local
			ks: V_ARRAY [G]
			vs: V_ARRAY [INTEGER]
			i: INTEGER
		do
			i := keys.index_that (agent meq (x, ?))
			if keys.has_index (i) then
				create ks.make (keys.lower, keys.upper - 1)
				ks.subcopy (keys, keys.lower, i - 1, keys.lower)
				ks.subcopy (keys, i + 1, keys.upper, i)
				create vs.make (values.lower, values.upper - 1)
				vs.subcopy (values, values.lower, i - 1, values.lower)
				vs.subcopy (values, i + 1, values.upper, i)
				create Result.make_from_arrays (ks, vs, count - values [i])
			else
				Result := Current
			end
		end

	restricted alias "|" (subdomain: MML_SET [G]): MML_BAG [G]
			-- This bag with all elements outside `restriction' removed.
		require
			subdomain_exists: subdomain /= Void
		local
			i, j: INTEGER
			ks: V_ARRAY [G]
			vs: V_ARRAY [INTEGER]
			n: INTEGER
		do
			create ks.make (keys.lower, keys.upper)
			create vs.make (values.lower, values.upper)
			from
				i := keys.lower
				j := ks.lower
			until
				i > keys.upper
			loop
				if subdomain [keys [i]] then
					ks [j] := keys [i]
					vs [j] := values [i]
					n := n + values [i]
					j := j + 1
				end
				i := i + 1
			end
			ks.resize (ks.lower, j - 1)
			vs.resize (vs.lower, j - 1)
			create Result.make_from_arrays (ks, vs, n)
		end

	union alias "+" (other: MML_BAG [G]): MML_BAG [G]
			-- Bag that contains all elements from `other' and `Current'.
		local
			i, j, k: INTEGER
			ks: V_ARRAY [G]
			vs: V_ARRAY [INTEGER]
		do
			create ks.make (1, keys.count + other.keys.count)
			create vs.make (1, values.count + other.values.count)
			ks.subcopy (keys, keys.lower, keys.upper, 1)
			vs.subcopy (values, values.lower, values.upper, 1)
			from
				i := other.keys.lower
				j := keys.count + 1
			until
				i > other.keys.upper
			loop
				k := keys.index_that (agent meq (other.keys [i], ?))
				if keys.has_index (k) then
					vs [k] := vs [k] + other.values [i]
				else
					ks [j] := other.keys [i]
					vs [j] := other.values [i]
					j := j + 1
				end
				i := i + 1
			end
			ks.resize (ks.lower, j - 1)
			vs.resize (vs.lower, j - 1)
			create Result.make_from_arrays (ks, vs, count + other.count)
		end

	difference alias "-" (other: MML_BAG [G]): MML_BAG[G]
			-- Current bag with all occurrences of values from `other' removed.
		local
			i, j, k, c: INTEGER
			ks: V_ARRAY [G]
			vs: V_ARRAY [INTEGER]
		do
			create ks.make (1, keys.count)
			create vs.make (1, values.count)
			from
				i := keys.lower
				j := keys.lower
			until
				i > keys.upper
			loop
				k := other [keys [i]]
				if k < values [i] then
					ks [j] := keys [i]
					vs [j] := values [i] - k
					c := c + vs [j]
					j := j + 1
				end
				i := i + 1
			end
			ks.resize (ks.lower, j - 1)
			vs.resize (vs.lower, j - 1)
			create Result.make_from_arrays (ks, vs, c)
		end
feature {MML_MODEL} -- Implementation
	keys: V_ARRAY [G]
			-- Element storage.

	values: V_ARRAY [INTEGER]
			-- Occurrences storage.

	make_from_arrays (ks: V_ARRAY [G]; vs: V_ARRAY [INTEGER]; n: INTEGER)
			-- Create with predefined arrays and count.
		do
			keys := ks
			values := vs
			count := n
		end

	meq (v1, v2: G): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end
end
