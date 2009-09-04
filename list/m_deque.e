note
	description: "Finite linear data structures that can be extended and pruned at end and at front."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_DEQUE [E]

inherit
	M_SEQUENCE [E]
		rename
			extend as extend_back
		select
			extend_back
		end

	M_EXTENDIBLE_BAG [E]
		rename
			extend as extend_front
		undefine
			hold_count,
			exists
		redefine
			extend_front
		end

	M_SPARSE_PRUNABLE [E]

feature -- Element change
	extend_front (v: E)
			-- Add `v' at the front
		deferred
		ensure then
			new_is_first: first = v
		end

	prepend (other: M_FINITE_LINEAR [E])
			-- Prepend `other'
		require
			enough_space: has_space_for (other.count)
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

	remove_back
			-- Remove an element from the back
		require
			not_empty: not is_empty
		deferred
		ensure
			one_less_element: count = old count - 1
			pruned_one: occurrences (old last) = old (occurrences (last)) - 1
		end

	remove_front
			-- Remove an element from the front
		require
			not_empty: not is_empty
		deferred
		ensure
			one_less_element: count = old count - 1
			pruned_one: occurrences (old first) = old (occurrences (first)) - 1
		end
end
