note
	description: "Finite bags."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_FINITE_BAG [G]

inherit
	MML_MODEL

create
	empty

create {MML_MODEL}
	make_from_arrays

feature -- Access
	domain: MML_FINITE_SET [G]
			-- Set of values that occure at leat once
		do
			create Result.make_from_array (keys)
		end

	occurrences alias "[]" (x: G): INTEGER
			-- How many times `v' appears
		local
			i: INTEGER
		do
			i := index_of (x)
			if keys.valid_index (i) then
				Result := values [i]
			end
		end

	count: INTEGER
			-- Total number of elements
--		local
--			i: INTEGER
--		do
--			from
--				i := values.lower
--			until
--				i > values.upper
--			loop
--				Result := Result + values [i]
--				i := i + 1
--			end
--		end

feature -- Status report
	is_empty: BOOLEAN
			-- Is bag empty?
		do
			Result := keys.is_empty
		end

	is_constant (c: INTEGER): BOOLEAN
			-- Are all values equal to `c'?
		local
			i: INTEGER
		do
			from
				Result := True
				i := values.lower
			until
				i > values.upper or not Result
			loop
				Result := values [i] = c
				i := i + 1
			end
		end

feature {NONE} -- Initialization
	empty
			-- Create an empty bag
		do
			create keys.make (1, 0)
			create values.make (1, 0)
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is `Current' mathematically equal to `other'?		
		local
			i: INTEGER
		do
			if attached {MML_FINITE_BAG [G]} other as bag and then domain |=| bag.domain then
				from
					Result := True
					i := keys.lower
				until
					i > keys.upper or not Result
				loop
					Result := model_equals (values [i], bag[keys [i]])
					i := i + 1
				end
			end
		end

feature -- Basic operations
	extended (x: G): MML_FINITE_BAG [G]
			-- Current bag extended with one occurrence of `x'
		local
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
			i: INTEGER
		do
			i := index_of (x)
			if keys.valid_index (i) then
				ks := keys
				vs := values.twin
				vs [i] := vs [i] + 1
			else
				create ks.make (keys.lower, keys.upper + 1)
				ks.subcopy (keys, keys.lower, keys.upper, keys.lower)
				ks.put (x, ks.upper)
				create vs.make (values.lower, values.upper + 1)
				vs.subcopy (values, values.lower, values.upper, values.lower)
				vs.put (1, vs.upper)
			end
			create Result.make_from_arrays (ks, vs, count + 1)
		end

	removed (x: G): MML_FINITE_BAG [G]
			-- Current bag with one occurrence of `x' removed
		require
			has: domain.has (x)
		local
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
			i: INTEGER
		do
			i := index_of (x)
			if values [i] = 1 then
				create ks.make (keys.lower, keys.upper - 1)
				ks.subcopy (keys, keys.lower, i - 1, keys.lower)
				ks.subcopy (keys, i + 1, keys.upper, i)
				create vs.make (values.lower, values.upper - 1)
				vs.subcopy (values, values.lower, i - 1, values.lower)
				vs.subcopy (values, i + 1, values.upper, i)
			else
				ks := keys
				vs := values.twin
				vs [i] := vs [i] - 1
			end
			create Result.make_from_arrays (ks, vs, count - 1)
		end

	removed_all (x: G): MML_FINITE_BAG [G]
			-- Current bag with all occurrences of `x' removed, if contained
			-- Otherwiese current bag
		local
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
			i: INTEGER
		do
			i := index_of (x)
			if keys.valid_index (i) then
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

	restricted (subdomain: MML_SET [G]): MML_FINITE_BAG [G]
			-- This bag with all elements outside `restriction' removed
		local
			i, j: INTEGER
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
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
			create Result.make_from_arrays (ks.subarray (ks.lower, j - 1), vs.subarray (vs.lower, j - 1), n)
		end

feature {NONE} -- Implementation
	keys: ARRAY [G]
	values: ARRAY [INTEGER]

	make_from_arrays (ks: ARRAY [G]; vs: ARRAY [INTEGER]; n: INTEGER)
			-- Create with a predefined array
		do
			keys := ks
			values := vs
			count := n
		end

	index_of (x: G): INTEGER
			-- Index of `x' in `keys' if contained
			-- otherwise `keys.upper + 1'
		local
			found: BOOLEAN
		do
			from
				Result := keys.lower
			until
				Result > keys.upper or found
			loop
				if model_equals (keys[Result], x) then
					found := True
				else
					Result := Result + 1
				end
			end
		end
end
