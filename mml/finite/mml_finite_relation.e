note
	description: "Summary description for {MML_FINITE_RELATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MML_FINITE_RELATION [G, H]

inherit
	MML_RELATION [G, H]

create
	empty

create {MML_MODEL}
	make_from_arrays

feature {NONE} -- Initialization
	empty
			-- Create an empty map
		do
			create keys.make (1, 0)
			create values.make (1, 0)
		end

feature -- Access
	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related `y'?
		local
			i: INTEGER
		do
			from
				i := keys.lower
			until
				i > keys.upper or Result
			loop
				if model_equals (keys [i], x) and model_equals (values [i], y) then
					Result := True
				end
				i := i + 1
			end
		end

	count: INTEGER
			-- Map cardinality
		do
			Result := keys.count
		end

	domain: MML_FINITE_SET [G]
			-- Set of keys
		local
			i: INTEGER
		do
			create Result.empty
			from
				i := keys.lower
			until
				i > keys.upper
			loop
				Result := Result.extended (keys [i])
				i := i + 1
			end
		end

	range: MML_FINITE_SET [H]
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

	image_of (x: G): MML_FINITE_SET [H]
			-- The set of values related to `x'
		local
			i: INTEGER
		do
			create Result.empty
			from
				i := keys.lower
			until
				i > keys.upper
			loop
				if model_equals (keys [i], x) then
					Result := Result.extended (values [i])
				end
				i := i + 1
			end
		end

	image (subdomain: MML_SET [G]): MML_FINITE_SET [H]
			-- The set of values related to keys in `subdomain'
		require
			subdomain_exists: subdomain /= Void
		local
			i: INTEGER
		do
			create Result.empty
			from
				i := keys.lower
			until
				i > keys.upper
			loop
				if subdomain [keys [i]] then
					Result := Result.extended (values [i])
				end
				i := i + 1
			end
		end

feature -- Basic operations
	complement: MML_RELATION [G, H]
			-- Relation consisting of all pairs not in `Current'
		do
			create {MML_AGENT_RELATION [G, H]} Result.such_that (agent (x: G; y: H): BOOLEAN
				do
					Result := not has (x, y)
				end)
		end

	inverse: MML_FINITE_RELATION [H, G]
			-- Relation consisting of inverted pairs from `Current'
		do
			create Result.make_from_arrays (values, keys)
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_FINITE_RELATION [G, H]
			-- Relation consisting of pair contained in both `Current' and `other'
		local
			ks: V_ARRAY [G]
			vs: V_ARRAY [H]
			i, j: INTEGER
		do
			create ks.make (keys.lower, keys.upper)
			create vs.make (values.lower, values.upper)
			from
				i := keys.lower
				j := ks.lower
			until
				i > keys.upper
			loop
				if other [keys [i], values [i]] then
					ks [j] := keys [i]
					vs [j] := values [i]
					j := j + 1
				end
				i := i + 1
			end
			create Result.make_from_arrays (ks.subarray (ks.lower, j - 1), vs.subarray (vs.lower, j - 1))
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is `Current' mathematically equal to `other'?		
		local
			i: INTEGER
		do
			if attached {MML_FINITE_RELATION [G, H]} other as rel and then count = rel.count then
				from
					Result := True
					i := keys.lower
				until
					i > keys.upper or not Result
				loop
					Result := rel [keys [i], values [i]]
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation
	keys: V_ARRAY [G]
	values: V_ARRAY [H]

	make_from_arrays (ks: V_ARRAY [G]; vs: V_ARRAY [H])
			-- Create with a predefined array
		do
			keys := ks
			values := vs
		end
end
