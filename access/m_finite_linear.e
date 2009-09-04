note
	description: "Finite data structures that can be traversed linearly in both directions."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_FINITE_LINEAR [E]

inherit
	M_LINEAR [E]
		redefine
			forth
		end

	M_FINITE [E]
		redefine
			hold_count,
			exists
		end

feature -- Access
	last: E
			-- Last element
		require
			not_empty: not is_empty
		do
			Result := i_th (count)
		end

	occurrences (v: like item): INTEGER
			-- Number of times `v' appears
		do
			save_cursor
			from
				start
				search (v)
			until
				off
			loop
				Result := Result + 1
				forth
				search (v)
			end
			restore_cursor
		end

	has_index (i: INTEGER): BOOLEAN
			-- Is there an element associated with `i'?
		do
			Result := i >= 1 and i <= count
		ensure then
			if_in_bounds: Result = (i >= 1 and i <= count)
		end

feature -- Status report
	is_last: BOOLEAN
			-- Is cursor on the last element?
		do
			Result := (index = count)
		end

feature -- Cursor movement
	finish
			-- Move current position to the last element
		deferred
		ensure
			index_set: index = count
		end

	forth
			-- Move current position to the next element
		deferred
		ensure then
			index_increased_until_last: not old is_last implies index = old index + 1
			off_after_last: old is_last implies off
		end

feature -- Quantifiers
	hold_count (p: PREDICATE [ANY, TUPLE [E]]): INTEGER is
			-- Number of elements for which `p' holds
		do
			save_cursor
			Result := Precursor (p)
			restore_cursor
		end

	exists (p: PREDICATE [ANY, TUPLE [E]]): BOOLEAN is
			-- Does `p' hold for any element?
		do
			save_cursor
			from
				start
			until
				off or Result
			loop
				Result := p.item ([item])
				forth
			end
			restore_cursor
		end

feature -- Iteration
	do_if (action: PROCEDURE [ANY, TUPLE [E]]; p: PREDICATE [ANY, TUPLE [E]]) is
			-- Call `action' for elements that satisfy `p'
		do
			from
				start
			until
				off
			loop
				if p.item ([item]) then
					action.call ([item])
				end
				forth
			end
		end

invariant
	last: not is_empty implies last = i_th (count)
	index_not_too_large: index <= count + 1
	readable_index: readable = (index >= 1 and index <= count) -- Theorem
end
