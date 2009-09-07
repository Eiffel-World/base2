note
	description: "Finite linear data structures that can be replaced, extended and pruned at any position."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_LIST [E]

inherit
	M_SEQUENCE [E]

	M_REPLACEABLE_ACTIVE [E]

	M_PRUNABLE_ACTIVE [E]

	M_SPARSE_BAG [E]
		rename
			extend as extend_front
		undefine
			hold_count,
			exists
		end

feature -- Status report
	writable: BOOLEAN
			-- Can current item be replaced?
		do
			Result := readable
		end

feature -- Replacement
	replace_all (v, u: E)
			-- Replace all occurences of `v' with `u'
		do
			from
				start
				search (v)
			until
				off
			loop
				replace (u)
				search (v)
			end
		end

	fill (v: E)
			-- Replace all elements with `v'
		do
			from
				start
			until
				off
			loop
				replace (v)
				forth
			end
		end

feature -- Element change
	extend_back (v: E)
			-- Add `v' at back
		do
			if is_empty then
				extend_front (v)
			else
				save_cursor
				finish
				extend_right (v)
				restore_cursor
			end
		ensure then
			new_is_last: last = v
		end

	append (other: M_SEQUENCE [E])
			-- Append `other'
		require
			not_void: other /= Void
			not_current: other /= Current
		do
			other.save_cursor
			from
				other.start
			until
				other.off
			loop
				extend_back (other.item)
				other.forth
			end
			other.restore_cursor
		ensure
			more_elements: count = old count + other.count
		end

	extend_front (v: E)
			-- Add `v' at the front
		deferred
		ensure then
			new_is_first: first = v
		end

	prepend (other: M_SEQUENCE [E])
			-- Prepend `other'
		require
			not_void: other /= Void
			not_current: other /= Current
		do
			other.save_cursor
			from
				other.finish
			until
				other.off
			loop
				extend_front (other.item)
				other.back
			end
			other.restore_cursor
		ensure
			more_elements: count = old count + other.count
		end

	extend_left (v: E)
			-- Add `v' to the left of cursor position.
			-- Do not move cursor.
		require
			not_off: not off
		do
			if is_first then
				extend_front (v)
			else
				back
				extend_right (v)
				forth
				forth
			end
		ensure
	 		new_count: count = old count + 1
	 		new_index: index = old index + 1
	 		one_more_occurrence: occurrences (v) = old occurrences (v) + 1
		end

	extend_right (v: E)
			-- Add `v' to the right of cursor position.
			-- Do not move cursor.
		require
			not_off: not off
		deferred
		ensure
	 		new_count: count = old count + 1
	 		same_index: index = old index
	 		one_more_occurrence: occurrences (v) = old occurrences (v) + 1
		end

	merge_left (other: like Current)
			-- Merge `other' into current structure before cursor
			-- position. Do not move cursor. Empty `other'.
		require
			not_off: not off
			other_exists: other /= Void
			not_current: other /= Current
		local
			new_index: INTEGER
		do
			new_index := index + other.count
			back
			merge_right (other)
			from
			until
				index = new_index
			loop
				forth
			end
		ensure
	 		new_count: count = old count + old other.count
	 		new_index: index = old index + old other.count
			other_is_empty: other.is_empty
		end

	merge_right (other: like Current)
			-- Merge `other' into current structure after cursor
			-- position. Do not move cursor. Empty `other'.
		require
			not_off: not off
			other_exists: other /= Void
			not_current: other /= Current
		deferred
		ensure
	 		new_count: count = old count + old other.count
	 		same_index: index = old index
			other_is_empty: other.is_empty
		end

	remove_right
			-- Remove an element to the right from the cursor
		require
			not_last: not is_last
		do
			forth
			remove
		end

	remove_left
			-- Remove an element to the left
		require
			not_first: not is_first
		do
			back
			remove
		end

	remove_back
			-- Remove an element from the back
		require
			not_empty: not is_empty
		do
			finish
			remove
		ensure
			one_less_element: count = old count - 1
			pruned_one: occurrences (old last) = old (occurrences (last)) - 1
		end

	remove_front
			-- Remove an element from the front
		require
			not_empty: not is_empty
		do
			start
			remove
		ensure
			one_less_element: count = old count - 1
			pruned_one: occurrences (old first) = old (occurrences (first)) - 1
		end

	prune_all (v: E)
			-- Remove all occurences of `v'
		do
			from
				start
				search (v)
			until
				off
			loop
				remove
				search (v)
			end
		end

	prune (v: E)
			-- Prune the first occurence of `v' if there is one
		do
			start
			search (v)
			if not off then
				remove
			end
		end

invariant
	readable_is_writable: writable = readable
end
