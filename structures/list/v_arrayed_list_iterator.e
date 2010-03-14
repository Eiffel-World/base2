note
	description: "Iterators over arrayed lists."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, index

class
	V_ARRAYED_LIST_ITERATOR [G]

inherit
	V_LIST_ITERATOR [G]
		undefine
			go_to,
			copy
		end

	V_INDEX_ITERATOR [G]

create {V_ARRAYED_LIST}
	make

feature {NONE} -- Initialization
	make (list: V_ARRAYED_LIST [G]; i: INTEGER)
			-- Create an iterator at position `i' in `list'.
		require
			list_exists: list /= Void
			i_valid: 0 <= i and i <= list.count + 1
		do
			target := list
			index := i
		ensure
			target_effect: target = list
			index_effect: index = i
		end

feature -- Access
	target: V_ARRAYED_LIST [G]
			-- Container to iterate over.

feature -- Extension
	extend_left (v: G)
			-- Insert `v' to the left of current position. Do not move cursor.
		do
			target.extend_at (index, v)
			index := index + 1
		end

	extend_right (v: G)
			-- Insert `v' to the right of current position. Do not move cursor.
		do
			target.extend_at (index + 1, v)
		end

	insert_left (other: V_INPUT_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates to the left of current position. Do not move cursor.
		local
			old_other_count: INTEGER
		do
			old_other_count := other.count
			target.insert_at (index, other)
			index := index + old_other_count
		end

	insert_right (other: V_INPUT_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates to the right of current position. Move cursor to the last element of inserted sequence.
		local
			old_other_count: INTEGER
		do
			old_other_count := other.count
			target.insert_at (index + 1, other)
			index := index + old_other_count
		end

feature -- Removal
	remove
			-- Remove element at current position. Move cursor to the next position.
		do
			target.remove_at (index)
		end

	remove_left
			-- Remove element to the left current position. Do not move cursor.
		do
			target.remove_at (index - 1)
			index := index - 1
		end

	remove_right
			-- Remove element to the right current position. Do not move cursor.
		do
			target.remove_at (index + 1)
		end
end
