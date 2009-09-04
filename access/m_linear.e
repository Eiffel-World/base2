note
	description: "Data structures that can be traversed linearly."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_LINEAR [E]

inherit
	M_CURSORED [E]

	M_MAPPING [INTEGER, E]
		rename
			item as i_th alias "[]",
			has_key as has_index
		end

feature -- Access
	first: E
			-- First element
		require
			not_empty: not is_empty
		do
			Result := i_th (1)
		end

	item: E
			-- Current element
		do
			Result := i_th (index)
		end

	i_th alias "[]" (i: INTEGER): E
			-- Element associated with `i'
		do
			save_cursor
			go_i_th (i)
			Result := item
			restore_cursor
		end

	index: INTEGER
			-- Index of current position
		deferred
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

feature -- Cursor movement
	start
			-- Move current position to the first element
		deferred
		ensure
			first_if_not_empty: not is_empty implies is_first
		end

	forth
			-- Move current position to the next element
		require
			not_off: not off
		deferred
		ensure
			index_increased_or_off: off or index = old index + 1
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

	search (v: like item)
			-- Move to first position (at or after current position) where `item' and `v' are equal.
		require
			not_off: readable
		do
			from
			until
				off or else v = item
			loop
				forth
			end
		ensure
			item_found: not off implies v = item
		end

	go_i_th (i: INTEGER)
			-- Go to position `i'
		do
			if has_index (i) then
				from
					start
				until
					index = i
				loop
					forth
				end
			else
				go_off
			end
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

invariant
	first: not is_empty implies first = i_th (1)
	index_non_negative: index >= 0
	has_index: readable = has_index (index)
	item_and_i_th: readable implies (item = i_th (index))
end
