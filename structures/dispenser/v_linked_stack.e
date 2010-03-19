note
	description: "Linked implementation of stacks."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: sequence

class
	V_LINKED_STACK [G]

inherit
	V_STACK [G]
		redefine
			default_create,
			copy
		end

feature {NONE} -- Initialization
	default_create
			-- Create an empty stack.
		do
			create list
		ensure then
			sequence_effect: sequence.is_empty
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize by copying all the items of `other'.
		do
			if other /= Current then
				list := other.list.twin
			end
		ensure then
			sequence_effect: sequence |=| other.sequence
			other_sequence_effect: other.sequence |=| old other.sequence
		end

feature -- Access
	item: G
			-- The top element.
		do
			Result := list.first
		end

feature -- Measurement
	count: INTEGER
			-- Number of elements.
		do
			Result := list.count
		end

feature -- Iteration
	new_iterator: V_INPUT_ITERATOR [G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'.
		do
			create {V_PROXY_ITERATOR [G]} Result.make (Current, list.at_start)
		end

feature -- Extension
	extend (v: G)
			-- Push `v' on the stack.
		do
			list.extend_front (v)
		end

feature -- Removal
	remove
			-- Pop the top element.
		do
			list.remove_front
		end

	wipe_out
			-- Pop all elements.
		do
			list.wipe_out
		end

feature {V_LINKED_STACK} -- Implementation
	list: V_LINKED_LIST [G]
			-- Underlying list.
end
