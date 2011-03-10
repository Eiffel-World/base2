note
	description: "Finite maps."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_MAP [K, V]

inherit
	MML_MODEL

create
	empty,
	singleton

create {MML_MODEL}
	make_from_arrays

feature {NONE} -- Initialization
	empty
			-- Create an empty map.
		do
			create keys.make (1, 0)
			create values.make (1, 0)
		end

	singleton (k: K; x: V)
			-- Create a map with just one key-value pair <`k', `x'>.
		do
			create keys.make (1, 1)
			keys [1] := k
			create values.make (1, 1)
			values [1] := x
		end

feature -- Properties
	has (x: V): BOOLEAN
			-- Is value `x' contained?
		do
			Result := values.exists (agent meq_value (x, ?))
		end

	is_empty: BOOLEAN
			-- Is map empty?
		do
			Result := keys.is_empty
		end

	is_constant (c: V): BOOLEAN
			-- Are all values equal to `c'?
		do
			Result := values.for_all (agent meq_value (c, ?))
		end

feature -- Elements
	item alias "[]" (k: K): V
			-- Value associated with `k'.
		require
			in_domain: domain [k]
		local
			i: INTEGER
		do
			i := keys.index_that (agent meq_key (k, ?))
			if keys.has_index (i) then
				Result := values [i]
			end
		end

feature -- Sets
	domain: MML_SET [K]
			-- Set of keys.
		do
			create Result.make_from_array (keys)
		end

	range: MML_SET [V]
			-- Set of values.
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

	image (subdomain: MML_SET [K]): MML_SET [V]
			-- Set of values corresponding to keys in `subdomain'.
		require
			subdomain_exists: subdomain /= Void
		do
			Result := restricted (subdomain).range
		end

	sequence_image (s: MML_SEQUENCE [K]): MML_SEQUENCE [V]
			-- Sequence of images of `s' elements under `Current'.
		require
			sequence_exists: s /= Void
		local
			i: INTEGER
			a: V_ARRAY [V]
		do
			create a.make (1, s.count)
			from
				i := 1
			until
				i > s.count
			loop
				a [i] := item (s [i])
				i := i + 1
			end
			create Result.make_from_array (a)
		end

feature -- Measurement
	count: INTEGER
			-- Map cardinality.
		do
			Result := keys.count
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this map contain the same key-value pairs as `other'?		
		local
			i: INTEGER
		do
			if attached {MML_MAP [K, V]} other as map and then domain |=| map.domain then
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

feature -- Modification
	updated (k: K; x: V): MML_MAP [K, V]
			-- Current map with `x' associated with `k'.
			-- If `k' already exists, the value is replaced, otherwise added.
		local
			i: INTEGER
			ks: V_ARRAY [K]
			vs: V_ARRAY [V]
		do
			i := keys.index_that (agent meq_key (k, ?))
			if keys.has_index (i) then
				vs := values.twin
				vs [i] := x
				create Result.make_from_arrays (keys, vs)
			else
				create ks.make (keys.lower, keys.upper + 1)
				ks.subcopy (keys, keys.lower, keys.upper, keys.lower)
				ks [ks.upper] := k
				create vs.make (values.lower, values.upper + 1)
				vs.subcopy (values, values.lower, values.upper, values.lower)
				vs [vs.upper] := x
				create Result.make_from_arrays (ks, vs)
			end
		end

	removed (k: K): MML_MAP[K, V]
			-- Current map without the key `k' and the corresponding value.
			-- If `k' doesn't exist, current map.
		local
			ks: V_ARRAY [K]
			vs: V_ARRAY [V]
			i: INTEGER
		do
			i := keys.index_that (agent meq_key (k, ?))
			if keys.has_index (i) then
				create ks.make (keys.lower, keys.upper - 1)
				create vs.make (values.lower, values.upper - 1)
				ks.subcopy (keys, keys.lower, i - 1, ks.lower)
				ks.subcopy (keys, i + 1, keys.upper, i)
				vs.subcopy (values, values.lower, i - 1, vs.lower)
				vs.subcopy (values, i + 1, values.upper, i)
				create Result.make_from_arrays (ks, vs)
			else
				Result := Current
			end
		end

	restricted alias "|" (subdomain: MML_SET [K]): MML_MAP [K, V]
			-- This map with all key-value pairs where key is outside `restriction' removed.
		require
			subdomain_exists: subdomain /= Void
		local
			i, j: INTEGER
			ks: V_ARRAY [K]
			vs: V_ARRAY [V]
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
			ks.resize (ks.lower, j - 1)
			vs.resize (vs.lower, j - 1)
			create Result.make_from_arrays (ks, vs)
		end

	override alias "+" (other: MML_MAP [K, V]): MML_MAP [K, V]
			-- Map that is equal to `other' on its domain and to `Current' on its domain minus the domain of `other'.
		require
			other_exists: other /= Void
		local
			i, j: INTEGER
			ks: V_ARRAY [K]
			vs: V_ARRAY [V]
		do
			create ks.make (1, keys.count + other.keys.count)
			create vs.make (1, values.count + other.values.count)
			ks.subcopy (other.keys, other.keys.lower, other.keys.upper, 1)
			vs.subcopy (other.values, other.values.lower, other.values.upper, 1)
			from
				i := keys.lower
				j := other.keys.upper + 1
			until
				i > keys.upper
			loop
				if not other.keys.has (keys [i]) then
					ks [j] := keys [i]
					vs [j] := values [i]
					j := j + 1
				end
				i := i + 1
			end
			ks.resize (ks.lower, j - 1)
			vs.resize (vs.lower, j - 1)
			create Result.make_from_arrays (ks, vs)
		end

	inverse: MML_RELATION [V, K]
			-- Relation consisting of inverted pairs from `Current'.
		do
			create Result.make_from_arrays (values, keys)
		end

feature {MML_MODEL} -- Implementation
	keys: V_ARRAY [K]
			-- Storage for keys.

	values: V_ARRAY [V]
			-- Storage for values.

	make_from_arrays (ks: V_ARRAY [K]; vs: V_ARRAY [V])
			-- Create with predefined arrays.
		do
			keys := ks
			values := vs
		end

	meq_key (k1, k2: K): BOOLEAN
			-- Are `k1' and `k2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (k1, k2)
		end

	meq_value (v1, v2: V): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end
end