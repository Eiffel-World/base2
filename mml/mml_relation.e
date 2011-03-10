note
	description: "Finite relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_RELATION [G, H]

inherit
	MML_MODEL

create
	empty,
	singleton

create {MML_MODEL}
	make_from_arrays

feature {NONE} -- Initialization
	empty
			-- Create an empty relation.
		do
			create lefts.make (1, 0)
			create rights.make (1, 0)
		end

	singleton (x: G; y: H)
			-- Create a relation with just one pair <`x', `y'>.
		do
			create lefts.make (1, 1)
			lefts [1] := x
			create rights.make (1, 1)
			rights [1] := y
		end

feature -- Properties
	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related `y'?
		local
			i: INTEGER
		do
			i := lefts.index_that (agent meq_left (x, ?))
			Result := lefts.has_index (i) and then model_equals (rights [i], y)
		end

	is_empty: BOOLEAN
			-- Is map empty?
		do
			Result := lefts.is_empty
		end

feature -- Sets
	range: MML_SET [H]
			-- The set of values related to any value.
		local
			i: INTEGER
		do
			create Result.empty
			from
				i := lefts.lower
			until
				i > lefts.upper
			loop
				Result := Result.extended (rights [i])
				i := i + 1
			end
		end

	image_of (x: G): MML_SET [H]
			-- Set of values related to `x'.
		do
			Result := image (create {MML_SET [G]}.singleton (x))
		end

	image (subdomain: MML_SET [G]): MML_SET [H]
			-- Set of values related to any value in `subdomain'.
		require
			subdomain_exists: subdomain /= Void
		do
			Result := restricted (subdomain).range
		end

feature -- Measurement
	count: INTEGER
			-- Cardinality.
		do
			Result := lefts.count
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Does this relation contain the same pairs as `other'?		
		local
			i: INTEGER
		do
			if attached {MML_RELATION [G, H]} other as rel and then count = rel.count then
				from
					Result := True
					i := lefts.lower
				until
					i > lefts.upper or not Result
				loop
					Result := rel [lefts [i], rights [i]]
					i := i + 1
				end
			end
		end

feature -- Modification
	extended (x: G; y: H): MML_RELATION [G, H]
			-- Current relation extended with pair (`x', `y') if absent.
		local
			ls: V_ARRAY [G]
			rs: V_ARRAY [H]
		do
			if not Current [x, y] then
				create ls.make (1, lefts.count + 1)
				ls.subcopy (lefts, lefts.lower, lefts.upper, 1)
				ls [ls.count] := x
				create rs.make (1, rights.count + 1)
				rs.subcopy (rights, rights.lower, rights.upper, 1)
				rs [rs.count] := y
				create Result.make_from_arrays (ls, rs)
			else
				Result := Current
			end
		end

	removed (x: G; y: H): MML_RELATION [G, H]
			-- Current relation with pair (`x', `y') removed if present.
		local
			ls: V_ARRAY [G]
			rs: V_ARRAY [H]
			i: INTEGER
		do
			i := lefts.index_that (agent meq_left (x, ?))
			if lefts.has_index (i) and then model_equals (y, rights [i]) then
				create ls.make (lefts.lower, lefts.upper - 1)
				ls.subcopy (lefts, lefts.lower, i - 1, ls.lower)
				ls.subcopy (lefts, i + 1, lefts.upper, i)
				create rs.make (rights.lower, rights.upper - 1)
				rs.subcopy (rights, rights.lower, i - 1, rs.lower)
				rs.subcopy (rights, i + 1, rights.upper, i)
				create Result.make_from_arrays (ls, rs)
			else
				Result := Current
			end
		end

	restricted alias "|" (subdomain: MML_SET [G]): MML_RELATION [G, H]
			-- Relation that consists of all pairs in `Current' whose left component is in `subdomain'.
		require
			subdomain_exists: subdomain /= Void
		local
			ls: V_ARRAY [G]
			rs: V_ARRAY [H]
			i, j: INTEGER
		do
			create ls.make (lefts.lower, lefts.upper)
			create rs.make (rights.lower, rights.upper)
			from
				i := lefts.lower
				j := ls.lower
			until
				i > lefts.upper
			loop
				if subdomain [lefts [i]] then
					ls [j] := lefts [i]
					rs [j] := rights [i]
					j := j + 1
				end
				i := i + 1
			end
			ls.resize (ls.lower, j - 1)
			rs.resize (rs.lower, j - 1)
			create Result.make_from_arrays (ls, rs)
		end

	inverse: MML_RELATION [H, G]
			-- Relation that consists of inverted pairs from `Current'.
		do
			create Result.make_from_arrays (rights, lefts)
		end

	union alias "+" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other'.
		require
			other_exists: other /= Void
		do
			Result := Current - other
			Result.lefts.resize (Result.lefts.lower, Result.lefts.upper + other.lefts.count)
			Result.rights.resize (Result.rights.lower, Result.rights.upper + other.rights.count)
			Result.lefts.subcopy (other.lefts, other.lefts.lower, other.lefts.upper, Result.count - other.count + 1)
			Result.rights.subcopy (other.rights, other.rights.lower, other.rights.upper, Result.count - other.count + 1)
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in both `Current' and `other'.
		require
			other_exists: other /= Void
		local
			ls: V_ARRAY [G]
			rs: V_ARRAY [H]
			i, j: INTEGER
		do
			create ls.make (lefts.lower, lefts.upper)
			create rs.make (rights.lower, rights.upper)
			from
				i := lefts.lower
				j := ls.lower
			until
				i > lefts.upper
			loop
				if other [lefts [i], rights [i]] then
					ls [j] := lefts [i]
					rs [j] := rights [i]
					j := j + 1
				end
				i := i + 1
			end
			ls.resize (ls.lower, j - 1)
			rs.resize (rs.lower, j - 1)
			create Result.make_from_arrays (ls, rs)
		end

	difference alias "-" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in `Current' but not in `other'.
		require
			other_exists: other /= Void
		local
			ls: V_ARRAY [G]
			rs: V_ARRAY [H]
			i, j: INTEGER
		do
			create ls.make (lefts.lower, lefts.upper)
			create rs.make (rights.lower, rights.upper)
			from
				i := lefts.lower
				j := ls.lower
			until
				i > lefts.upper
			loop
				if not other [lefts [i], rights [i]] then
					ls [j] := lefts [i]
					rs [j] := rights [i]
					j := j + 1
				end
				i := i + 1
			end
			ls.resize (ls.lower, j - 1)
			rs.resize (rs.lower, j - 1)
			create Result.make_from_arrays (ls, rs)
		end

	sym_difference alias "^" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other', but not in both.
		require
			other_exists: other /= Void
		do
			Result := (Current + other) - (Current * other)
		end

feature {MML_MODEL} -- Implementation
	lefts: V_ARRAY [G]
			-- Storage for the left components of pairs.

	rights: V_ARRAY [H]
			-- Storage for the right components of pairs.


	make_from_arrays (ls: V_ARRAY [G]; rs: V_ARRAY [H])
			-- Create with predefined arrays.
		do
			lefts := ls
			rights := rs
		end

	meq_left (v1, v2: G): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end

	meq_right (v1, v2: H): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end
end
