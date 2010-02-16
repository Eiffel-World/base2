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
			-- Create an empty stack
		do
			create list
		end

feature -- Initialization
	copy (other: like Current)
			-- Reinitialize by copying all the items of `other'.
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
			-- The accessable element
		do
			Result := list.first
		end

feature -- Measurement
	count: INTEGER
			-- Number of elements
		do
			Result := list.count
		end

feature -- Iteration
	at_start: V_INPUT_ITERATOR [G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'
		do
			create {V_PROXY_ITERATOR [G]} Result.make (Current, list.at_start)
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the dispenser
		do
			list.extend_front (v)
		end

feature -- Removal
	remove
			-- Remove the accessible element
		do
			list.remove_front
		end

	wipe_out
			-- Remove all elements
		do
			list.wipe_out
		end

feature {V_LINKED_STACK} -- Implementation
	list: V_LINKED_LIST [G]
			-- Underlying list
end
