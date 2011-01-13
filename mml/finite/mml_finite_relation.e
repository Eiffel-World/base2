note
	description: "Finite relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_FINITE_RELATION [G, H]

inherit
	MML_RELATION [G, H]

	MML_FINITE

create
	empty

create {MML_MODEL}
	make_from_arrays

feature {NONE} -- Initialization
	empty
			-- Create an empty relation.
		do
			create lefts.make (1, 0)
			create rights.make (1, 0)
		end

feature -- Access
	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related `y'?
		local
			i: INTEGER
		do
			from
				i := lefts.lower
			until
				i > lefts.upper or Result
			loop
				if model_equals (lefts [i], x) and model_equals (rights [i], y) then
					Result := True
				end
				i := i + 1
			end
		end

	count: INTEGER
			-- Cardinality.
		do
			Result := lefts.count
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
					i := lefts.lower
				until
					i > lefts.upper or not Result
				loop
					Result := rel [lefts [i], rights [i]]
					i := i + 1
				end
			end
		end

feature -- Sets
	range: MML_FINITE_SET [H]
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

	image_of (x: G): MML_FINITE_SET [H]
			-- Set of values related to `x'.
		local
			i: INTEGER
		do
			create Result.empty
			from
				i := lefts.lower
			until
				i > lefts.upper
			loop
				if model_equals (lefts [i], x) then
					Result := Result.extended (rights [i])
				end
				i := i + 1
			end
		end

	image (subdomain: MML_SET [G]): MML_FINITE_SET [H]
			-- Set of values related to any value in `subdomain'.
		require
			subdomain_exists: subdomain /= Void
		do
			Result := restricted (subdomain).range
		end

feature -- Basic operations
	restricted alias "|" (subdomain: MML_SET [G]): MML_FINITE_RELATION [G, H]
			-- Relation that consists of all pairs in `Current' whose left component is in `subdomain'.
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
		
	complement: MML_RELATION [G, H]
			-- Relation that consists of all pairs not in `Current'.
		do
			create {MML_AGENT_RELATION [G, H]} Result.such_that (agent (x: G; y: H): BOOLEAN
				do
					Result := not has (x, y)
				end)
		end

	inverse: MML_FINITE_RELATION [H, G]
			-- Relation that consists of inverted pairs from `Current'.
		do
			create Result.make_from_arrays (rights, lefts)
		end

	union alias "+" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other'.
		do
			create {MML_AGENT_RELATION [G, H]} Result.such_that (agent (x: G; y: H; o: MML_RELATION [G, H]): BOOLEAN
				do
					Result := has (x, y) or o.has (x, y)
				end (?, ?, other))
		end

	finite_union alias "|+|" (other: MML_FINITE_RELATION [G, H]): MML_FINITE_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other'.
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
			ls.resize (ls.lower, j - 1 + other.lefts.count)
			rs.resize (rs.lower, j - 1 + other.rights.count)
			ls.subcopy (other.lefts, other.lefts.lower, other.lefts.upper, j + other.lefts.count)
			rs.subcopy (other.rights, other.rights.lower, other.rights.upper, j + other.rights.count)
			create Result.make_from_arrays (ls, rs)
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_FINITE_RELATION [G, H]
			-- Relation that consists of pair contained in both `Current' and `other'
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
end
