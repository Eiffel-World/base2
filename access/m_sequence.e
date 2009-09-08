note
	description: "Finite data structures that can be traversed linearly in both directions."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_SEQUENCE [E]

inherit
	M_MAPPING [INTEGER, E]
		rename
			item as i_th alias "[]",
			has_key as has_index
		end

	M_STREAM [E]
		redefine
			forth
		end

	M_CURSORED [E]

	M_FINITE [E]
		redefine
			hold_count,
			exists
		end

feature -- Access
	i_th alias "[]" (i: INTEGER): E
			-- Element associated with `i'
		deferred
		end

	item: E
			-- Current element
		do
			Result := i_th (index)
		end

	index: INTEGER
			-- Index of current position
		require
			not_off: not off
		deferred
		end

	first: E
			-- First element
		require
			not_empty: not is_empty
		do
			Result := i_th (1)
		end

	last: E
			-- Last element
		require
			not_empty: not is_empty
		do
			Result := i_th (count)
		end

	has (v: E): BOOLEAN
			-- Is `v' contained?
		do
			save_cursor
			start
			search (v)
			Result := not off
			restore_cursor
		ensure then
			index_of_first: Result = (index_of (v, 1) > 0)
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

	index_of (v: E; i: INTEGER): INTEGER
			-- Index of `i'-th occurence of `v'
		require
			positive_occurrences: i > 0
		local
			occur, pos: INTEGER
		do
			save_cursor
			from
				start
				pos := 1
			until
				off or (occur = i)
			loop
				if item = v then
					occur := occur + 1
				end
				forth
				pos := pos + 1
			end
			if occur = i then
				Result := pos - 1
			end
			restore_cursor
		ensure
			non_negative_result: Result >= 0
			v_at_result: Result > 0 implies i_th (Result) = v
		end

feature -- Status report
	readable: BOOLEAN
			-- Is current element accessable?
		do
			Result := has_index (index)
		end

	is_first: BOOLEAN
			-- Is cursor on the first element?
		do
			Result := (index = 1)
		ensure
			index_is_one: Result = (index = 1)
		end

	is_last: BOOLEAN
			-- Is cursor on the last element?
		do
			Result := (index = count)
		end

feature -- Cursor movement
	start
			-- Move current position to the first element
		do
			go_i_th (1)
		ensure
			first_if_not_empty: not is_empty implies is_first
		end

	finish
			-- Move current position to the last element
		do
			go_i_th (count)
		ensure
			index_set: not is_empty implies is_last
		end

	forth
			-- Move current position to the next element
		do
			go_i_th (index + 1)
		ensure then
			index_increased_until_last: not old is_last implies index = old index + 1
			off_after_last: old is_last implies off
		end

	back
			-- Move current position to the previous element
		require
			not_off: not off
		do
			go_i_th (index - 1)
		ensure
			index_decreased_until_first: not old is_first implies index = old index - 1
			off_after_first: old is_first implies off
		end

	go_i_th (i: INTEGER)
			-- Go to position `i'
		deferred
		ensure
			index_set_if_in_bounds: has_index (i) implies index = i
			off_if_out_of_bounds: not has_index (i) implies off
		end

	go_off
			-- Go to a position that doesn't correspond to any element
		deferred
		ensure
			off: off
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
	item_and_i_th: readable implies (item = i_th (index))
	first: not is_empty implies first = i_th (1)
	last: not is_empty implies last = i_th (count)
	has_index: readable implies has_index (index)
end
