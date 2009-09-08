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
		redefine
			remove
		end

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
	extend_front (v: E)
			-- Add `v' at the front
		deferred
		ensure then
			new_is_first: first = v
		end

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
			one_more_element: count = old count + 1
			one_more_occurrence: occurrences (v) = old occurrences (v) + 1
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

	prepend (other: M_SEQUENCE [E])
			-- Prepend a copy of `other'
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

	append (other: M_SEQUENCE [E])
			-- Append a copy of `other'
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

	prepend_left (other: M_SEQUENCE [E])
			-- Prepend a copy of `other' before the current cursor position
		require
			not_void: other /= Void
			not_current: other /= Current
			not_off: not off
		do
			other.save_cursor
			from
				other.finish
			until
				other.off
			loop
				extend_left (other.item)
				other.back
			end
			other.restore_cursor
		ensure
			more_elements: count = old count + other.count
		end

	append_right (other: M_SEQUENCE [E])
			-- Append a copy of `other' after the current cursor position
		require
			not_void: other /= Void
			not_current: other /= Current
			not_off: not off
		do
			other.save_cursor
			from
				other.start
			until
				other.off
			loop
				extend_right (other.item)
				other.forth
			end
			other.restore_cursor
		ensure
			more_elements: count = old count + other.count
		end

	remove
			-- Remove current element
		deferred
		ensure then
			one_less_element: count = old count - 1
			one_less_occurrence: occurrences (old item) = old occurrences (item) - 1
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

	remove_left
			-- Remove an element to the left
		require
			not_first: not is_first
		do
			back
			remove
		end

	remove_right
			-- Remove an element to the right from the cursor
		require
			not_last: not is_last
		do
			forth
			remove
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
