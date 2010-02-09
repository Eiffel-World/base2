note
	description: "Finite maps."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_FINITE_MAP [K, G]

inherit
	MML_MAP [K, G]

create
	empty

create {MML_MODEL}
	make_from_arrays

feature -- Access
	domain: MML_FINITE_SET [K]
			-- Set of keys
		note
			mapped_to: "Map.domain(Current)"
		do
			create Result.make_from_array (keys)
		end

	range: MML_FINITE_SET [G]
			-- Set of values
		local
			i: INTEGER
		do
			create Result.empty
			from
				i := values.lower
			until
				i > values.upper
			loop
				Result := Result.extended (values [i])
				i := i + 1
			end
		end

	count: INTEGER
			-- Map cardinality
		note
			mapped_to: "Map.count(Current)"
		do
			Result := keys.count
		end

	item alias "[]" (k: K): G
			-- Value associated with `k'
		note
			mapped_to: "Current[k]"
		local
			i: INTEGER
			found: BOOLEAN
		do
			from
				i := keys.lower
			until
				i > keys.upper or found
			loop
				if model_equals (keys [i], k) then
					found := True
					Result := values [i]
				end
				i := i + 1
			end
		end

	has (x: G): BOOLEAN
			-- Is `x' contained in the map?
		local
			i: INTEGER
		do
			from
				i := values.lower
			until
				i > values.upper or Result
			loop
				Result := model_equals (x, values[i])
				i := i + 1
			end
		end

--	preimage_of (x: G): MML_FINITE_SET [K]
--			-- Set of keys associated with `x'
--		local
--			i: INTEGER
--		do
--			create Result.empty
--			from
--				i := values.lower
--			until
--				i > values.upper
--			loop
--				if model_equals (values [i], x) then
--					Result := Result.extended (keys [i])
--				end
--				i := i + 1
--			end
--		end

--	preimage (subrange: MML_SET [G]): MML_FINITE_SET [K]
--			-- Set of keys, for which associated values are from `subrange'
--		local
--			i: INTEGER
--		do
--			create Result.empty
--			from
--				i := values.lower
--			until
--				i > values.upper
--			loop
--				if subrange [values [i]] then
--					Result := Result.extended (keys [i])
--				end
--				i := i + 1
--			end
--		end

feature -- Status report
	is_empty: BOOLEAN
			-- Is map empty?
		do
			Result := keys.is_empty
		end

	is_constant (c: G): BOOLEAN
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
				Result := model_equals (values [i], c)
				i := i + 1
			end
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is `Current' mathematically equal to `other'?		
		note
			mapped_to: "Current == other"
		local
			i: INTEGER
		do
			if attached {MML_MAP [K, G]} other as map and then domain |=| map.domain then
				from
					Result := True
					i := keys.lower
				until
					i > keys.upper or not Result
				loop
					Result := model_equals (values [i], map[keys [i]])
					i := i + 1
				end
			end
		end

feature {NONE} -- Initialization
	empty
			-- Create an empty map
		note
			mapped_to: "Map.empty"
		do
			create keys.make (1, 0)
			create values.make (1, 0)
		end

feature --Basic operations
	restricted alias "|" (subdomain: MML_SET [K]): MML_FINITE_MAP [K, G]
			-- This map with all key-value pairs where key is outside `restriction' removed
		local
			i, j: INTEGER
			ks: ARRAY [K]
			vs: ARRAY [G]
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
					j := j + 1
				end
				i := i + 1
			end
			create Result.make_from_arrays (ks.subarray (ks.lower, j - 1), vs.subarray (vs.lower, j - 1))
		end

	inverse: MML_FINITE_RELATION [G, K]
			-- Relation consisting of inverted pairs from `Current'
		do
			create Result.make_from_arrays (values, keys)
		end

feature -- Element change
	extended (k: K; x: G): MML_FINITE_MAP[K, G]
			-- Current map extended with the pair (`k', `x')
		note
			mapped_to: "Map.extended(Current, k, x)"
		require
			fresh_key: not domain.has (k)
		local
			ks: ARRAY [K]
			vs: ARRAY [G]
		do
			create ks.make (keys.lower, keys.upper + 1)
			ks.subcopy (keys, keys.lower, keys.upper, keys.lower)
			ks.put (k, ks.upper)
			create vs.make (values.lower, values.upper + 1)
			vs.subcopy (values, values.lower, values.upper, values.lower)
			vs.put (x, vs.upper)
			create Result.make_from_arrays (ks, vs)
		end

	removed (k: K): MML_FINITE_MAP[K, G]
			-- Current map without the key `k' and the corresponding value
		note
			mapped_to: "Map.removed(Current, k)"
		require
			has_key: domain.has (k)
		local
			ks: ARRAY [K]
			vs: ARRAY [G]
			i, j: INTEGER
		do
			create ks.make (keys.lower, keys.upper - 1)
			create vs.make (values.lower, values.upper - 1)
			from
				i := keys.lower
				j := keys.lower
			until
				i > keys.upper
			loop
				if not model_equals (keys[i], k)  then
					ks[j] := keys[i]
					vs[j] := values[i]
					j := j + 1
				end
				i := i + 1
			end
			create Result.make_from_arrays (ks, vs)
		end

feature -- Replacement
	replaced_at (k: K; x: G): MML_FINITE_MAP [K, G]
			-- Current map with the value associated with `k' replaced by `x'
		local
			i: INTEGER
			found: BOOLEAN
			vs: ARRAY [G]
		do
			vs := values.twin
			from
				i := keys.lower
			until
				i > keys.upper or found
			loop
				if model_equals (keys [i], k) then
					found := True
					vs [i] := x
				end
				i := i + 1
			end
			create Result.make_from_arrays (keys, vs)
		end

--feature -- Iteration
--	for_all (test: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--			-- Does `test' hold for all values?
--		local
--			i: INTEGER
--		do
--			from
--				Result := True
--				i := values.lower
--			until
--				i > values.upper or not Result
--			loop
--				Result := test.item ([values[i]])
--				i := i + 1
--			end
--		end

feature {NONE} -- Implementation
	keys: ARRAY [K]
	values: ARRAY [G]

	make_from_arrays (ks: ARRAY [K]; vs: ARRAY [G])
			-- Create with a predefined array
		do
			keys := ks
			values := vs
		end

end
