note
	description: "Tables indexed by integers in an interval."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_ARRAY [E]

inherit
	M_TABLE [INTEGER, E]
		rename
			item as i_th alias "[]",
			has_key as has_index
		undefine
			is_empty
		select
			has,
			occurrences,
			do_if,
			do_all,
			hold_count,
			exists,
			for_all
		end

	M_MAPPING [INTEGER, E]
		rename
			item as i_th alias "[]",
			has_key as has_index
		end

	M_INTEGER_INTERVAL
		rename
			has as has_index,
			occurrences as occurrences_index,
			do_all as do_all_index,
			do_if as do_if_index,
			exists as exists_index,
			for_all as for_all_index,
			hold_count as hold_count_index
		redefine
			include, set_bounds, wipe_out
		end

create
	set_bounds, wipe_out

feature -- Access
	i_th alias "[]" (i: INTEGER): E
			-- Element associated with `key'
		do
			Result := internal_array [i]
		end

	has (v: E): BOOLEAN
			-- Is `v' contained?
		local
			i: INTEGER
		do
			from
				i := lower
			until
				i > upper or Result
			loop
				Result := i_th (i) = v
				i := i + 1
			end
		end

	occurrences (v: E): INTEGER
			-- Number of times `v' appears
		local
			i: INTEGER
		do
			from
				i := lower
			until
				i > upper
			loop
				if i_th (i) = v then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Replacement
	replace (i: INTEGER; v: E)
			-- Reassociate `i' with `v'
		do
			internal_array.put (v, i)
		end

	replace_all (v, u: E)
			-- Replace all occurences of `v' with `u'
		local
			i: INTEGER
		do
			from
				i := lower
			until
				i > upper
			loop
				if i_th (i) = v then
					replace (i, u)
				end
				i := i + 1
			end
		end

	fill (v: E)
			-- Replace all elements with `v'
		local
			i: INTEGER
		do
			from
				i := lower
			until
				i > upper
			loop
				replace (i, v)
				i := i + 1
			end
		end

feature -- Element change
	include (i: INTEGER)
			-- Extend in a minimal way so that index `i' is contained
		do
			if is_empty then
				internal_array.conservative_resize (i, i)
			else
				internal_array.conservative_resize (i.min (lower), i.max (upper))
			end
			Precursor (i)
		end

	set_bounds (l, u: INTEGER)
			-- Make `l' and `u' new bounds
		do
			if internal_array = Void then
				create internal_array.make (l, u)
			else
				internal_array.conservative_resize (l, u)
			end
			Precursor (l, u)
		end

	wipe_out
			-- Make empty
		do
			if internal_array = Void then
				create internal_array.make (1, 0)
			end
			Precursor
		end

feature -- Iteration
	do_if (action: PROCEDURE [ANY, TUPLE [E]]; p: PREDICATE [ANY, TUPLE [E]]) is
			-- Call `action' for elements that satisfy `p'
		local
			i: INTEGER
		do
			from
				i := lower
			until
				i > upper
			loop
				if p.item ([i_th (i)]) then
					action.call ([i_th (i)])
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation
	internal_array: ARRAY [E]
end
